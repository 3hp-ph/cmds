@rem @echo off
@rem @start "C:\Program Files\Mozilla Firefox" firefox.exe "%CD%\%1"

@echo off
IF "%~1"=="" (
    start "C:\Program Files\Mozilla Firefox" firefox.exe --new-tab "about:newtab"
) ELSE (
    start "C:\Program Files\Mozilla Firefox" firefox.exe "%CD%\%1"
)