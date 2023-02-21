@echo off
setlocal

if "%RUNFILES_MANIFEST_FILE%"=="" (
    set RUNFILES_MANIFEST_FILE=MANIFEST
)

if not exist %RUNFILES_MANIFEST_FILE% (
    echo ERROR: %RUNFILES_MANIFEST_FILE% file not found 1>&2
    exit /b 1
)

for /f "tokens=1,2" %%a in (%RUNFILES_MANIFEST_FILE%) do (
    if "%%a" == "emscripten_sdk/launcher_/launcher.exe" (
        "%%b" -n {node} -e {workspace_name}/{js_file}
        exit /b
    )
)

echo ERROR: Launcher not found
exit /b 1