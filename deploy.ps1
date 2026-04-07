# ------------------------------
# GitHub Pages One-Click Deploy
# ------------------------------

# Variables
$repoHTTPS = "https://github.com/Hakeem077/MyWebsite.git"
$branch = "main"

# Step 1: Ensure we are in the project folder
Write-Host "Current directory: $(Get-Location)"

# Step 2: Initialize Git if needed
if (-not (Test-Path ".git")) {
    git init
    Write-Host "Initialized new Git repository."
}

# Step 3: Add all files and commit
git add .
git commit -m "Deploy website" -q

# Step 4: Set remote to HTTPS
git remote remove origin -ErrorAction SilentlyContinue
git remote add origin $repoHTTPS

# Step 5: Push to main branch
git branch -M $branch
git push -u origin $branch

Write-Host "`nFiles pushed to GitHub!"

# Step 6: Enable GitHub Pages (classic) via API
# Note: This requires a GitHub personal access token with repo access
$token = Read-Host "Enter your GitHub Personal Access Token" -AsSecureString
$tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

$body = @{
    source = @{
        branch = $branch
        path   = "/"   # root folder
    }
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.github.com/repos/Hakeem077/MyWebsite/pages" `
    -Method POST `
    -Body $body `
    -Headers @{
        Authorization = "token $tokenPlain"
        Accept = "application/vnd.github.v3+json"
    }

Write-Host "`nGitHub Pages enabled! Your site should be live soon:"
Write-Host "https://Hakeem077.github.io/MyWebsite/"
