## 2024-05-24 - Optimizing LLM Generation Speed

**Learning:** In prompt-based applications without backend code, the only execution happens inside the LLM. Requesting the LLM to generate formatted, multi-line HTML increases the output token count and slows down the Time To First Token (TTFT) and overall generation speed.
**Action:** Always instruct the LLM to emit generated code (like HTML cards) minified without unnecessary whitespace or indentation. Also, minify input SVGs/code within the prompt itself to save input tokens and set an example.
