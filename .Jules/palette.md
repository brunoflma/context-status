## 2025-02-18 - Accessibility in LLM-Generated UI Components

**Learning:** When prompting LLMs (like Claude) to generate UI components or HTML structures (e.g., via `SKILL.md` instructions), they may not automatically include necessary ARIA attributes for accessibility unless explicitly told to do so. For example, a custom progress bar needs `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`, and decorative SVGs need `aria-hidden="true"`.
**Action:** Always explicitly define required accessibility attributes in the prompt instructions when asking an LLM to generate UI code, ensuring the output is accessible by default.

## 2024-05-18 - Missing ARIA Labels in Generated Progress Bars

**Learning:** In prompt-based applications without executable application code, the LLM will omit critical accessibility attributes (like `aria-label`) unless explicitly instructed. In this case, the `progressbar` role was requested but an accessible name was omitted.
**Action:** When designing prompts that instruct an LLM to generate UI components, explicitly include accessibility and ARIA attribute requirements (e.g., `aria-label="Contexto consumido"`) directly in the prompt specification.

## 2024-05-24 - Accessibility for LLM-generated UI Components

**Learning:** When designing prompt-based applications without executable application code where the LLM generates dynamically updating UI components (like status or recommendation bars), screen readers won't announce the changes unless explicitly instructed to include ARIA live region attributes.
**Action:** Always include ARIA attributes (e.g., `role="status"`, `aria-live="polite"`) in the prompt specification to ensure the resulting output is accessible and screen reader users are notified of dynamically updating statuses.
