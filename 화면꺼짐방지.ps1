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

$TIME = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

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
        Write-Output "  $(Get-Date -Format "yyyy-MM-dd HH:mm:ss") "
        Start-Sleep -Seconds 33
        Clear-Host # 화면 지우기
    }
} finally {
    [SleepBlock]::SetThreadExecutionState([SleepBlock]::ES_CONTINUOUS) | Out-Null
}
