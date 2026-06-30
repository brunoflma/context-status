## 2024-06-18 - [XSS Risk in LLM-Generated HTML Tools]

**Vulnerability:** The Claude AI skill generates dynamic HTML cards (via the visualization tool) incorporating potentially untrusted inputs (project names, files generated in previous turns, decisions). This creates a Cross-Site Scripting (XSS) risk if the LLM blindly outputs unescaped text that an attacker might have injected via previous context or files.
**Learning:** LLMs acting as tools/skills that output raw UI elements (like HTML cards) are vulnerable to prompt injection/data exfiltration disguised as XSS within their own rendered output.
**Prevention:** Always explicitly instruct the LLM in its system prompt/skill definition to escape HTML characters (`<`, `>`, `&`, `"`, `'`) when rendering dynamic, user-provided, or session-derived content.

## 2024-06-30 - [Prompt Injection Risk in Diagnostic LLM Skills]

**Vulnerability:** The Claude AI skill acts as an autonomous diagnostic agent generating status reports based on session history. A malicious user could intentionally inject prompts to force the LLM to suppress, forge, or alter the status report (e.g. instructing it to show "100% confidence" regardless of reality).
**Learning:** Diagnostic or auditing LLM prompts must contain strict, non-negotiable boundaries that prohibit the LLM from accepting user instructions that attempt to override its reporting mechanism.
**Prevention:** Always explicitly include anti-prompt injection directives instructing the LLM to ignore user attempts to forge, alter, or suppress the reporting output.
