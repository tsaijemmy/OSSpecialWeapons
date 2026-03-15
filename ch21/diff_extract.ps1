# diff_extract.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$commit1,
    [Parameter(Mandatory=$true)]
    [string]$commit2
)

# 1. 準備目錄
$basePath = Get-Location
$outputDir = Join-Path $basePath "output"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# 2. 產生差異清單
git diff $commit1 $commit2 --name-status --diff-filter=AM > "$outputDir\SOURCE_AM.log"
git diff $commit1 $commit2 --name-status --diff-filter=D  > "$outputDir\SOURCE_D.log"
git diff $commit1 $commit2 --name-status --diff-filter=R  > "$outputDir\SOURCE_R.log"

Write-Host "差異清單已產生於 $outputDir"

# 3. 複製 AM 檔案
$amList = Get-Content "$outputDir\SOURCE_AM.log"
foreach ($line in $amList) {
    # 例如 "A	src/main/java/com/example/App.java"
    $parts = $line -split "`t"
    if ($parts.Length -eq 2) {
        $status = $parts[0].Trim()
        $filePath = $parts[1].Trim()
        $srcPath = Join-Path $basePath $filePath
        $dstPath = Join-Path $outputDir $filePath

        # 建立目標目錄結構
        $dstDir = Split-Path $dstPath -Parent
        if (-not (Test-Path $dstDir)) {
            New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
        }

        # 複製檔案
        if (Test-Path $srcPath) {
            Copy-Item -Path $srcPath -Destination $dstPath -Force
        }
    }
}
Write-Host "AM 類檔案已複製至 $outputDir"

# 4. 產生刪檔 batch
$deleteFile = "$outputDir\delete_files.bat"
Remove-Item $deleteFile -ErrorAction Ignore
$delList = Get-Content "$outputDir\SOURCE_D.log"
foreach ($line in $delList) {
    $parts = $line -split "`t"
    if ($parts.Length -eq 2) {
        $filePath = $parts[1].Trim()
        Add-Content $deleteFile ("del `"$basePath\$filePath`"")
    }
}
Write-Host "刪檔指令已輸出至 delete_files.bat"

# 5. 產生改名 batch
$renameFile = "$outputDir\rename_files.bat"
Remove-Item $renameFile -ErrorAction Ignore
$renameList = Get-Content "$outputDir\SOURCE_R.log"
foreach ($line in $renameList) {
    # 例如 "R100	src/old.java	src/new.java"
    $parts = $line -split "`t"
    if ($parts.Length -eq 3) {
        $oldPath = $parts[1].Trim()
        $newPath = $parts[2].Trim()
        Add-Content $renameFile ("rename `"$basePath\$oldPath`" `"$([System.IO.Path]::GetFileName($newPath))`"")
    }
}
Write-Host "改名指令已輸出至 rename_files.bat"

Write-Host "`n✅ 完成！結果位於：$outputDir"
