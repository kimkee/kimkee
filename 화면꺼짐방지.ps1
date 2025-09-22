
# 화면 꺼짐 방지 스크립트
# PowerShell 창을 열어 이 스크립트를 실행하면 화면이 꺼지지 않음
# 스크립트 종료 시 PowerShell 창을 닫으면 됨   
# 실행 정책이 제한되어 있을 경우, 관리자 권한으로 PowerShell을 열고 다음 명령어를 실행
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# 창 크기 조절
$Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size (30,6)
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size (30,6)

Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class SleepBlock {
  [DllImport("kernel32.dll")]
  public static extern uint SetThreadExecutionState(uint esFlags);
  public const uint ES_CONTINUOUS      = 0x80000000;
  public const uint ES_SYSTEM_REQUIRED = 0x00000001;
  public const uint ES_DISPLAY_REQUIRED= 0x00000002;
}
"@

$TIME = Get-Date -Format "yyyy-MM-dd HH:mm"

try {
    while ($true) {
        [SleepBlock]::SetThreadExecutionState(
            [SleepBlock]::ES_CONTINUOUS -bor [SleepBlock]::ES_SYSTEM_REQUIRED -bor [SleepBlock]::ES_DISPLAY_REQUIRED
        ) | Out-Null
        # Write-Output "System awake at $(Get-Date) "
        Write-Output "  "
        Write-Output "  화면 꺼짐 방지 실행 중..."
        Write-Output "  ========================="
        Write-Output "  $TIME"
        Write-Output "  $(Get-Date -Format "yyyy-MM-dd HH:mm") "
        Start-Sleep -Seconds 60
        Clear-Host # 화면 지우기
    }
} finally {
    [SleepBlock]::SetThreadExecutionState([SleepBlock]::ES_CONTINUOUS) | Out-Null
}
