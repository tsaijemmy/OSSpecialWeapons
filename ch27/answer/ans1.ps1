# 1. 定義暫存檔案路徑
$cfgFile = "$env:TEMP\secpol.cfg"
$dbFile  = "$env:TEMP\secpol.sdb"

# 2. 匯出目前的安全性原則到文字檔
secedit /export /cfg $cfgFile /quiet

# 3. 讀取內容並修改指定的密碼原則
$config = Get-Content $cfgFile

# 設定值定義
$settings = @{
    "PasswordComplexity"     = 1   # 密碼必須符合複雜性要求 (1=啟用, 0=停用)
    "MaximumPasswordAge"     = 90  # 密碼最長有效期 (天)
    "MinimumPasswordLength"  = 8   # 密碼最短長度 (字元)
    "PasswordHistorySize"    = 5   # 強制執行密碼歷程記錄 (個數)
}

# 替換檔案中的數值
$config = $config -replace "^PasswordComplexity = .*", "PasswordComplexity = $($settings.PasswordComplexity)"
$config = $config -replace "^MaximumPasswordAge = .*", "MaximumPasswordAge = $($settings.MaximumPasswordAge)"
$config = $config -replace "^MinimumPasswordLength = .*", "MinimumPasswordLength = $($settings.MinimumPasswordLength)"
$config = $config -replace "^PasswordHistorySize = .*", "PasswordHistorySize = $($settings.PasswordHistorySize)"

# 將修改後的內容寫回暫存檔 (必須使用 Unicode 編碼以符合 secedit 要求)
$config | Out-File $cfgFile -Encoding unicode

# 4. 將修改後的設定匯入系統資料庫並立即生效
secedit /configure /db $dbFile /cfg $cfgFile /areas SECURITYPOLICY /quiet

# 5. 強制重新整理原則
gpupdate /force

# 6. 清理暫存檔
Remove-Item $cfgFile, $dbFile -ErrorAction Ignore

Write-Host "✅ 密碼安全性原則已更新成功！" -ForegroundColor Green