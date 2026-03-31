# 1. 取得目前執行中的所有 PowerShell 行程，並檢查其啟動參數是否包含本腳本檔名
# $MyInvocation.MyCommand.Name 會自動取得目前腳本的檔名 "MonitorJBoss.ps1"
$scriptName = $MyInvocation.MyCommand.Name
$currentPid = $PID # 取得目前這個視窗的 Process ID，避免把自己當成「別人」

$otherProcess = Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe' OR Name = 'pwsh.exe'" | 
                Where-Object { $_.CommandLine -like "*$scriptName*" -and $_.ProcessId -ne $currentPid }

# 2. 驗證邏輯
if ($otherProcess) {
    Write-Host "偵測到另一個 MonitorJBoss.ps1 正在執行中 (PID: $($otherProcess.ProcessId))"
    Write-Host "Running..."
    exit # 直接結束，不執行後續邏輯
}

$duration = (Get-Date) - (Get-Item "D:\EAP-6.3.0\jboss-eap-6.3\standalone\log\gc.log.0.current").LastWriteTime
Write-Host $duration.TotalMinutes
if ($duration.TotalMinutes -gt 3) {
        $NOW  = Get-Date -format "yyyyMMddHHmm"
        $msg   = Get-Date -Format "yyyy-MM-dd HH:mm"
        $msg   += " JBoss當了!!"
        Echo   $msg | Out-file -Encoding UTF8 -FilePath "D:\Jemmy\ALERT_TEC_${NOW}.log"
        Write-Host   "Restart..."
        Get-Service   -DisplayName "JBossEAP6" | Stop-Service
        Get-Service   -DisplayName "JBossEAP6" | Start-Service
        Start-Sleep -s 360   # 測試用，保持Process不消失 
} else {
        Write-Host   "Running..."
}