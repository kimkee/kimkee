chcp 65001 > $null    # 콘솔을 UTF-8로
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

# 창 크기 조절
[Console]::WindowWidth = 60
[Console]::WindowHeight = 15

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

# 백그라운드 실행 시작
$job = Start-Job {
    while ($true) {
        [SleepBlock]::SetThreadExecutionState(
            [SleepBlock]::ES_CONTINUOUS -bor [SleepBlock]::ES_SYSTEM_REQUIRED -bor [SleepBlock]::ES_DISPLAY_REQUIRED
        ) | Out-Null
        Start-Sleep -Seconds 5
    }
}

Write-Host "화면 꺼짐 방지 실행 중..."
Write-Host ""
Write-Host "종료하려면 Enter 키를 누르세요."

# Enter 입력 대기
[void][System.Console]::ReadLine()

# 종료 처리
Stop-Job $job
Remove-Job $job
Write-Host "스크립트를 종료합니다."
exit
