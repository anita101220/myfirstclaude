# scripts/create-pr.ps1
# Called by .git/hooks/post-commit.
# Pushes the current branch and creates a PR if one doesn't exist yet.
# Skips silently when on main/master.

Set-Location "C:\xampp\htdocs\claude"

$branch = git rev-parse --abbrev-ref HEAD

if ($branch -eq "main" -or $branch -eq "master") {
    exit 0
}

# Push branch (no-op if already up to date)
# Do not use 2>&1 — in PS 5.1 it wraps native stderr as NativeCommandError
git push -u origin $branch | Out-Null

# Check if an OPEN PR already exists for this branch
$existing = gh pr view --json number,url,state 2>$null
if ($existing) {
    $pr = $existing | ConvertFrom-Json
    if ($pr.state -eq "OPEN") {
        Write-Host "[PR] PR #$($pr.number) already open: $($pr.url)"
        exit 0
    }
}

# Create the PR — --fill uses the commit message for title/body
gh pr create --fill --base main
