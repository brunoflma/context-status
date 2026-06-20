## 2026-06-20 - Prompt Engineering for UI Accessibility

**Learning:** When designing prompts that instruct an LLM to generate UI components (like HTML cards), you cannot rely on the LLM to implicitly include accessibility features. Accessibility attributes and ARIA roles must be explicitly included in the prompt specification.
**Action:** Enforce explicit inclusion of accessibility requirements (e.g., `role="progressbar"`, `aria-hidden="true"`) in prompt definitions for any generated UI components to ensure the resulting output is accessible.
