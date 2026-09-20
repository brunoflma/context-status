<img src="docs/cover.svg" width="100%" alt="Context Status. Entenda o estado da conversa antes de continuar.">

# Context Status

**Um ponto de situação para conversas que ficaram grandes.**

O Context Status é uma skill que orienta o Claude a resumir o estado da sessão em um card: estimativa de contexto, decisões importantes, arquivos produzidos, confiança declarada e uma recomendação de continuidade.

**[Baixar a skill ↗](https://github.com/brunoflma/context-status/releases/latest/download/context-status.zip)** · [Ler as instruções](context-status/SKILL.md) · [Conhecer o Context Guardian](https://github.com/brunoflma/context-guardian)

## O que fica visível

| No card | Para que serve |
| :--- | :--- |
| **Estimativa de contexto** | Acompanhar a tendência de crescimento da conversa. |
| **Decisões-âncora** | Lembrar escolhas técnicas, materiais produzidos e preferências de conteúdo. |
| **Confiança declarada** | Sinalizar dúvidas do assistente sobre o estado que está resumindo. |
| **Recomendação de ação** | Continuar, revisar o contexto ou preparar uma transferência. |

### Exemplo ilustrativo de card

```text
STATUS · Turno 12 · Confiança alta · Guardian inativo

Contexto estimado   ~18% (±8%)
Contexto            Revisão da documentação de um projeto
Técnico             Página estática, sem backend
Produzido           README e guia de instalação
Conteúdo            Português, exemplos curtos, linguagem direta
Alertas             Nenhum alerta declarado
Recomendação        Continuar a sessão
```

O percentual é uma **estimativa do assistente**, não uma leitura dos tokens reais. A margem de ±8% faz parte do método descrito na skill e não deve ser interpretada como precisão estatística garantida.

## Instalação no Claude

1. Baixe **`context-status.zip`** na [release mais recente](https://github.com/brunoflma/context-status/releases/latest).
2. Abra a área **Skills** nas configurações de recursos do Claude.
3. Use a opção de enviar uma skill, selecione o ZIP e habilite-a.
4. Peça **`/status`** em uma conversa para solicitar o card.

Consulte o [guia oficial de skills](https://support.claude.com/en/articles/12512180-use-skills-in-claude) para verificar os requisitos e as permissões da sua conta.

## Peça um status quando precisar

```text
/status
```

Também são gatilhos: `status?`, `check`, `como está o contexto`, `saúde da sessão` e `quanto contexto resta`.

| Comando | Efeito previsto nas instruções |
| :--- | :--- |
| `/context-status off auto` | Desativa os marcos automáticos e mantém a consulta manual. |
| `/context-status off` | Mantém apenas a chamada explícita. |
| `/context-status on` | Retoma o modo anterior. |

As instruções pedem um card inicial e novos cards nos marcos estimados de 25%, 50% e 75%. O card do primeiro turno é a referência inicial do método.

## Decisões que não devem se perder

- **Técnico:** arquitetura, ferramentas, configurações e critérios de implementação.
- **Produzido:** documentos, arquivos e outros materiais da sessão.
- **Conteúdo:** idioma, tom, formato e decisões sobre a entrega.

A skill orienta o assistente a tentar recuperar essas âncoras antes de apresentar o status. Esse exercício ajuda a explicitar dúvidas, mas não comprova que toda a conversa foi preservada.

## Status para enxergar. Guardian para retomar.

Com o [Context Guardian](https://github.com/brunoflma/context-guardian), a recomendação de transferência pode servir de gatilho para preparar checkpoints, relatório em Markdown e prompts de retomada. As instruções também procuram evitar lembretes duplicados.

## Limites do card

- Não acessa a contagem interna de tokens do Claude.
- Não prevê quando a plataforma vai compactar a conversa.
- Não consegue recuperar decisões que já saíram do contexto acessível.
- Não mede objetivamente a confiabilidade de uma resposta.
- É uma skill textual. Não inclui um orquestrador externo ou uma integração de API pronta.

Use o card como apoio para decidir quando revisar e registrar o trabalho, junto com sua própria conferência.

[Sugestões e problemas](https://github.com/brunoflma/context-status/issues) · [Bruno Ferreira](https://github.com/brunoflma)
