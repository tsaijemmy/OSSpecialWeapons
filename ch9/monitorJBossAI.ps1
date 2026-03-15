# 指定 Log 檔路徑與關鍵字
$logFilePath = "D:\EAP-6.3.0\jboss-eap-6.3\standalone\log\gc.log.0.current"
$keyword = "check scheduer sync..."
# 取得log最後修改時間與現在系統時間差
$duration = (Get-Date) - (Get-Item $logFilePath).LastWriteTime
Write-Host $duration.TotalMinutes
if ($duration.TotalMinutes -gt 3) {         # 逾時三分鐘未寫Log
        $NOW  = Get-Date -format "yyyyMMddHHmm"
        $msg   = Get-Date -Format "yyyy-MM-dd HH:mm"
        $msg   += " 批次當了!!"
        Echo   $msg | Out-file -Encoding UTF8 -FilePath "D:\Jemmy\ ALERT _TEC_${NOW}.log"
        Write-Host   "Restart..."
        Get-Service   -DisplayName "JBossEAP6" | Stop-Service
        Get-Service   -DisplayName "JBossEAP6" | Start-Service
} else {
    # 讀取 Log 檔並搜尋最後一次出現關鍵字的行
    $lastOccurrenceLine = Get-Content $logFilePath | Select-String -Pattern $keyword | Select-Object -Last 1

    if ($lastOccurrenceLine -ne $null) {
        # 嘗試從該行提取日期時間
        if ($lastOccurrenceLine.Line -match "\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}\.\d{3}") {
            $logTimestamp = [datetime]::ParseExact($matches[0], "yyyy/MM/dd HH:mm:ss.fff", $null)
            
            # 計算時間差（以毫秒為單位）
            $currentTime = Get-Date
            $timeDifference = ($currentTime - $logTimestamp).TotalMilliseconds
            
            # 顯示結果
            Write-Output "最後一次出現 '$keyword' 的時間是：$logTimestamp"
            Write-Output "距離現在的時間差是：$timeDifference 毫秒"
            if ($timeDifference > 60000) {      # 逾時一分鐘未執行排程同步
                NOW   = Get-Date -format "yyyyMMddHHmm"
                $msg   = Get-Date -Format "yyyy-MM-dd HH:mm"
                $msg   += " 排程同步逾時!!"
                Echo   $msg | Out-file -Encoding UTF8 -FilePath "D:\Jemmy\ALTER_TEC_${NOW}.log"
                Write-Host   "Restart..."
                Get-Service   -DisplayName "JBossEAP6" | Stop-Service
                Get-Service   -DisplayName "JBossEAP6" | Start-Service
            }
        } else {
            Write-Output "無法從該行提取有效的日期時間格式。行內容：$($lastOccurrenceLine.Line)"
        }
    } else {
        Write-Output "關鍵字 '$keyword' 未在檔案中找到。"
        NOW   = Get-Date -format "yyyyMMddHHmm"
        $msg   = Get-Date -Format "yyyy-MM-dd HH:mm"
        $msg   += " 排程同步未執行!!"
        Echo   $msg | Out-file -Encoding UTF8 -FilePath "D:\Jemmy\ALTER_TEC_${NOW}.log"
        Write-Host   "Restart..."
        Get-Service   -DisplayName "JBossEAP6" | Stop-Service
        Get-Service   -DisplayName "JBossEAP6" | Start-Service
    }
}
