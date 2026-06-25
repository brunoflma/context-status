## 2024-06-18 - [XSS Risk in LLM-Generated HTML Tools]

**Vulnerability:** The Claude AI skill generates dynamic HTML cards (via the visualization tool) incorporating potentially untrusted inputs (project names, files generated in previous turns, decisions). This creates a Cross-Site Scripting (XSS) risk if the LLM blindly outputs unescaped text that an attacker might have injected via previous context or files.
**Learning:** LLMs acting as tools/skills that output raw UI elements (like HTML cards) are vulnerable to prompt injection/data exfiltration disguised as XSS within their own rendered output.
**Prevention:** Always explicitly instruct the LLM in its system prompt/skill definition to escape HTML characters (`<`, `>`, `&`, `"`, `'`) when rendering dynamic, user-provided, or session-derived content.

## 2025-05-24 - Anti-Prompt Injection Directive

**Vulnerability:** Prompt injection risks where users might try to bypass or alter the diagnostic tool's output.
**Learning:** Explicit instructions must be added to diagnostic skills to ensure they ignore attempts to forge, alter, or suppress their generated output, ensuring accurate readouts of AI memory.
**Prevention:** Include anti-prompt injection directives alongside XSS prevention rules in diagnostic prompt instructions.
