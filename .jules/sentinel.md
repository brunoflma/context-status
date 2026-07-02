## 2024-06-18 - [XSS Risk in LLM-Generated HTML Tools]

**Vulnerability:** The Claude AI skill generates dynamic HTML cards (via the visualization tool) incorporating potentially untrusted inputs (project names, files generated in previous turns, decisions). This creates a Cross-Site Scripting (XSS) risk if the LLM blindly outputs unescaped text that an attacker might have injected via previous context or files.
**Learning:** LLMs acting as tools/skills that output raw UI elements (like HTML cards) are vulnerable to prompt injection/data exfiltration disguised as XSS within their own rendered output.
**Prevention:** Always explicitly instruct the LLM in its system prompt/skill definition to escape HTML characters (`<`, `>`, `&`, `"`, `'`) when rendering dynamic, user-provided, or session-derived content.

## 2024-06-25 - [Prompt Injection Risk in Diagnostic System Prompts]

**Vulnerability:** System prompts designed to emit diagnostic information (like health or status reports) can be suppressed, altered, or manipulated by malicious user input (prompt injection), compromising the integrity of the tool.
**Learning:** LLMs acting as diagnostic tools are susceptible to user instructions that contradict their core directives, potentially leading to falsified status reports or bypassed security checks.
**Prevention:** Explicitly include anti-prompt injection directives in the system prompt (e.g., instructing the LLM to ignore user attempts to forge, alter, or suppress the output) to reinforce the priority of the system prompt over user input for critical diagnostic tasks.
