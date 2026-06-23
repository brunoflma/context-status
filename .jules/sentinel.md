## 2024-06-18 - [XSS Risk in LLM-Generated HTML Tools]

**Vulnerability:** The Claude AI skill generates dynamic HTML cards (via the visualization tool) incorporating potentially untrusted inputs (project names, files generated in previous turns, decisions). This creates a Cross-Site Scripting (XSS) risk if the LLM blindly outputs unescaped text that an attacker might have injected via previous context or files.
**Learning:** LLMs acting as tools/skills that output raw UI elements (like HTML cards) are vulnerable to prompt injection/data exfiltration disguised as XSS within their own rendered output.
**Prevention:** Always explicitly instruct the LLM in its system prompt/skill definition to escape HTML characters (`<`, `>`, `&`, `"`, `'`) when rendering dynamic, user-provided, or session-derived content.

## 2025-01-28 - [Prompt Injection Risk in Diagnostic Skills]

**Vulnerability:** A user could maliciously prompt the LLM to forge a false status report, alter token count estimations, or suppress security warnings.
**Learning:** Security and diagnostic skills implemented via LLM prompts must contain explicit instructions that establish the diagnostic output as an immutable audit tool that cannot be overridden by user requests.
**Prevention:** Include explicit anti-prompt injection directives in the skill definition to enforce the integrity of the diagnostic output.
