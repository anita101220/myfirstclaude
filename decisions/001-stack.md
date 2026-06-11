# Decision 001 — Tech Stack

**Decision:** Plain HTML / CSS / JS (no framework, no build tools)

**Why:** The project runs directly under XAMPP with no Node.js pipeline needed. A plain stack is instantly servable, trivially deployable to any host (Netlify drop, shared hosting, GitHub Pages), and has zero dependency rot. The portfolio does not require state management or component reuse at a scale that would justify a framework.

**Alternatives rejected:**
- **PHP** — unnecessary since there is no sensitive data (GitHub API is public); adds server-side complexity for no gain
- **React/Vite** — requires Node.js, a build step, and ongoing npm dependency maintenance; overkill for a static portfolio
