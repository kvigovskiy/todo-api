# PowerShell скрипт для исправления PR по комментариям
# Использование: .\.github\scripts\fix-pr.ps1 -PRNumber 1 -FixPrompt "Исправь замечания"
# Требование: Установить переменную окружения GH_TOKEN перед запуском

param(
    [Parameter(Mandatory=$true)]
    [int]$PRNumber,
    
    [Parameter(Mandatory=$true)]
    [string]$FixPrompt
)

$GH_EXE = "C:\Users\GETMAN\AppData\Local\Microsoft\WindowsApps\gh.exe"
$OPENCODE_EXE = "opencode"

# Проверка токена
if (-not $env:GH_TOKEN) {
    Write-Host "ERROR: GH_TOKEN not set!" -ForegroundColor Red
    Write-Host "Set it: `$env:GH_TOKEN=`"your-token`"" -ForegroundColor Yellow
    exit 1
}

Write-Host "=== GitHub PR Fix Script ===" -ForegroundColor Cyan
Write-Host "PR: #$PRNumber" -ForegroundColor Yellow
Write-Host "Fix Prompt: $FixPrompt" -ForegroundColor Yellow

# Получаем комментарии из PR
Write-Host "`n[1/3] Fetching PR comments..." -ForegroundColor Green
$comments = & $GH_EXE pr view $PRNumber --json comments --template '{{range .comments}}{{.author}}{{": "}}{{.body}}{{"\n"}}{{end}}'

Write-Host "Comments:" -ForegroundColor Gray
Write-Host $comments -ForegroundColor Gray

# Запускаем OpenCode для исправлений
Write-Host "`n[2/3] Running OpenCode to fix issues..." -ForegroundColor Green
Write-Host "Prompt: $FixPrompt" -ForegroundColor Gray

# OpenCode будет работать в текущей ветке PR
& $OPENCODE_EXE --model ollama/qwen3.5:397b-cloud --prompt $FixPrompt

# Коммит и push исправлений
Write-Host "`n[3/3] Committing and pushing fixes..." -ForegroundColor Green
$changes = git status --porcelain
if ($changes) {
    git add .
    git commit -m "fix: Address PR #$PRNumber feedback"
    git push
    Write-Host "`n✅ Fixes pushed! PR updated automatically." -ForegroundColor Green
} else {
    Write-Host "`n⚠️ No changes made by OpenCode" -ForegroundColor Yellow
}
