# 檢查 $logfile 是否存在，且其大小 (Length) 是否為 0
# 加在  $tabcmd publish 之後
if (Test-Path $logfile) {
    if ((Get-Item $logfile).Length -eq 0) {
        Remove-Item $logfile
        Write-Host "Log檔為空，已自動刪除。"
    }
}