## 2025-02-18 - Accessibility in LLM-Generated UI Components

**Learning:** When prompting LLMs (like Claude) to generate UI components or HTML structures (e.g., via `SKILL.md` instructions), they may not automatically include necessary ARIA attributes for accessibility unless explicitly told to do so. For example, a custom progress bar needs `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`, and decorative SVGs need `aria-hidden="true"`.
**Action:** Always explicitly define required accessibility attributes in the prompt instructions when asking an LLM to generate UI code, ensuring the output is accessible by default.
