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
} else {
        Write-Host   "Running..."
}

