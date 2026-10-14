@echo off
REM ============================================================================
REM ROUTE+ — publish the PUBLIC preview to GitHub Pages.
REM
REM Run from the preview folder:
REM     cd C:\Users\Asus\Documents\ROUTE+\ROUTE-PLUS-PREVIEW
REM     PUBLISH-PREVIEW.cmd
REM
REM This folder is NOT the production repository. It holds only the compiled
REM public frontend, a README and the Pages workflow — no backend, no tests, no
REM .env, no database. The script re-checks that before every push.
REM
REM BEFORE THE FIRST RUN, two things only you can do:
REM   1. Create an EMPTY PUBLIC repo named ROUTE-PLUS-PREVIEW at
REM      https://github.com/new   (public on purpose — Pages is what makes it
REM      shareable; the production repo stays private and is untouched)
REM   2. After the first push: repo Settings -> Pages ->
REM      "Build and deployment" -> Source: GitHub Actions
REM
REM The preview will then be served at:
REM     https://dhanush7921.github.io/ROUTE-PLUS-PREVIEW/
REM ============================================================================
setlocal EnableDelayedExpansion

if not exist "index.html" (
  echo   No index.html here. Run this from the ROUTE-PLUS-PREVIEW folder.
  pause & exit /b 1
)

echo.
echo ===== 1. Refuse to publish anything private =============================
set BAD=0
for %%F in (.env .env.production .env.local) do (
  if exist "%%F" (echo   PRESENT: %%F — must never be in a public repo & set BAD=1)
)
for %%D in (server shared scripts tests) do (
  if exist "%%D\" (echo   PRESENT: %%D\ — backend must not be in the preview & set BAD=1)
)
dir /b /s *.sqlite* *.dump *.dump.json >nul 2>&1 && (echo   PRESENT: a database file or dump & set BAD=1)
findstr /R /C:"AIza[0-9A-Za-z_-][0-9A-Za-z_-]*" index.html >nul 2>&1 && (echo   A Google API key shape is in index.html & set BAD=1)
findstr /R /C:"postgres.*://.*:.*@" index.html >nul 2>&1 && (echo   A database connection string is in index.html & set BAD=1)
if not "!BAD!"=="0" (
  echo.
  echo   Refusing to publish. Remove the items above first.
  pause & exit /b 1
)
echo   Clean: no .env, no backend folders, no databases, no keys.

echo.
echo ===== 2. Confirm the page is self-contained ==============================
findstr /R /C:"<script[^>]*src=" index.html >nul 2>&1 && (
  echo   index.html loads an external script — it must be fully inlined.
  pause & exit /b 1
)
for %%A in (index.html) do set SZ=%%~zA
echo   index.html is !SZ! bytes, no external scripts.

echo.
echo ===== 3. Git =============================================================
if not exist ".git" (
  git init -b main || (echo   git init failed & pause & exit /b 1)
)
if exist ".git\index.lock" del ".git\index.lock"
git add -A
git -c user.name="Kalla Dhanush" -c user.email="laxmishankar558@gmail.com" ^
    commit -m "ROUTE+ public preview: self-contained frontend and Pages workflow" 2>nul
if errorlevel 1 echo   (nothing new to commit)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin https://github.com/Dhanush7921/ROUTE-PLUS-PREVIEW.git
)
echo   origin:
git remote get-url origin

echo.
echo ===== 4. Push ============================================================
git push -u origin main || (
  echo.
  echo   Push failed. Most likely the repository does not exist yet —
  echo   create an EMPTY PUBLIC repo named ROUTE-PLUS-PREVIEW at
  echo   https://github.com/new  and run this again.
  pause & exit /b 1
)

echo.
echo ===== 5. What happens next ===============================================
echo   The "Deploy preview to GitHub Pages" workflow runs on this push.
echo   Watch it:  https://github.com/Dhanush7921/ROUTE-PLUS-PREVIEW/actions
echo.
echo   If the deploy step fails with a Pages error, set the source once:
echo     Settings -^> Pages -^> Build and deployment -^> Source: GitHub Actions
echo   then re-run the workflow.
echo.
echo   When it goes green the preview is live at:
echo     https://dhanush7921.github.io/ROUTE-PLUS-PREVIEW/
echo.
pause
