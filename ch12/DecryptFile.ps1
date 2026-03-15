param(
    [Parameter(Mandatory = $true)]
    [string] $EncFile,

    [string] $Password = "StrongPassword"
)

if (-not (Test-Path $EncFile)) {
    Write-Error "File not found: $EncFile"
    exit 1
}

$ZipFile = $EncFile -replace "\.enc$", ""

Write-Output "Decrypting:"
Write-Output "  Input : $EncFile"
Write-Output "  Output: $ZipFile"

# ==========================================
# AES Key & IV
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
# 解密
# ==========================================
$in  = [System.IO.File]::OpenRead($EncFile)
$out = [System.IO.File]::Create($ZipFile)

$crypto = New-Object System.Security.Cryptography.CryptoStream(
    $in,
    $AES.CreateDecryptor(),
    'Read'
)

$crypto.CopyTo($out)

$crypto.Close()
$in.Close()
$out.Close()

Write-Output "Decryption complete!"

# ==========================================
# 自動解壓縮
# ==========================================
$Dest = "$ZipFile.unzip"

Write-Output "Extracting to: $Dest"

Expand-Archive -Path $ZipFile -DestinationPath $Dest -Force

Write-Output "Extraction complete: $Dest"

