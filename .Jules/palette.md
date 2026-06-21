## 2024-05-18 - Accessibility in Prompt-Generated UI

**Learning:** When creating a prompt that instructs an LLM to generate an HTML UI (like a status card), the LLM will often omit semantic ARIA attributes unless explicitly told. Accessibility must be part of the prompt specification.
**Action:** Always include explicit ARIA attribute requirements (like `role="progressbar"` and `aria-hidden="true"`) directly in the UI specification instructions for prompt-based HTML generation.
