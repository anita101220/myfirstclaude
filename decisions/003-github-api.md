# Decision 003 — GitHub API Integration

**Decision:** Client-side fetch of `https://api.github.com/users/anita101220/repos` with graceful fallback

**Why:** The GitHub REST API is public and requires no auth token for public repos (60 req/hour unauthenticated — more than sufficient for a portfolio). Fetching client-side avoids any server-side caching complexity. If the account has no public repos or the fetch fails, the GitHub Projects section is hidden — visitors never see a broken or empty state.

**Alternatives rejected:**
- **Server-side PHP proxy** — adds complexity without benefit since the data is public and rate limits are not a concern for a personal portfolio
- **Build-time static generation** — would require a build pipeline and manual redeployment every time a new repo is created; live API fetch is simpler and always up-to-date
