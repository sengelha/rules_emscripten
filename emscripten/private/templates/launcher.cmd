@echo off
setlocal

call :findrunfile {launcher_exe},LAUNCHER_EXE
IF ERRORLEVEL 1 EXIT /b 1

"%LAUNCHER_EXE%" -n {node} -e {js_file}
exit /b

:findrunfile
if exist %1 (
    set "%~2=%1"
    exit /b 0
)

if "%RUNFILES_MANIFEST_FILE%"=="" (
    set RUNFILES_MANIFEST_FILE=MANIFEST
)

if exist %RUNFILES_MANIFEST_FILE% (
    for /f "tokens=1,2" %%a in (%RUNFILES_MANIFEST_FILE%) do (
        if "%%a" == "%1" (
            set "%~2 = %%b"
            exit /b 0
        )
    )
)

echo ERROR: Runfile %1 not found 1>&2
exit /b 1