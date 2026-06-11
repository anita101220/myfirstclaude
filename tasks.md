# Portfolio Website — Tasks

## Planning
- [x] Define tech stack (HTML/CSS/JS)
- [x] Define page sections
- [x] Design GitHub API integration strategy
- [x] Create decisions/ folder with decision files
- [x] Design PR automation sub-agent

## Portfolio Implementation
- [x] Scaffold index.html (Hero, About, Skills, Featured Projects, GitHub, Contact)
- [x] Write style.css (dark theme, responsive grid, CSS variables)
- [x] Write script.js (GitHub API fetch + graceful fallback)
- [ ] Fill in your real project details in index.html (replace placeholder cards)
- [ ] Add your profile photo to assets/images/profile.jpg

## PR Automation Setup (one-time)
- [ ] Install GitHub CLI: `winget install --id GitHub.cli`
- [ ] Authenticate: `gh auth login`
- [x] Create scripts/create-pr.ps1
- [x] Create .git/hooks/post-commit
- [x] Create scripts/monitor-pr.ps1

## Testing
- [ ] Verify page renders at http://localhost/claude/
- [ ] Verify GitHub section hides gracefully when no public repos exist
- [ ] Verify GitHub section shows cards when repos are made public
- [ ] Verify responsive layout at mobile width
- [ ] Commit on a feature branch → PR created automatically
- [ ] Post a review comment → monitor detects it, opens Claude session
