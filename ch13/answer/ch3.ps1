# versionSQL.ps1

# 1. 密碼輸入 (隱碼)
$password = Read-Host "Please input the password of DBACCOUNT" -AsSecureString
$plainPwd = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecurePasswordToBSTR($password))

# 2. 環境清理
Remove-Item *.sql, *.log, *.err -ErrorAction SilentlyContinue
$date = Get-Date -Format "yyyyMMdd"
Write-Host "start version...$date"

$hostAddr = "ftp://1.1.1.1"
$user = "ftpuser"
$pass = "ftppwd"
$remotePath = "$hostAddr/UAT/${date}_UAT/DB"

# 3. FTP 下載函數 (簡易示意)
$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($user, $pass)

# 獲取檔案清單並下載 .sql
# 注意：此處需根據實際 FTP 目錄結構處理清單獲取
# 簡化範例：假設已獲取 $files
foreach ($file in $files) {
    if ($file -like "*.sql") {
        Write-Host "GET $file"
        $webClient.DownloadFile("$remotePath/$file", "$PWD/$file")
        
        Copy-Item "$file" "${file}.log"
        
        # 執行 sqlplus
        "exit" | sqlplus DBACCOUNT/${plainPwd}@DBSID "@$file" | Out-File "${file}.log" -Append
        # 錯誤捕捉略，建議用 $LASTEXITCODE 判斷
        
        # 4. 上傳回 FTP
        $webClient.UploadFile("$remotePath/$date/${file}.log", "${file}.log")
        
        if ((Get-Item "${file}.err").Length -gt 0) {
            $webClient.UploadFile("$remotePath/$date/${file}.err", "${file}.err")
        }
    }
}