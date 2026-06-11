# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

This project runs under **XAMPP on Windows**. The web root is `C:\xampp\htdocs\claude\`, served at `http://localhost/claude/`.

- PHP is available via `C:\xampp\php\php.exe`
- MySQL is available via XAMPP's phpMyAdmin at `http://localhost/phpmyadmin/`
- Apache and MySQL services are managed through the XAMPP Control Panel

## Common Commands

Run a PHP file from the terminal:
```powershell
C:\xampp\php\php.exe <file.php>
```

Check PHP syntax:
```powershell
C:\xampp\php\php.exe -l <file.php>
```

Run PHP's built-in linter across all PHP files:
```powershell
Get-ChildItem -Recurse -Filter *.php | ForEach-Object { C:\xampp\php\php.exe -l $_.FullName }
```

## PR Automation

### One-time setup (requires GitHub CLI)
```powershell
winget install --id GitHub.cli
gh auth login
```

### How it works
- **Post-commit hook** (`scripts/create-pr.ps1`): Every commit on a non-main branch automatically pushes the branch and opens a PR via `gh pr create --fill`.
- **PR feedback monitor** (`scripts/monitor-pr.ps1`): Polls the open PR every 2 minutes for unresolved review comments. When feedback is found, it prints a summary and opens an interactive Claude Code session — **you review all proposed changes and run `git add / commit / push` yourself**.

### Run the monitor
```powershell
powershell -File scripts/monitor-pr.ps1
```
Leave it running while reviewers comment. It exits when the PR is merged or closed.

## Project Decisions
See `decisions/` for architectural decision records (stack, layout, GitHub API integration, PR automation).
