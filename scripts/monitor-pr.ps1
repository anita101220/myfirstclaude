# scripts/monitor-pr.ps1
# Polls the current branch's open PR every 2 minutes for review comments.
# Captures both inline review comments (Files tab) and general conversation comments.
# Usage: powershell -File scripts/monitor-pr.ps1

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
        $raw = gh pr view --json number,url,state,comments,headRepository 2>$null

        if (-not $raw) {
            $ts = Get-Date -Format "HH:mm:ss"
            Write-Host "  [$ts] No open PR on this branch yet. Waiting..." -ForegroundColor DarkYellow
            Start-Sleep -Seconds $INTERVAL_SECS
            continue
        }

        $pr = $raw | ConvertFrom-Json

        if ($pr.state -eq "MERGED" -or $pr.state -eq "CLOSED") {
            Write-Host "PR #$($pr.number) is $($pr.state). Monitor exiting." -ForegroundColor Green
            break
        }

        # Inline review comments (line-specific, from the Files tab)
        $repo = $pr.headRepository.nameWithOwner
        $inlineRaw = gh api "repos/$repo/pulls/$($pr.number)/comments" 2>$null
        $inlineComments = if ($inlineRaw) { $inlineRaw | ConvertFrom-Json } else { @() }

        # General conversation comments (Conversation tab)
        $generalComments = @($pr.comments)

        $hasFeedback = ($inlineComments.Count -gt 0) -or ($generalComments.Count -gt 0)

        if ($hasFeedback) {
            $ts = Get-Date -Format "HH:mm:ss"
            Write-Host ""
            Write-Host "[$ts] Feedback on PR #$($pr.number) - $($inlineComments.Count) inline, $($generalComments.Count) general" -ForegroundColor Yellow
            Write-Host "$($pr.url)" -ForegroundColor DarkGray

            $lines = [System.Collections.Generic.List[string]]::new()
            $lines.Add("# PR #$($pr.number) - Review Feedback")
            $lines.Add("")
            $lines.Add("$($pr.url)")
            $lines.Add("")

            if ($inlineComments.Count -gt 0) {
                $lines.Add("## Inline Review Comments (Files tab)")
                $lines.Add("")
                foreach ($c in $inlineComments) {
                    $lines.Add("### $($c.path) - line $($c.line)")
                    $lines.Add("**$($c.user.login):** $($c.body)")
                    $lines.Add("")
                }
            }

            if ($generalComments.Count -gt 0) {
                $lines.Add("## General Comments (Conversation tab)")
                $lines.Add("")
                foreach ($c in $generalComments) {
                    $lines.Add("**$($c.author.login):** $($c.body)")
                    $lines.Add("")
                }
            }

            $summaryText = $lines -join "`n"

            Write-Host ""
            Write-Host "=== REVIEW FEEDBACK ===" -ForegroundColor Cyan
            Write-Host $summaryText
            Write-Host "=======================" -ForegroundColor Cyan
            Write-Host ""

            $summaryText | Set-Content $FEEDBACK_FILE -Encoding utf8

            Write-Host "Feedback saved to pr-feedback.md" -ForegroundColor DarkGray
            Write-Host "Opening Claude Code for interactive review..." -ForegroundColor Cyan
            Write-Host "(Review proposed changes. Run git add / commit / push yourself when satisfied.)" -ForegroundColor Yellow
            Write-Host ""

            claude "I have PR review feedback in pr-feedback.md. Please read it, then for each comment tell me what you plan to change and show me a diff before making any edits. Do NOT commit or push - I will do that after reviewing your changes."

            Remove-Item $FEEDBACK_FILE -ErrorAction SilentlyContinue

            Write-Host ""
            Write-Host "Claude session ended." -ForegroundColor Green
            Write-Host "When you are happy with the fixes: git add, git commit, git push" -ForegroundColor Yellow
            break
        }
        else {
            $ts = Get-Date -Format "HH:mm:ss"
            Write-Host "  [$ts] PR #$($pr.number): no comments yet. Next check in $INTERVAL_SECS s..." -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Host "  Error: $_" -ForegroundColor Red
    }

    Start-Sleep -Seconds $INTERVAL_SECS
}
