$NOW = Get-Date -format "yyyyMMddHHmm"
Write-Host 現主時：”$NOW"
Write-Host (Invoke-Expression -Command "date +%Y%m%d%H%M")

