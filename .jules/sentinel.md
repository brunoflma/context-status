## 2025-02-14 - Prevent XSS in LLM-Generated HTML Visualizations

**Vulnerability:** The Claude skill generates an HTML card visualizing the conversation status, using context details. If user inputs or context snippets contain unescaped HTML characters, rendering them directly in the generated card allows Cross-Site Scripting (XSS).
**Learning:** LLM-generated HTML elements based on user interactions are susceptible to injection attacks if inputs aren't sanitized. Even structural UI like status reports can be an attack vector.
**Prevention:** Added an explicit formatting rule instructing the LLM to strictly sanitize/escape HTML special characters (`<`, `>`, `&`, `"`, `'`) when interpolating context strings into the HTML card visualization.
