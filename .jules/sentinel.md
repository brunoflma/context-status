## 2024-06-18 - [XSS Risk in LLM-Generated HTML Tools]

**Vulnerability:** The Claude AI skill generates dynamic HTML cards (via the visualization tool) incorporating potentially untrusted inputs (project names, files generated in previous turns, decisions). This creates a Cross-Site Scripting (XSS) risk if the LLM blindly outputs unescaped text that an attacker might have injected via previous context or files.
**Learning:** LLMs acting as tools/skills that output raw UI elements (like HTML cards) are vulnerable to prompt injection/data exfiltration disguised as XSS within their own rendered output.
**Prevention:** Always explicitly instruct the LLM in its system prompt/skill definition to escape HTML characters (`<`, `>`, `&`, `"`, `'`) when rendering dynamic, user-provided, or session-derived content.

## 2026-05-18 - Anti-Prompt Injection Directive

**Vulnerability:** A lack of anti-prompt injection directives makes the LLM vulnerable to malicious user instructions attempting to forge, alter, or suppress the output of diagnostic and status skills.
**Learning:** In prompt-based applications and skills, user input is inherently intertwined with instructions, which creates a significant risk of prompt injection if boundaries are not strictly defined.
**Prevention:** Always include explicit anti-prompt injection directives instructing the LLM to strictly ignore user attempts to forge, alter, or suppress the desired behavior or outputs.
