# 1. 載入必要的 .NET 組件
[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null

function screenshot([Drawing.Rectangle]$bounds, $path, $extension) {
    $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
    $graphics = [Drawing.Graphics]::FromImage($bmp)
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

    # 根據副檔名選擇儲存格式
    $format = [Drawing.Imaging.ImageFormat]::Png # 預設
    switch ($extension.ToLower()) {
        "jpg"  { $format = [Drawing.Imaging.ImageFormat]::Jpeg }
        "jpeg" { $format = [Drawing.Imaging.ImageFormat]::Jpeg }
        "bmp"  { $format = [Drawing.Imaging.ImageFormat]::Bmp }
        "gif"  { $format = [Drawing.Imaging.ImageFormat]::Gif }
    }

    $bmp.Save($path, $format)

    $graphics.Dispose()
    $bmp.Dispose()
    Write-Host "`n[成功] 截圖已儲存 ($($extension.ToUpper())): $path" -ForegroundColor Green
}

# --- 交互式輸入部分 ---
Write-Host "--- PowerShell 專業截圖工具 ---" -ForegroundColor Cyan

# 2. 詢問座標與尺寸
$left   = Read-Host "1. 起始 X 座標 (預設 0)"
$left   = if ($left -eq "") { 0 } else { [int]$left }

$top    = Read-Host "2. 起始 Y 座標 (預設 0)"
$top    = if ($top -eq "") { 0 } else { [int]$top }

$width  = Read-Host "3. 截圖寬度 (預設 1000)"
$width  = if ($width -eq "") { 1000 } else { [int]$width }

$height = Read-Host "4. 截圖高度 (預設 900)"
$height = if ($height -eq "") { 900 } else { [int]$height }

# 3. 詢問副檔名
Write-Host "可選格式: png, jpg, bmp, gif" -ForegroundColor Gray
$ext = Read-Host "5. 請輸入副檔名 (預設 png)"
if ($ext -eq "") { $ext = "png" }
# 去除使用者可能輸入的點 (例如 .jpg 變成 jpg)
$ext = $ext.TrimStart('.')

# 4. 詢問存檔路徑 (不含副檔名)
$basePath = Read-Host "6. 請輸入存檔路徑與檔名 (不含副檔名，例如 C:\my_capture)"
if ($basePath -eq "") { 
    $basePath = "$env:USERPROFILE\Desktop\screenshot_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}

# 組合完整路徑
$fullPath = "$basePath.$ext"

# 5. 執行截圖
try {
    $bounds = New-Object Drawing.Rectangle($left, $top, $width, $height)
    screenshot $bounds $fullPath $ext
}
catch {
    Write-Host "錯誤: 無法完成截圖。請確認資料夾權限或數值格式。" -ForegroundColor Red
    $_.Exception.Message
}