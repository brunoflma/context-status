## 2025-02-18 - Accessibility in LLM-Generated UI Components

**Learning:** When prompting LLMs (like Claude) to generate UI components or HTML structures (e.g., via `SKILL.md` instructions), they may not automatically include necessary ARIA attributes for accessibility unless explicitly told to do so. For example, a custom progress bar needs `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`, and decorative SVGs need `aria-hidden="true"`.
**Action:** Always explicitly define required accessibility attributes in the prompt instructions when asking an LLM to generate UI code, ensuring the output is accessible by default.

## 2024-05-18 - Missing ARIA Labels in Generated Progress Bars

**Learning:** In prompt-based applications without executable application code, the LLM will omit critical accessibility attributes (like `aria-label`) unless explicitly instructed. In this case, the `progressbar` role was requested but an accessible name was omitted.
**Action:** When designing prompts that instruct an LLM to generate UI components, explicitly include accessibility and ARIA attribute requirements (e.g., `aria-label="Contexto consumido"`) directly in the prompt specification.

## 2024-05-24 - ARIA Live Regions for LLM-Generated Dynamic Components

**Learning:** When instructing an LLM to generate dynamically updating UI components like status or recommendation bars, accessibility is often forgotten because there isn't a physical HTML file being edited. The LLM must be explicitly instructed in the prompt to include ARIA live region attributes (`role="status"`, `aria-live="polite"`) so that when the UI is generated and injected, screen readers correctly announce the changes.
**Action:** Always include explicit ARIA attribute requirements in prompt engineering instructions for any UI component that indicates state changes or dynamically updates.
