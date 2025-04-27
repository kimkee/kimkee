# 파일 경로: D:\workspace\kimkee\update-github.ps1

$repoPath = "D:\workspace\kimkee"
$updateFile = "$repoPath\update.json"
$today = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

# JSON 파일 덮어쓰기
@"
{
    "data": "$today"
}
"@ | Set-Content -Encoding UTF8 $updateFile

# Git 작업
Set-Location $repoPath
git pull
git add update.json
git commit -m "Update Readme on $today"
git push
