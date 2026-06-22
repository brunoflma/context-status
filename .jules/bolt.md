## 2024-10-24 - Minifying System Prompt Definitions Speeds Up LLM Outputs

**Learning:** In prompt-based applications without executable application code, the LLM parses the entire prompt including UI component definitions. Minifying input definitions (like SVGs) and explicitly instructing the LLM to output minified UI code (HTML/SVGs) improves performance. It reduces input token count and forces the LLM to generate fewer output tokens, significantly improving Time To First Token (TTFT) and overall generation speed.
**Action:** When working on prompts that generate HTML/SVG structures, always minify the examples and definition strings within the system prompt itself, and explicitly add a rule for the LLM to output minified code.
