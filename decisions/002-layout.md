# Decision 002 — Layout

**Decision:** Single-page layout with smooth-scroll navigation

**Why:** A portfolio has a small, fixed set of sections (Hero, About, Skills, Projects, Contact). A single page keeps all content visible without the latency of page transitions and is the standard expectation for personal portfolios. Smooth-scroll anchors give structure without routing complexity.

**Alternatives rejected:**
- **Multi-page (separate HTML files)** — adds navigation overhead, makes shared styles harder to maintain, and fragments the experience for a site this size
