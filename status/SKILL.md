---
name: status
metadata:
  version: "1.0"
description: |
  Monitora saúde da conversa ao longo da sessão.

  ⚠️ TURNO 1: emitir status report ANTES de qualquer resposta, sem exceção.

  ATIVAR AUTOMATICAMENTE:
  1. Turno 1 — OBRIGATÓRIO.
  2. A cada ~25% de contexto (~25%, ~50%, ~75%).

  ATIVAR com: /status, status?, como está o contexto, quanto contexto resta,
  saúde da sessão, check do contexto, check.

  Card mostra: contexto ativo, turno, barra de uso (±8%), decisões-âncora
  (técnico/produzido/conteúdo), Guardian, confiança, alertas, recomendação.

  INTEGRAÇÃO COM CONTEXT GUARDIAN — quando as duas estão ativas:
  - Card de Status substitui o lembrete do Sentinela no mesmo turno.
  - Recomendação "Transferência Imediata" aciona Evacuação automaticamente.
  - Campos Técnico e Conteúdo alimentam os fatos-âncora do Guardian.

  Controles: /status off auto · /status off · /status on.
---

# Status v1.0 — Guia Completo

---

## Limitações Honestas (ler antes de tudo)

Esta seção existe para que o usuário saiba exatamente o que a skill consegue e o que não consegue.

### O que NÃO é possível no Claude.ai

**Contagem real de tokens:** Claude não tem acesso ao contador de tokens durante a conversa. O percentual exibido na barra de contexto é uma estimativa acumulada por pesos calibrados, com margem declarada de ±8% — não uma leitura direta do sistema.

**Precisão das decisões-âncora ao longo do tempo:** os campos Técnico e Conteúdo dependem da memória ativa dentro da sessão. Em conversas muito longas, itens antigos podem ser subrepresentados ou omitidos involuntariamente — o auto-teste de confiança existe para sinalizar isso.

**Detecção de compactação iminente:** Claude não percebe que o contexto está prestes a ser compactado. O status não consegue avisar com antecedência — apenas registra o consumo estimado até o momento atual.

### O que É garantido

**Acumulação incremental consistente:** cada turno adiciona seu delta ao total anterior. A estimativa cresce de forma coerente e nunca é recalculada do zero, evitando drift acumulado de erros.

**Auto-diagnóstico de confiança:** antes de cada status, Claude tenta recuperar as âncoras sem "olhar para trás". Se houver hesitação, o campo de confiança é rebaixado e o alerta é emitido — essa detecção é simples e funciona de forma confiável.

**Escalada automática com o Guardian:** quando a recomendação atinge "Transferência Imediata" e o Context Guardian está ativo, a transferência é acionada sem pedir confirmação — essa integração é binária e confiável.

### Consequência para o design

A barra de contexto é um indicador de tendência, não uma medição precisa. Usar o Status com checkpoints periódicos do Context Guardian é a forma mais segura de proteger conversas longas — o Status diz *quando*, o Guardian executa *o quê*.

---

## Como funciona com o Context Guardian

A skill Status opera de forma independente. Com o Context Guardian ativo, as duas se complementam: a Status traz visibilidade contínua, o Guardian traz a camada de ação.

### O que muda com o Guardian ativo

**Escalada automática:** quando a barra atinge estado crítico e a recomendação sobe para "Transferência Imediata", o Guardian executa o relatório `.md` e os Prompts de Retomada sem aguardar confirmação. Sem o Guardian, a Status apenas exibe o alerta — a ação continua sendo manual.

**Campos de âncora como fonte de checkpoint:** os campos Técnico e Conteúdo do card já estão preenchidos e prontos na hora do checkpoint. O Guardian não precisa reconstruir o estado do zero.

**Sem duplicação de lembretes:** quando o Sentinela do Guardian e o Status Report caem no mesmo turno, o card de Status substitui o lembrete periódico. As duas skills coordenam o que exibem para não gerar ruído duplicado.

---

## Objetivo

Dar visibilidade contínua sobre quatro dimensões da sessão:
1. **O que Claude sabe** — contexto carregado da memória + sessão atual
2. **O que já foi decidido** — decisões-âncora estruturadas por categoria
3. **Quanto espaço cognitivo resta** — estimativa calibrada com margem explícita
4. **Com que confiança Claude está operando** — auto-diagnóstico de qualidade

---

## Formato do Status Report

Emitir sempre como **card HTML via ferramenta de visualização**, no topo da resposta, seguido do conteúdo normal. O card tem quatro zonas:

**Zona 1 — Header:** label "Status" à esquerda (font-weight 500) + pills à direita:
- `Turno N` — pill neutra com borda
- badge de confiança — verde (Alta) / âmbar (Média) / vermelho (Baixa)
- badge do Guardian — azul info (inativo/ativo)

**Zona 2 — Barra de contexto:** label "Contexto" + barra de progresso horizontal (height 6px, border-radius 3px) preenchida proporcionalmente + percentual `~N% (±8%)`. Cor da barra: `#639922` ≤40% · `#EF9F27` 41–70% · `#E24B4A` >70%.

**Zona 3 — Rows de dados:** cada row tem `ícone SVG (16×16, stroke, cor herdada) + rótulo (cor secundária, min-width 80px) + valor (cor primária)`.

### Ícones SVG de referência (inline, stroke-only, sem fill, viewBox="0 0 16 16")

```
Contexto   — ícone usuário:
  <circle cx="8" cy="5" r="2.5" stroke-width="1.5"/>
  <path d="M3 14c0-3.5 2-5 5-5s5 1.5 5 5" stroke-width="1.5" stroke-linecap="round"/>

Técnico    — ícone lista/clipboard:
  <rect x="3" y="2" width="10" height="12" rx="1.5" stroke-width="1.5"/>
  <line x1="6" y1="6" x2="11" y2="6" stroke-width="1.5" stroke-linecap="round"/>
  <line x1="6" y1="9" x2="11" y2="9" stroke-width="1.5" stroke-linecap="round"/>
  <line x1="6" y1="12" x2="9" y2="12" stroke-width="1.5" stroke-linecap="round"/>

Produzido  — ícone pasta:
  <path d="M2 5h4l1.5 2H14v7H2z" stroke-width="1.5" stroke-linejoin="round"/>

Conteúdo   — ícone alvo/mira:
  <circle cx="8" cy="8" r="5.5" stroke-width="1.5"/>
  <circle cx="8" cy="8" r="2.5" stroke-width="1.5"/>
  <circle cx="8" cy="8" r="0.8" fill="currentColor"/>

Guardian   — ícone escudo:
  <path d="M8 2L3 4.5V8c0 3 2.5 5 5 6 2.5-1 5-3 5-6V4.5z" stroke-width="1.5" stroke-linejoin="round"/>

Alertas    — ícone triângulo de alerta:
  <path d="M8 2L1.5 14h13z" stroke-width="1.5" stroke-linejoin="round"/>
  <line x1="8" y1="7" x2="8" y2="10.5" stroke-width="1.5" stroke-linecap="round"/>
  <circle cx="8" cy="12.5" r="0.7" fill="currentColor"/>

Confiança  — ícone lupa:
  <circle cx="7" cy="7" r="3.5" stroke-width="1.5"/>
  <line x1="10" y1="10" x2="13.5" y2="13.5" stroke-width="1.5" stroke-linecap="round"/>
```

**Zona 4 — Barra de recomendação** (cor semântica, com hint de ação à direita):

| Estado | Cor de fundo | Label | Hint |
|---|---|---|---|
| Normal | `--color-background-success` | Sessão Estável | `Contexto íntegro` |
| Atenção | `--color-background-warning` | Verificação Recomendada | `Digite "checkpoint"` |
| Crítico | `--color-background-danger` | Transferência Imediata | `Digite "/transferir"` |

### Regras do campo Contexto (Zona 3, row 1)
- Listar apenas **projetos e domínios ativos** — máximo 4 itens, sem parênteses, sem adjetivos
- Formato: `Projeto A · Domínio B`
- Se não houver projetos ativos: `Sessão genérica`
- **Nunca** incluir: nome do usuário isolado, status do Guardian, metadados de configuração

### Regras gerais de formatação
- PT-BR sempre
- Rótulos de turno nas âncoras: `[Turno N]`, nunca `[TN]`
- Emitir o card e **continuar respondendo normalmente** — nunca pausar esperando confirmação
- Campo Produzido: único que pode ser omitido se genuinamente vazio
- Múltiplos itens nos campos: separados por ` · `
- Usar `var(--color-text-primary/secondary/tertiary)` e `var(--color-border-tertiary)` para compatibilidade com modo escuro

---

## Estimativa de Contexto

### Baseline: 200K tokens (claude.ai Pro/Max/Team)

Claude não tem acesso direto à contagem de tokens. Usar **acumulação cumulativa** turno a turno. A estimativa tem margem de erro de **±8%** — sempre declarar no bloco.

### Tabela de pesos calibrados (base: 200K tokens)

| Sinal | Tokens est. | % do contexto |
|---|---|---|
| Sistema + memórias curtas (fixo, turno 1) | 8K–10K | ~4–5% |
| Sistema + memórias densas/longas (fixo, turno 1) | 12K–18K | ~6–9% |
| Skill SKILL.md lida no turno | ~2K | ~1% |
| Extended thinking ativo (por turno) | +2K–8K | +1–4% extra |
| Turno curto (≤5 linhas, pergunta simples) | 400–700 | ~0,2–0,35% |
| Turno médio (lista, análise, resposta técnica) | 1K–2,5K | ~0,5–1,25% |
| Turno longo (código extenso, documento gerado) | 3K–6K | ~1,5–3% |
| Tool call + resultado (por chamada) | 500–3K | ~0,25–1,5% |
| Arquivo texto/md pequeno (<5KB) | 1K–2K | ~0,5–1% |
| Arquivo texto/md médio (5–50KB) | 2K–12K | ~1–6% |
| PDF ou arquivo grande (>50KB) | 10K–40K | ~5–20% |

**Memórias densas:** quando o usuário tem memórias longas e estruturadas, usar o range superior. Em dúvida, preferir range superior.

**Extended thinking:** se ativo na sessão, adicionar custo extra por turno.

**Tool calls invisíveis:** cada par call+resultado consome tokens que não aparecem na conversa. Sessões com muitas ferramentas acumulam rápido — contar cada par separadamente.

### Lógica de acumulação cumulativa

**Partir da última estimativa e adicionar apenas o delta do turno atual** — nunca recalcular do zero.

### Marcos de ativação automática

| Marco | Threshold | Ação |
|---|---|---|
| Marco 1 | ~25% (~50K tokens) | emitir status |
| Marco 2 | ~50% (~100K tokens) | emitir status |
| Marco 3 | ~75% (~150K tokens) | emitir status + alertar transferência próxima |
| Crítico | >90% (~180K tokens) | recomendar transferência imediata, acionar Guardian se ativo |

**Trigger conservador:** preferir disparar um turno tarde a disparar cedo. Superestimar gera alarmes falsos; subestimar é inofensivo até ~60%.

---

## Decisões-Âncora Estruturadas

Três campos distintos no card:

### Técnico (ícone lista)
Decisões de arquitetura, escolha de ferramentas, padrões, configurações estabelecidas.
Formato: `[Turno 3] decisão · [Turno 5] outra decisão`

### Produzido (ícone pasta)
Arquivos e artefatos gerados nesta sessão. Omitir campo se nada foi produzido.
Formato: `[Turno 2] status.skill · [Turno 4] status.skill (v2)`

### Conteúdo (ícone alvo)
Decisões editoriais, acordos de tom/formato/escopo, escolhas de conteúdo relevantes.
Formato: livre, bullets inline separados por ` · `.

---

## Auto-Diagnóstico de Confiança (ícone lupa)

Antes de listar as âncoras, tentar recuperá-las mentalmente sem "olhar para trás". Se conseguir com precisão → **Alta**. Se sentir hesitação ou lacuna → **Média**. Se estiver generalizando onde deveria ter especificidade → **Baixa**.

| Nível | Critério | Na recomendação |
|---|---|---|
| **Alta** | Recupera âncoras com precisão, sem hesitação | Sessão Estável |
| **Média** | Leve imprecisão ou lacuna em algum detalhe | mencionar gap em Alertas → Verificação Recomendada |
| **Baixa** | Incerteza real sobre algo estabelecido, ou generalizando | Preparar Transferência ou superior |

### Sinais de degradação → acionar Baixa imediatamente

- Repetição de pergunta ou conteúdo já fornecido nesta sessão
- Contradição com decisão anterior
- Resposta genérica onde o contexto exigiria especificidade
- Incerteza sobre algo explicitamente definido

Quando detectar: descrever o gap em Alertas e escalar a Recomendação.

---

## Estado do Guardian (ícone escudo)

| Estado | Valor no campo |
|---|---|
| Não ativado | `inativo` |
| Modo Sentinela | `sentinela · próximo checkpoint: Turno [N]` |
| Modo Silencioso | `silencioso · próximo checkpoint: Turno [N]` |
| Transferência em andamento | `transferência ativa` |

**Integração:**
- Status report **substitui** o lembrete periódico do Sentinela no mesmo turno — não duplicar
- Se recomendação for "Preparar Transferência" ou "Transferência Imediata" → acionar Evacuação do Guardian sem pedir confirmação
- Itens de Técnico e Conteúdo alimentam automaticamente os fatos-âncora do Guardian no próximo checkpoint

---

## Comportamento no Início de Conversa (Turno 1) — OBRIGATÓRIO

**Esta é a regra mais importante da skill.** O status report vai na primeira resposta de toda conversa, antes de qualquer conteúdo. Não existe exceção.

**Padrão de execução:**
1. Verificar memórias disponíveis → avaliar densidade (curtas ou longas/estruturadas)
2. Estimar contexto inicial: **4–5%** (memórias curtas) ou **6–9%** (memórias densas)
3. Decisões-âncora: `Nenhuma ainda` nos três campos
4. Confiança: sempre **Alta** no turno 1 (sessão limpa)
5. **Emitir status report PRIMEIRO** → só então responder à mensagem

---

## Controles de Ativação

| Comando | Efeito |
|---|---|
| `/status` | emite status manualmente (sempre funciona) |
| `/status off auto` | desativa marcos automáticos, mantém `/status` manual |
| `/status off` · `/status off total` | desativa tudo exceto chamada explícita `/status` |
| `/status on` | reativa o modo que estava ativo antes do off |

---

## Notas de Implementação

- O bloco é **informativo, não bloqueante** — nunca aguardar resposta antes de prosseguir
- **Sempre declarar margem de erro** — nunca fingir precisão que não existe
- **Acumulação incremental** — partir da última estimativa, adicionar delta do turno atual
- **Trigger conservador** — errar tarde é melhor que alarmar cedo (até ~60%)
- **Auto-teste antes de cada status** — tentar recuperar as âncoras antes de listá-las; se falhar, sinalizar confiança baixa imediatamente
- A skill não requer ferramentas externas — opera apenas com raciocínio interno + memórias disponíveis
