@echo off
:: Starte PowerShell als Admin über die Batch-Datei
powershell -Command "Start-Process PowerShell -Verb RunAs"
