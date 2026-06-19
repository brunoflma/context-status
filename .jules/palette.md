## 2024-05-24 - LLM-generated HTML Cards Accessibility

**Learning:** LLM-generated UI elements (like HTML cards created by prompt engineering skills) often lack accessibility by default. Specifying ARIA attributes (`role`, `aria-label`, `aria-valuenow`, `aria-hidden`) directly in the LLM system prompt is an effective reusable UX pattern for ensuring the design system's output remains accessible for screen reader users.
**Action:** When designing prompts that generate UI components or data visualizations, explicitly include accessibility and ARIA attribute requirements in the component's specification.
