## 2024-05-24 - Prompt-Driven UI Accessibility

**Learning:** In prompt-based applications where the UI is generated dynamically by an LLM (like Claude.ai skills), standard accessibility attributes (like `role` or `aria-hidden`) are often omitted by default.
**Action:** Always explicitly specify ARIA attributes (e.g., `role="progressbar"`, `aria-hidden="true"`) directly in the prompt instructions defining the HTML output structure.
