# 定義字串
$perl_string = "精誠資訊Systex"

# 1. URI Escape (編碼)
Add-Type -AssemblyName System.Web
$encoded = [System.Web.HttpUtility]::UrlEncode($perl_string)
Write-Host "Encoded: $encoded"

# 2. URI Unescape (解碼)
$decoded = [System.Web.HttpUtility]::UrlDecode($encoded)
Write-Host "Decoded: $decoded"