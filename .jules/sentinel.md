## 2024-05-24 - HTML Component Generation XSS

**Vulnerability:** Prompt instructions generating HTML components directly from user context without escaping HTML entities allowed XSS injection when rendering the card.
**Learning:** In prompt-based applications without executable application code, the LLM itself generates the UI. If it doesn't sanitize user context before rendering it into HTML, it introduces XSS vulnerabilities.
**Prevention:** Always explicitly instruct the LLM to strictly sanitize/escape HTML entities (`<`, `>`, `&`, `"`, `'`) from user context strings when generating HTML UI components.
