## 2024-06-18 - [XSS Risk in LLM-Generated HTML Tools]

**Vulnerability:** The Claude AI skill generates dynamic HTML cards (via the visualization tool) incorporating potentially untrusted inputs (project names, files generated in previous turns, decisions). This creates a Cross-Site Scripting (XSS) risk if the LLM blindly outputs unescaped text that an attacker might have injected via previous context or files.
**Learning:** LLMs acting as tools/skills that output raw UI elements (like HTML cards) are vulnerable to prompt injection/data exfiltration disguised as XSS within their own rendered output.
**Prevention:** Always explicitly instruct the LLM in its system prompt/skill definition to escape HTML characters (`<`, `>`, `&`, `"`, `'`) when rendering dynamic, user-provided, or session-derived content.

## 2024-06-29 - [Prompt Injection Risk in Diagnostic LLM Tools]

**Vulnerability:** The Claude AI skill acts as an authoritative source for context health. A user could intentionally or accidentally provide instructions in the prompt that command the skill to report a false "Sessão Estável" status or suppress the display of the status card entirely.
**Learning:** LLMs acting as system diagnostic tools are vulnerable to prompt injection attacks where the "system" instructions can be overridden by the "user" instructions to mask true system state.
**Prevention:** Always explicitly include anti-prompt injection directives instructing the LLM to ignore user attempts to forge, alter, or suppress the authoritative output.
