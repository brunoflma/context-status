## 2024-10-24 - Minifying System Prompt Definitions Speeds Up LLM Outputs

**Learning:** In prompt-based applications without executable application code, the LLM parses the entire prompt including UI component definitions. Minifying input definitions (like SVGs) and explicitly instructing the LLM to output minified UI code (HTML/SVGs) improves performance. It reduces input token count and forces the LLM to generate fewer output tokens, significantly improving Time To First Token (TTFT) and overall generation speed.
**Action:** When working on prompts that generate HTML/SVG structures, always minify the examples and definition strings within the system prompt itself, and explicitly add a rule for the LLM to output minified code.

## 2024-06-23 - SVG Token Optimization for Prompt Contexts

**Learning:** In prompt-based applications where the LLM is instructed to generate UI components, the length of the system prompt and instructions is critical for performance (Time To First Token and token consumption). SVGs with many separate elements (like multiple `<line>` elements) unnecessarily inflate the token count. Combining multiple primitive elements into a single `<path>` with a concise `d` attribute achieves the exact same visual result but significantly reduces the prompt's footprint.
**Action:** When working on prompts that require the generation of SVGs, explicitly minify the provided SVGs and consolidate repetitive elements into single `<path>` definitions wherever possible.
