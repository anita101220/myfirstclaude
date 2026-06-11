# scripts/monitor-pr.ps1
# Polls the current branch's open PR every 2 minutes for unresolved review comments.
# When feedback is found:
#   1. Prints a summary to the terminal
#   2. Writes feedback to pr-feedback.md in the project root
#   3. Opens an interactive Claude Code session with the feedback as context
#      (you review and approve all changes — nothing is committed or pushed automatically)
#
# Usage: powershell -File scripts/monitor-pr.ps1
# Stop:  Ctrl+C, or the script exits automatically when the PR is merged/closed.

$INTERVAL_SECS = 120
$PROJECT_DIR   = "C:\xampp\htdocs\claude"
$FEEDBACK_FILE = "$PROJECT_DIR\pr-feedback.md"

Set-Location $PROJECT_DIR
Write-Host ""
Write-Host "PR feedback monitor started." -ForegroundColor Cyan
Write-Host "Checking every $INTERVAL_SECS seconds. Press Ctrl+C to stop." -ForegroundColor DarkGray
Write-Host ""

while ($true) {
    try {
        $raw = gh pr view --json number,url,state,reviewThreads 2>$null

        if (-not $raw) {
            Write-Host "  [$((Get-Date -Format 'HH:mm:ss'))] No open PR on this branch yet. Waiting..." -ForegroundColor DarkYellow
            Start-Sleep -Seconds $INTERVAL_SECS
            continue
        }

        $pr = $raw | ConvertFrom-Json

        if ($pr.state -eq "MERGED" -or $pr.state -eq "CLOSED") {
            Write-Host "PR #$($pr.number) is $($pr.state). Monitor exiting." -ForegroundColor Green
            break
        }

        $unresolved = @($pr.reviewThreads | Where-Object { $_.isResolved -eq $false })

        if ($unresolved.Count -gt 0) {
            Write-Host ""
            Write-Host "[$((Get-Date -Format 'HH:mm:ss'))] $($unresolved.Count) unresolved review comment(s) on PR #$($pr.number)" -ForegroundColor Yellow
            Write-Host $pr.url -ForegroundColor DarkGray

            # Build human-readable summary
            $lines = @("# PR #$($pr.number) - Unresolved Review Feedback", "", $pr.url, "")
            foreach ($thread in $unresolved) {
                $lines += "## File: $($thread.path) (line $($thread.line))"
                foreach ($c in $thread.comments) {
                    $lines += "**$($c.author.login):** $($c.body)"
                }
                $lines += ""
            }

            $summaryText = $lines -join "`n"

            # Print to terminal
            Write-Host ""
            Write-Host "=== REVIEW FEEDBACK ===" -ForegroundColor Cyan
            Write-Host ($lines[3..($lines.Length-1)] -join "`n")
            Write-Host "=======================" -ForegroundColor Cyan
            Write-Host ""

            # Write context file
            $summaryText | Set-Content $FEEDBACK_FILE -Encoding utf8

            Write-Host "Feedback saved to pr-feedback.md" -ForegroundColor DarkGray
            Write-Host "Opening Claude Code for interactive review..." -ForegroundColor Cyan
            Write-Host "(Review proposed changes. Run 'git add / commit / push' yourself when satisfied.)" -ForegroundColor Yellow
            Write-Host ""

            # Launch interactive Claude session — user stays in control
            claude "I have PR review feedback in pr-feedback.md. Please read it, then for each comment tell me what you plan to change and show me a diff before making any edits. Do NOT commit or push — I will do that after reviewing your changes."

            # Clean up feedback file
            Remove-Item $FEEDBACK_FILE -ErrorAction SilentlyContinue

            Write-Host ""
            Write-Host "Claude session ended." -ForegroundColor Green
            Write-Host "When you're happy with the fixes: git add, git commit, git push" -ForegroundColor Yellow
            break
        }
        else {
            Write-Host "  [$((Get-Date -Format 'HH:mm:ss'))] PR #$($pr.number): no unresolved comments. Next check in $INTERVAL_SECS s..."
        }
    }
    catch {
        Write-Host "  Error: $_" -ForegroundColor Red
    }

    Start-Sleep -Seconds $INTERVAL_SECS
}
