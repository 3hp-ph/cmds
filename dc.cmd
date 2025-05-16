@echo off
start "" "C:\Users\%USERNAME%\AppData\Local\Discord\Update.exe" --processStart "Discord.exe"
if "%~1"=="d" (
    start "" "D:\Anwendungen\meins\cmds\res\goToDeniz.ahk"
)