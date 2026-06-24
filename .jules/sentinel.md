## 2024-06-18 - [XSS Risk in LLM-Generated HTML Tools]

**Vulnerability:** The Claude AI skill generates dynamic HTML cards (via the visualization tool) incorporating potentially untrusted inputs (project names, files generated in previous turns, decisions). This creates a Cross-Site Scripting (XSS) risk if the LLM blindly outputs unescaped text that an attacker might have injected via previous context or files.
**Learning:** LLMs acting as tools/skills that output raw UI elements (like HTML cards) are vulnerable to prompt injection/data exfiltration disguised as XSS within their own rendered output.
**Prevention:** Always explicitly instruct the LLM in its system prompt/skill definition to escape HTML characters (`<`, `>`, `&`, `"`, `'`) when rendering dynamic, user-provided, or session-derived content.

## 2024-06-24 - [Prompt Injection Risk in Diagnostic LLM Tools]

**Vulnerability:** The Claude AI skill acts as a diagnostic tool that reports on the session's context, confidence, and internal state. If it lacks explicit defenses, a user could use prompt injection to instruct the LLM to forge, suppress, or alter the data shown in the status card (e.g., claiming the confidence is high when it's low, or hiding warnings).
**Learning:** Diagnostic or administrative LLM tools are high-value targets for prompt injection, as users might attempt to trick the system into reporting a false clean bill of health or altering the perceived truth of the session.
**Prevention:** Always include explicit anti-prompt injection directives in the system prompt/skill instructions that command the LLM to ignore user attempts to alter the diagnostic output and rely solely on its honest, internal auto-evaluation.
