## 2025-02-18 - Accessibility in LLM-Generated UI Components

**Learning:** When prompting LLMs (like Claude) to generate UI components or HTML structures (e.g., via `SKILL.md` instructions), they may not automatically include necessary ARIA attributes for accessibility unless explicitly told to do so. For example, a custom progress bar needs `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`, and decorative SVGs need `aria-hidden="true"`.
**Action:** Always explicitly define required accessibility attributes in the prompt instructions when asking an LLM to generate UI code, ensuring the output is accessible by default.

## 2024-05-18 - Missing ARIA Labels in Generated Progress Bars

**Learning:** In prompt-based applications without executable application code, the LLM will omit critical accessibility attributes (like `aria-label`) unless explicitly instructed. In this case, the `progressbar` role was requested but an accessible name was omitted.
**Action:** When designing prompts that instruct an LLM to generate UI components, explicitly include accessibility and ARIA attribute requirements (e.g., `aria-label="Contexto consumido"`) directly in the prompt specification.

## 2024-05-24 - Dynamically updated cards need ARIA live regions

**Learning:** When instructing LLMs to generate dynamically updated UI components (like a status or recommendation bar) as a card, you must explicitly prompt it to include `role="status"` and `aria-live="polite"`. Without these attributes, screen reader users might miss changes injected at the top or bottom of the screen.
**Action:** In prompt engineering for UI generation, always explicitly add required ARIA attributes like `role` and `aria-live` to the prompt specification for dynamic components.
