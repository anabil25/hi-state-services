#!/usr/bin/env pwsh
# merge-prs.ps1 — Merge open Copilot PRs in the a11y demo repo
# Usage:
#   .\merge-prs.ps1              # Merge nothing (safe default)
#   .\merge-prs.ps1 -Count 10   # Merge first 10 open PRs
#   .\merge-prs.ps1 -Count -1   # Merge ALL open PRs

param(
    [int]$Count = 0  # 0 = do nothing, -1 = merge all, N = merge N
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

$total = $prs.Count
$toMerge = if ($Count -lt 0) { $prs } else { $prs | Select-Object -First $Count }
$mergeCount = @($toMerge).Count

Write-Host "$total open PRs found. Merging $mergeCount..." -ForegroundColor Cyan
Write-Host ""

$success = 0
$failed = 0

foreach ($pr in $toMerge) {
    Write-Host "[$($success + $failed + 1)/$mergeCount] Merging PR #$($pr.number): $($pr.title)" -ForegroundColor White
    # Mark as ready if still a draft
    gh pr ready $pr.number --repo $repo 2>&1 | Out-Null
    $result = gh pr merge $pr.number --repo $repo --squash --admin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Merged" -ForegroundColor Green
        $success++
    } else {
        Write-Host "  Failed: $result" -ForegroundColor Red
        $failed++
    }
    # Small delay to avoid rate limiting
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "Done. $success merged, $failed failed." -ForegroundColor Cyan
