# GitHub PR Workflow для Todo API

## 📋 Overview

Этот проект использует workflow с Pull Requests для контроля качества кода:

1. **Coding Agent** (OpenCode + Ollama) → пишет код
2. **GitHub PR** → ты проверяешь изменения
3. **Твои комментарии** → agent исправляет
4. **Ты мержишь** → только ты имеешь право на мерж

---

## 🔐 Настройка токена

**Перед использованием установи переменную окружения:**

```powershell
# PowerShell
$env:GH_TOKEN="ghp_***твой_токен***"

# Или в .bashrc/.zshrc для постоянного хранения
export GH_TOKEN="ghp_***твой_токен***"
```

**Репозиторий:** https://github.com/kvigovskiy/todo-api

---

## 🚀 Создание нового PR

### Вариант 1: Через скрипт (рекомендуется)

```powershell
cd D:\java\projects\todo-api

# Установить токен
$env:GH_TOKEN="ghp_***твой_токен***"

# Создать PR с изменениями
.\.github\scripts\create-pr.ps1 `
    -BranchName "feature/todo-api" `
    -Title "Add REST API for Todo management" `
    -Body "Implements CRUD endpoints for todo items"
```

### Вариант 2: Вручную

```powershell
cd D:\java\projects\todo-api

# Установить токен
$env:GH_TOKEN="ghp_***твой_токен***"

# 1. Создать ветку
git checkout -b feature/todo-api

# 2. Внести изменения (через OpenCode или вручную)
opencode --model ollama/qwen3.5:397b-cloud --prompt "Добавь валидацию к Todo entity"

# 3. Закоммитить
git add .
git commit -m "feat: Add validation to Todo entity"

# 4. Push
git push -u origin feature/todo-api

# 5. Создать PR
gh pr create --title "feat: Add validation" --body "Description" --base master --head feature/todo-api
```

---

## 🔧 Исправление PR по комментариям

### Вариант 1: Через скрипт (рекомендуется)

```powershell
cd D:\java\projects\todo-api

# Установить токен
$env:GH_TOKEN="ghp_***твой_токен***"

# Переключиться на ветку PR
git checkout feature/todo-api

# Исправить замечания из PR #1
.\.github\scripts\fix-pr.ps1 `
    -PRNumber 1 `
    -FixPrompt "Исправь замечания: добавить валидацию title, обработать null значения"
```

### Вариант 2: Вручную

```powershell
cd D:\java\projects\todo-api

# Установить токен
$env:GH_TOKEN="ghp_***твой_токен***"

# 1. Посмотреть комментарии PR
gh pr view 1 --comments

# 2. Переключиться на ветку PR
git checkout feature/todo-api

# 3. Запустить OpenCode для исправлений
opencode --model ollama/qwen3.5:397b-cloud --prompt "Исправь замечания: [твои комментарии]"

# 4. Закоммитить и push
git add .
git commit -m "fix: Address PR #1 feedback"
git push
```

---

## 📊 Мониторинг PR

```powershell
# Установить токен
$env:GH_TOKEN="ghp_***твой_токен***"

# Список всех PR
gh pr list

# Детали конкретного PR
gh pr view 1 --comments

# Статус проверок PR
gh pr checks 1
```

---

## 🎯 Полный цикл workflow

```
1. [ТЫ] Создаёшь задачу → "Добавить pagination к GET /todos"

2. [AGENT] OpenCode пишет код:
   opencode --prompt "Добавь pagination: page, size параметры"
   
3. [AGENT] Создаёт PR:
   .\.github\scripts\create-pr.ps1 -BranchName "feature/pagination" ...
   
4. [ТЫ] Review в GitHub:
   - Открываешь PR
   - Оставляешь комментарии
   - Запрашиваешь изменения (Request changes)
   
5. [AGENT] Исправляет по комментариям:
   .\.github\scripts\fix-pr.ps1 -PRNumber 2 -FixPrompt "..."
   
6. [ТЫ] Финальный review → Approve → Merge
```

---

## 🛠️ Утилиты

```powershell
# Обновить локальную master из remote
git checkout master
git pull origin master

# Удалить ветку после мержа
git branch -d feature/todo-api
git push origin --delete feature/todo-api

# Посмотреть историю коммитов
git log --oneline --graph --all
```
