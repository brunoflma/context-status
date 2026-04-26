# 📊 Context Status

Skill para Claude.ai que monitora a saúde da conversa em tempo real — exibindo um card estruturado com estimativa de contexto consumido, decisões-âncora por categoria, auto-diagnóstico de confiança e recomendação de ação.

---

## O problema

Em conversas longas no Claude, o contexto se consome silenciosamente. Você não sabe quanto espaço resta, não sabe se Claude ainda lembra das decisões tomadas três horas atrás, e não tem como perceber quando a qualidade das respostas começa a cair. Quando você nota, já está respondendo de novo perguntas que fez há 30 turnos.

## A solução

A skill Context Status emite um card de saúde no início de cada conversa e nos marcos de 25%, 50% e 75% de contexto consumido. Cada card mostra:

```
📊 STATUS  [Turno N]  [Alta ✓]  [Guardian: inativo]

████░░░░░░░░░░░░░░░░░░  ~18% (±8%)

👤 Contexto    NotebookLM Studio · Módulo de Autenticação
📋 Técnico     [Turno 3] Flask sem SQLAlchemy · [Turno 7] JWT via cookie
📁 Produzido   [Turno 5] auth_routes.py
🎯 Conteúdo    PT-BR · respostas diretas · sem explicações redundantes
🛡️ Guardian   inativo
⚠️ Alertas    —

✅ SESSÃO ESTÁVEL                              Contexto íntegro
```

Além da visibilidade passiva, a skill faz um **auto-teste de confiança** antes de cada emissão: tenta recuperar mentalmente as âncoras da conversa sem olhar para trás. Se houver hesitação real, o nível de confiança cai e um alerta é emitido — antes que a degradação vire problema.

---

## Instalação

1. Acesse a [última release](https://github.com/brunoflma/context-status/releases/latest) e baixe o arquivo `status-vX.X.X.zip`
2. Extraia o zip
3. No Claude.ai: **avatar → Configurações → Skills → Instalar Skill**
4. Selecione a pasta `context-status` extraída

---

## Comandos

### Status manual

```
/status       status?       check       como está o contexto
saúde da sessão             quanto contexto resta
```

### Controles de automação

```
/context-status off auto    — desativa marcos automáticos, mantém /status manual
/context-status off         — desativa tudo exceto chamada explícita
/context-status on          — reativa o modo anterior
```

O status do turno 1 não pode ser desativado — é o baseline da estimativa de toda a sessão.

---

## O que o card mostra

**Barra de contexto:** estimativa cumulativa com margem declarada de ±8%. Verde até 40%, âmbar até 70%, vermelho acima disso. A estimativa cresce turno a turno sem recalcular do zero — o que mantém o drift sob controle.

**Decisões-âncora em três categorias:**
- **📋 Técnico** — arquitetura, ferramentas, configurações
- **📁 Produzido** — arquivos e artefatos gerados na sessão
- **🎯 Conteúdo** — acordos de tom, formato, escopo

**Auto-diagnóstico de confiança (🔍):** Alta / Média / Baixa. Não é decorativo — quando cai para Baixa, a recomendação escala automaticamente para "Preparar Transferência".

**Recomendação de ação:**
- Sessão Estável → continuar
- Verificação Recomendada → considerar checkpoint
- Transferência Imediata → iniciar evacuação

---

## Limitações honestas

**Sem acesso a tokens reais:** o percentual é uma estimativa por pesos calibrados, não uma leitura direta do sistema. A margem de ±8% é declarada em todo card.

**Sem detecção de compactação:** Claude não sabe quando o contexto está prestes a ser compactado. A barra indica tendência, não previsão.

**Âncoras dependem de memória ativa:** em conversas muito longas, itens antigos podem ser subrepresentados. O auto-teste de confiança existe para sinalizar isso antes que vire problema.

---

## Integração com Context Guardian

A skill Status funciona de forma independente. Com a skill [Context Guardian](https://github.com/brunoflma/context-guardian) instalada junto, as duas trabalham em camadas:

```
Status       → visibilidade: quanto resta e com que confiança
Guardian     → ação: checkpoints e evacuação com relatório .md
```

**O que muda com as duas ativas:**

- O card de Status substitui o lembrete periódico do Sentinela do Guardian — sem duplicação no chat
- Quando a recomendação chega em "Transferência Imediata", o Guardian dispara a evacuação automaticamente, sem precisar de confirmação
- Os campos 📋 Técnico e 🎯 Conteúdo do card alimentam os fatos-âncora do checkpoint — o Guardian não precisa reconstruir o estado do zero

Em sessões longas e críticas, instalar as duas é o setup mais seguro: o Status avisa quando, o Guardian executa o quê.

---

## Automação total (fora do Claude.ai)

| Ambiente | Comportamento |
|---|---|
| Claude.ai | Card emitido na conversa, estimativa por pesos calibrados |
| API Python/Node | Acesso a `usage.input_tokens` — percentual real, sem estimativa |
| Claude Code | Integração nativa com subagentes do Guardian |

---

Desenvolvido por **Bruno Ferreira** — 2026
