## 2025-02-18 - Accessibility in LLM-Generated UI Components

**Learning:** When prompting LLMs (like Claude) to generate UI components or HTML structures (e.g., via `SKILL.md` instructions), they may not automatically include necessary ARIA attributes for accessibility unless explicitly told to do so. For example, a custom progress bar needs `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`, and decorative SVGs need `aria-hidden="true"`.
**Action:** Always explicitly define required accessibility attributes in the prompt instructions when asking an LLM to generate UI code, ensuring the output is accessible by default.

## 2024-05-18 - Missing ARIA Labels in Generated Progress Bars

**Learning:** In prompt-based applications without executable application code, the LLM will omit critical accessibility attributes (like `aria-label`) unless explicitly instructed. In this case, the `progressbar` role was requested but an accessible name was omitted.
**Action:** When designing prompts that instruct an LLM to generate UI components, explicitly include accessibility and ARIA attribute requirements (e.g., `aria-label="Contexto consumido"`) directly in the prompt specification.

## 2026-03-05 - ARIA attributes for LLM prompt-generated dynamic UI components

**Learning:** When instructing an LLM to generate dynamically updating UI components (like status or recommendation bars), screen readers won't announce the updates unless explicitly told. Just instructing it to output HTML isn't enough; the accessibility features must be explicitly specified in the prompt itself to ensure the resulting output is accessible.
**Action:** Always include explicit instructions in the prompt to add ARIA live region attributes (e.g., `role="status"`, `aria-live="polite"`) when the prompt is designed to generate dynamic UI notifications or updates.
