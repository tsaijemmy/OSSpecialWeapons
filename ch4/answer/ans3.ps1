$hosts = Get-Content ./url.txt
$ciphers = Get-Content ./cipher.txt

foreach ($hostAddr in $hosts) {
    Write-Host "Testing Host: $hostAddr" -ForegroundColor Cyan
    
    foreach ($cipher in $ciphers) {
        Write-Host "  Using Cipher: $cipher" -ForegroundColor Yellow
        
        # 在 PowerShell 中，我們可以用 echo "QUIT" 傳遞給 openssl
        # -- 是為了確保參數正確傳遞給外部程式
        echo "QUIT" | openssl s_client -connect $hostAddr -cipher $cipher
        
        Write-Host "`n"
    }
}
