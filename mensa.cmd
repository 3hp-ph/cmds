@echo off
setlocal
if "%1"=="1" set myday=monday
if "%1"=="2" set myday=tuesday
if "%1"=="3" set myday=wednesday
if "%1"=="4" set myday=thursday
if "%1"=="5" set myday=friday
@REM if "%1"=="t" (
    @REM for /f %%i in ('powershell -command "(Get-Date).DayOfWeek.ToString().ToLower()"') do set myday=%%i
@REM )
if "%1"=="" (
    set myday=
)
fflink "https://homeportal.hs-merseburg.de/plugins.php/mensaplugin/show/%myday%"