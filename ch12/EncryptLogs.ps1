# ==========================================
# 設定
# ==========================================
$ArchivePath = "D:\Project\logs\archive"
$Password    = "StrongPassword"

# ==========================================
# 計算上一小時
# ==========================================
$Prev = (Get-Date).AddHours(-1)
$TimeKey = $Prev.ToString("yyyy-MM-dd_HH")

# ==========================================
# 取得所有上一小時的 ZIP（多筆 IP 都要）
# 格式：jbranche_xxx.xxx.xxx.xxx.yyyy-MM-dd_HH.log.zip
# ==========================================
$Pattern = "*.$TimeKey.log.zip"
$ZipFiles = Get-ChildItem -Path $ArchivePath -Filter $Pattern

if ($ZipFiles.Count -eq 0) {
    Write-Output "No ZIP files found for: $Pattern"
    exit 0
}

Write-Output "Found $($ZipFiles.Count) file(s) to encrypt."
$ZipFiles | ForEach-Object { Write-Output "  $_" }

# ==========================================
# 準備 AES Key & IV（固定長度）
# ==========================================
$AES = [System.Security.Cryptography.Aes]::Create()
$AES.Mode = 'CBC'
$AES.Padding = 'PKCS7'

$AES.Key = (New-Object System.Text.UTF8Encoding).GetBytes(
    $Password.PadRight(32).Substring(0,32)
)
$AES.IV = (New-Object System.Text.UTF8Encoding).GetBytes(
    $Password.PadRight(16).Substring(0,16)
)

# ==========================================
# 處理每一個 zip
# ==========================================
foreach ($Zip in $ZipFiles) {

    $ZipPath = $Zip.FullName
    $EncPath = "$ZipPath.enc"

    Write-Output ""
    Write-Output "Encrypting:"
    Write-Output "  $ZipPath"
    Write-Output "  --> $EncPath"

    try {
        # 開檔案 stream
        $in  = [System.IO.File]::OpenRead($ZipPath)
        $out = [System.IO.File]::Create($EncPath)

        # crypto stream
        $crypto = New-Object System.Security.Cryptography.CryptoStream(
            $out,
            $AES.CreateEncryptor(),
            'Write'
        )

        $in.CopyTo($crypto)

        $crypto.Close()
        $in.Close()
        $out.Close()

        Write-Output "Encryption OK."

        # 刪除原 ZIP
        Remove-Item $ZipPath
        Write-Output "Deleted original ZIP: $ZipPath"

    }
    catch {
        Write-Error "ERROR encrypting $ZipPath : $_"
    }
}

Write-Output ""
Write-Output "All done."
