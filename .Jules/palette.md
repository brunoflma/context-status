## 2025-02-18 - Accessibility in LLM-Generated UI Components

**Learning:** When prompting LLMs (like Claude) to generate UI components or HTML structures (e.g., via `SKILL.md` instructions), they may not automatically include necessary ARIA attributes for accessibility unless explicitly told to do so. For example, a custom progress bar needs `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, and `aria-valuemax`, and decorative SVGs need `aria-hidden="true"`.
**Action:** Always explicitly define required accessibility attributes in the prompt instructions when asking an LLM to generate UI code, ensuring the output is accessible by default.

## 2024-05-18 - Missing ARIA Labels in Generated Progress Bars

**Learning:** In prompt-based applications without executable application code, the LLM will omit critical accessibility attributes (like `aria-label`) unless explicitly instructed. In this case, the `progressbar` role was requested but an accessible name was omitted.
**Action:** When designing prompts that instruct an LLM to generate UI components, explicitly include accessibility and ARIA attribute requirements (e.g., `aria-label="Contexto consumido"`) directly in the prompt specification.

## 2024-05-24 - Dynamic UI Component Accessibility

**Learning:** When instructing an LLM to generate dynamically updating UI components like a status card, explicitly specifying ARIA live region attributes (`role="status"`, `aria-live="polite"`) in the prompt ensures accessibility features are included in the generated HTML.
**Action:** Always add ARIA attribute requirements directly in the prompt instructions when asking an LLM to generate UI components.

## 2023-10-27 - ARIA Live Regions on Recommendation Bars

**Learning:** When instructing LLMs to generate dynamically updating recommendation or status bars, it's crucial to explicitly require `role="status"` and `aria-live="polite"` directly in the prompt. Otherwise, screen reader users might miss critical state changes or recommendations that appear visually.
**Action:** Always include ARIA live region attributes in the prompt instructions for dynamic UI elements like recommendation bars.

## 2023-10-27 - Single Live Region Strategy and Escalation

**Learning:** When generating complex UI components like status cards, avoid nesting ARIA live regions (e.g., placing one on the parent container and another on a child element). This can cause screen readers to duplicate or spam announcements. Furthermore, critical alerts (like a "Transferência Imediata" state) should escalate the main container's semantics to `role="alert"` and `aria-live="assertive"` to ensure immediate user awareness, rather than remaining `polite`.
**Action:** Always maintain a single, top-level live region for dynamic components. When states become critical or require immediate action, explicitly instruct the LLM to switch the live region semantics to `assertive` / `alert`.

## 2024-05-24 - Preserving Accessibility When Truncating Text in LLM Prompts

**Learning:** When instructing an LLM to enforce strict text truncation (e.g., limiting dynamic fields to 60 characters to prevent layout breaks or exhaustion), users lose access to the original full content. This negatively impacts accessibility and user experience in UI components like status cards where the full context is important.
**Action:** Always pair text truncation directives with an instruction to wrap the truncated text in an element that uses a native `title` attribute (e.g., `<span title="full text">truncated...</span>`). This ensures the layout remains stable while allowing users to access the complete information via native tooltips on hover.
