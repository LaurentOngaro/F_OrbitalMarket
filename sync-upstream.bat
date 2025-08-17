@echo off
setlocal EnableDelayedExpansion

echo ===============================================
echo      OrbitalMarket - Upstream Sync Script
echo ===============================================
echo.

REM Check if we're in a git repository
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo Error: Not in a git repository
    goto end_script
)

REM Check if upstream remote exists
git remote get-url upstream >nul 2>&1
if errorlevel 1 (
    echo Adding upstream remote...
    git remote add upstream https://github.com/hugoattal/OrbitalMarket.git
    if errorlevel 1 (
        echo Error: Failed to add upstream remote
        goto end_script
    )
    echo Upstream remote added successfully.
) else (
    echo Upstream remote already exists.
)

echo.
echo Fetching latest changes from upstream...
git fetch upstream
if errorlevel 1 (
    echo Error: Failed to fetch from upstream
    goto end_script
)

echo.
echo Current branch:
git branch --show-current

echo.
echo Available upstream branches:
git branch -r | findstr upstream

echo.
set /p "sync_branch=Enter the branch to sync with (default: main): "
if "%sync_branch%"=="" set sync_branch=main

echo.
echo Checking out %sync_branch% branch...
git checkout %sync_branch%
if errorlevel 1 (
    echo Warning: Could not checkout %sync_branch%, staying on current branch
)

echo.
echo Merging upstream/%sync_branch% into current branch...
git merge upstream/%sync_branch%
if errorlevel 1 (
    echo.
    echo Merge conflicts detected!
    echo Please resolve conflicts manually and then run:
    echo   git add .
    echo   git commit
    echo.
    goto end_script
)

echo.
echo Sync completed successfully!
echo.
set /p "push_changes=Push changes to your fork? (y/n): "
if /i "%push_changes%"=="y" (
    echo Pushing changes to origin...
    git push origin %sync_branch%
    if errorlevel 1 (
        echo Warning: Failed to push changes
    ) else (
        echo Changes pushed successfully!
    )
)

:end_script
echo.
pause