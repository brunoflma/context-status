## 2026-06-21 - Optimize Prompt Tokens & Generation via Minification

**Learning:** In prompt engineering apps without backend logic, performance optimization isn't about code execution but rather LLM processing and generation speed. Unminified multiline SVGs and redundant spacing inside context system prompts increase input token cost and time, while instructing the model to generate multiline HTML increases Time To First Token (TTFT) and overall output speed due to extra newline token generation.
**Action:** When working on UI-generating prompts, minify static definitions (like reference SVGs) within the prompt file to reduce context size. Additionally, explicitly instruct the LLM to output minified UI components (like HTML/SVG) to decrease TTFT and generation time.
