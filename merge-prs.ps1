#!/usr/bin/env pwsh
# merge-prs.ps1 — Merge open Copilot PRs in the a11y demo repo
# Usage:
#   .\merge-prs.ps1              # Merge nothing (safe default)
#   .\merge-prs.ps1 -Count 10   # Merge first 10 open PRs
#   .\merge-prs.ps1 -Count -1   # Merge ALL open PRs
#
# Handles conflicts by closing the conflicted PR and re-assigning the
# linked issue to Copilot, then waiting for a fresh PR.

param(
    [int]$Count = 0,       # 0 = do nothing, -1 = merge all, N = merge N
    [int]$MaxRetries = 2,  # How many times to retry a conflicted PR
    [int]$WaitSecs = 30    # Seconds to wait after update-branch before merge
)

$repo = "anabil25/hi-state-services"

Write-Host "Fetching open PRs from $repo..." -ForegroundColor Cyan
$prs = gh pr list --repo $repo --state open --json number,title --limit 200 | ConvertFrom-Json

if ($prs.Count -eq 0) {
    Write-Host "No open PRs found." -ForegroundColor Yellow
    exit 0
}

if ($Count -eq 0) {
    Write-Host "$($prs.Count) open PRs found. Specify -Count N to merge N, or -Count -1 to merge all." -ForegroundColor Yellow
    exit 0
}

$target = if ($Count -lt 0) { $prs.Count } else { $Count }
Write-Host "$($prs.Count) open PRs found. Will merge up to $target...`n" -ForegroundColor Cyan

$success = 0
$failed = 0

while ($success -lt $target) {
    # Refresh PR list each iteration (new PRs from Copilot retries may appear)
    $prs = gh pr list --repo $repo --state open --json number,title,mergeable --limit 200 | ConvertFrom-Json
    if ($prs.Count -eq 0) { break }

    # Pick the first mergeable PR, or first conflicted one to retry
    $pr = $prs | Where-Object { $_.mergeable -eq 'MERGEABLE' } | Select-Object -First 1
    if (-not $pr) {
        $pr = $prs | Select-Object -First 1
    }

    $num = $pr.number
    Write-Host "[$($success + 1)/$target] PR #${num}: $($pr.title)" -ForegroundColor White

    # Mark as ready if draft
    gh pr ready $num --repo $repo 2>&1 | Out-Null

    if ($pr.mergeable -eq 'CONFLICTING') {
        Write-Host "  Conflicted — closing and re-assigning to Copilot..." -ForegroundColor Yellow
        $issueNums = gh pr view $num --repo $repo --json closingIssuesReferences --jq '.closingIssuesReferences[].number' 2>&1
        gh pr close $num --repo $repo --delete-branch 2>&1 | Out-Null

        foreach ($issueNum in ($issueNums -split "`n" | Where-Object { $_ -match '^\d+$' })) {
            gh issue edit $issueNum --repo $repo --remove-assignee Copilot 2>&1 | Out-Null
            gh issue edit $issueNum --repo $repo --add-assignee Copilot 2>&1 | Out-Null
            Write-Host "  Re-assigned issue #$issueNum — waiting for Copilot..." -ForegroundColor Cyan
        }
        # Wait for Copilot to create a new PR
        Write-Host "  Waiting 60s for Copilot to create a fresh PR..." -ForegroundColor DarkGray
        Start-Sleep -Seconds 60
        continue
    }

    # Try update-branch then merge
    gh pr update-branch $num --repo $repo 2>&1 | Out-Null
    Start-Sleep -Seconds $WaitSecs

    $result = gh pr merge $num --repo $repo --squash --admin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Merged" -ForegroundColor Green
        $success++
    } else {
        Write-Host "  Failed: $result" -ForegroundColor Red
        $failed++
    }
    Start-Sleep -Milliseconds 500
}

Write-Host "`nDone. $success merged, $failed failed, $($prs.Count - $success) remaining." -ForegroundColor Cyan
