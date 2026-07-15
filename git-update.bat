@echo off
SETLOCAL EnableDelayedExpansion
cls
color 0B
echo ===================================================
echo             GIT UPDATE & PUSH UTILITY              
echo ===================================================
echo.

:: Check if git is installed
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    color 0C
    echo [ERROR] Git is not installed or not in your PATH.
    echo Please install Git from https://git-scm.com/
    goto end
)

:: Show current status
echo Current Git Status:
echo ---------------------------------------------------
git status -s
echo ---------------------------------------------------
echo.

:: Ask user if they want to proceed
set /p "proceed=Do you want to stage, commit, and push these changes? (Y/N): "
if /i "%proceed%" neq "y" (
    echo Update cancelled by user.
    goto end
)

echo.
:: Prompt for commit message
set "commit_msg="
set /p "commit_msg=Enter commit message (or press Enter for default 'Minor updates'): "

if "%commit_msg%"=="" (
    set "commit_msg=Minor updates"
)

echo.
echo [1/3] Staging changes...
git add .

echo.
echo [2/3] Committing changes...
git commit -m "%commit_msg%"

echo.
echo [3/3] Pushing to GitHub...
:: Get the current branch name
for /f "tokens=*" %%i in ('git branch --show-current') do set "branch=%%i"
if "%branch%"=="" (
    set "branch=main"
)

git push origin %branch%

if %ERRORLEVEL% neq 0 (
    color 0C
    echo.
    echo [ERROR] Push failed. Please check your internet connection or credentials.
) else (
    color 0A
    echo.
    echo [SUCCESS] Successfully pushed changes to branch '%branch%'!
)

:end
echo.
echo Press any key to exit...
pause >nul
