#!/usr/bin/env pwsh
# retry-copilot.ps1 — Close ONLY conflicted PRs and re-assign their linked issues to Copilot
# PRs that are still mergeable are left alone for merge-prs.ps1

$repo = "anabil25/hi-state-services"

# Step 1: Find conflicted PRs and close them
Write-Host "Checking open PRs for conflicts..." -ForegroundColor Cyan
$prs = gh pr list --repo $repo --state open --json number,title,mergeable --limit 200 | ConvertFrom-Json

$conflicted = $prs | Where-Object { $_.mergeable -eq 'CONFLICTING' }
$clean = $prs | Where-Object { $_.mergeable -ne 'CONFLICTING' }

Write-Host "  $($clean.Count) PRs are mergeable (leaving alone)" -ForegroundColor Green
Write-Host "  $($conflicted.Count) PRs have conflicts (will close and retry)" -ForegroundColor Yellow
Write-Host ""

$closedIssues = @()

foreach ($pr in $conflicted) {
    # Get linked issue numbers before closing
    $prDetail = gh pr view $pr.number --repo $repo --json closingIssuesReferences --jq '.closingIssuesReferences[].number' 2>&1
    
    gh pr close $pr.number --repo $repo --delete-branch 2>&1 | Out-Null
    Write-Host "  Closed PR #$($pr.number): $($pr.title)" -ForegroundColor Yellow
    
    if ($prDetail -and $LASTEXITCODE -eq 0) {
        $closedIssues += $prDetail -split "`n" | Where-Object { $_ -match '^\d+$' }
    }
}

Write-Host ""

# Step 2: Re-assign linked issues to Copilot
if ($closedIssues.Count -gt 0) {
    $uniqueIssues = $closedIssues | Select-Object -Unique
    Write-Host "Re-assigning $($uniqueIssues.Count) linked issues to Copilot..." -ForegroundColor Cyan
    foreach ($issueNum in $uniqueIssues) {
        gh issue edit $issueNum --repo $repo --remove-assignee Copilot 2>&1 | Out-Null
        gh issue edit $issueNum --repo $repo --add-assignee Copilot 2>&1 | Out-Null
        Write-Host "  Re-assigned issue #$issueNum" -ForegroundColor Green
    }
} else {
    Write-Host "No linked issues to re-assign." -ForegroundColor Yellow
}

Write-Host "`nDone. Copilot will create fresh PRs for conflicted issues. This may take 5-15 minutes." -ForegroundColor White
Write-Host "Then run: .\merge-prs.ps1 -Count N" -ForegroundColor White
