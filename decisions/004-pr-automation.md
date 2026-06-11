# Decision 004 — PR Automation Architecture

**Decision:** git post-commit hook for PR creation; interactive Claude Code session (not autonomous) for feedback fixing

**Why:** A fully autonomous agent that edits code and pushes without human review is risky — a misunderstood review comment could introduce regressions. The chosen design keeps the human in the loop: `monitor-pr.ps1` detects feedback and opens an interactive Claude Code session where the developer reviews proposed changes before committing and pushing manually.

**Alternatives rejected:**
- **Fully autonomous fix-and-push agent**: Blocked as unsafe — Claude would edit, commit, and push with no human review step
- **GitHub Actions workflow**: Requires CI pipeline setup and GitHub-side secrets management; over-engineered for a personal portfolio repo
- **Webhook server (PHP)**: Would require a public server to receive GitHub webhooks — unnecessary complexity for a local XAMPP setup
