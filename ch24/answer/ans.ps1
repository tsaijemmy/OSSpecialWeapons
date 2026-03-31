# --- 1. 停用 RC4 128/128 密碼 ---
$ciphersPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"
$rc4Path = Join-Path $ciphersPath "RC4 128/128"

# 建立機碼 (如果不存在)
if (-not (Test-Path $rc4Path)) {
    New-Item -Path $rc4Path -Force | Out-Null
}
# 建立或設定 Enabled 為 0
New-ItemProperty -Path $rc4Path -Name "Enabled" -Value 0 -PropertyType DWord -Force | Out-Null


# --- 2. 停用 MD5 雜湊 ---
$hashesPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes"
$md5Path = Join-Path $hashesPath "MD5"

# 建立機碼 (如果不存在)
if (-not (Test-Path $md5Path)) {
    New-Item -Path $md5Path -Force | Out-Null
}
# 建立或設定 Enabled 為 0
New-ItemProperty -Path $md5Path -Name "Enabled" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "✅ 已成功停用 RC4 128/128 與 MD5 安全設定。" -ForegroundColor Green
Write-Host "提示：此設定需重啟系統後才能完全生效。" -ForegroundColor Yellow