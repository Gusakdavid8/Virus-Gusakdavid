@echo off
title maxwell cat - key maker
color 0C
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoP -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

if not exist "%SystemRoot%\Temp\mawxell_cat_keys" mkdir "%SystemRoot%\Temp\mawxell_cat_keys"

powershell -NoP -Command "$c='ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; $k=-join (1..12 | ForEach-Object { $c[(Get-Random -Max $c.Length)] }); Set-Content -LiteralPath 'C:\Windows\Temp\mawxell_cat_keys\key.txt' -Value $k -NoNewline -Encoding ASCII"

set /p KEY=<"%SystemRoot%\Temp\mawxell_cat_keys\key.txt"
echo %KEY%| clip

echo.
echo   ================================================
echo       NEW KEY GENERATED
echo   ================================================
echo.
echo     YOUR KEY : %KEY%
echo.
echo     copied to clipboard
echo     saved at : C:\Windows\Temp\mawxell_cat_keys\key.txt
echo.
echo     paste it into maxwell_cat.bat when it asks
pause
exit /b
