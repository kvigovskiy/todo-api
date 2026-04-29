# PowerShell скрипт для создания PR через GitHub CLI
# Использование: .\.github\scripts\create-pr.ps1 -BranchName "feature/todo-api" -Title "Description" -Body "Details"
# Требование: Установить переменную окружения GH_TOKEN перед запуском

param(
    [Parameter(Mandatory=$true)]
    [string]$BranchName,
    
    [Parameter(Mandatory=$true)]
    [string]$Title,
    
    [Parameter(Mandatory=$false)]
    [string]$Body = "",
    
    [Parameter(Mandatory=$false)]
    [string]$BaseBranch = "master"
)

$GH_EXE = "C:\Users\GETMAN\AppData\Local\Microsoft\WindowsApps\gh.exe"

# Проверка токена
if (-not $env:GH_TOKEN) {
    Write-Host "ERROR: GH_TOKEN not set!" -ForegroundColor Red
    Write-Host "Set it: `$env:GH_TOKEN=`"your-token`"" -ForegroundColor Yellow
    exit 1
}

Write-Host "=== GitHub PR Creation Script ===" -ForegroundColor Cyan
Write-Host "Branch: $BranchName" -ForegroundColor Yellow
Write-Host "Base: $BaseBranch" -ForegroundColor Yellow
Write-Host "Title: $Title" -ForegroundColor Yellow

# Создаём и переключаемся на ветку
Write-Host "`n[1/4] Creating branch..." -ForegroundColor Green
git checkout -b $BranchName 2>&1 | Write-Host

# Делаем коммит (если есть изменения)
$changes = git status --porcelain
if ($changes) {
    Write-Host "`n[2/4] Committing changes..." -ForegroundColor Green
    git add .
    git commit -m "feat: $Title"
} else {
    Write-Host "`n[2/4] No changes to commit" -ForegroundColor Gray
}

# Push ветки
Write-Host "`n[3/4] Pushing branch..." -ForegroundColor Green
git push -u origin $BranchName

# Создаём PR
Write-Host "`n[4/4] Creating PR..." -ForegroundColor Green
$PR_URL = & $GH_EXE pr create `
    --title $Title `
    --body $Body `
    --base $BaseBranch `
    --head $BranchName

Write-Host "`n✅ PR created successfully!" -ForegroundColor Green
Write-Host "URL: $PR_URL" -ForegroundColor Cyan
