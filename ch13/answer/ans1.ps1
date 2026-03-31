# mask-ip.ps1
$files = Get-ChildItem "./*.txt"

foreach ($file in $files) {
    $log = $file.FullName + ".log"
    Write-Host "gen $log ..."

    # 讀取檔案內容並進行取代
    # $1, $2 等在 PowerShell 中需使用 `${1}` 或引號標註
    (Get-Content $file.FullName) | ForEach-Object {
        $_ -replace '(\d{1,3}\.){3}(\d{1,3})', 'x.y.z.$2'
    } | Out-File -FilePath $log -Encoding UTF8
}