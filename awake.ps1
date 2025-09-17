chcp 65001 > $null    # �ܼ��� UTF-8��
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

# â ũ�� ����
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

# ��׶��� ���� ����
$job = Start-Job {
    while ($true) {
        [SleepBlock]::SetThreadExecutionState(
            [SleepBlock]::ES_CONTINUOUS -bor [SleepBlock]::ES_SYSTEM_REQUIRED -bor [SleepBlock]::ES_DISPLAY_REQUIRED
        ) | Out-Null
        Start-Sleep -Seconds 5
    }
}

Write-Host "ȭ�� ���� ���� ���� ��..."
Write-Host ""
Write-Host "�����Ϸ��� Enter Ű�� ��������."

# Enter �Է� ���
[void][System.Console]::ReadLine()

# ���� ó��
Stop-Job $job
Remove-Job $job
Write-Host "��ũ��Ʈ�� �����մϴ�."
exit
