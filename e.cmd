@echo off
IF "%~1"=="" (
    start explorer "%CD%"
) ELSE (
    start explorer "%*"
)