param(
    [Parameter(Mandatory=$true)]
    [string]$commit1,
    [Parameter(Mandatory=$true)]
    [string]$commit2
)

# 1. 準備目錄
$basePath = Get-Location
$outputDir = Join-Path $basePath "output_linux"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# 2. 產生差異清單
git diff $commit1 $commit2 --name-status --diff-filter=AM > "$outputDir/SOURCE_AM.log"
git diff $commit1 $commit2 --name-status --diff-filter=D  > "$outputDir/SOURCE_D.log"
git diff $commit1 $commit2 --name-status --diff-filter=R  > "$outputDir/SOURCE_R.log"

Write-Host "差異清單已產生於 $outputDir"

# 3. 複製 AM 檔案
$amList = Get-Content "$outputDir/SOURCE_AM.log"
foreach ($line in $amList) {
    $parts = $line -split "`t"
    if ($parts.Length -eq 2) {
        $filePath = $parts[1].Trim().Replace('\', '/') # 確保路徑斜線正確
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

# 4. 產生刪檔 shell script
$deleteSh = "$outputDir/delete_files.sh"
# 寫入 Shebang
"@#!/bin/bash`n" | Out-File $deleteSh -Encoding utf8 -NoNewline

$delList = Get-Content "$outputDir/SOURCE_D.log"
foreach ($line in $delList) {
    $parts = $line -split "`t"
    if ($parts.Length -eq 2) {
        $filePath = $parts[1].Trim().Replace('\', '/')
        # Linux 指令: rm -f "path"
        Add-Content $deleteSh "rm -f `"./$filePath`""
    }
}
Write-Host "刪檔指令已輸出至 delete_files.sh"

# 5. 產生改名 shell script
$renameSh = "$outputDir/rename_files.sh"
"@#!/bin/bash`n" | Out-File $renameSh -Encoding utf8 -NoNewline

$renameList = Get-Content "$outputDir/SOURCE_R.log"
foreach ($line in $renameList) {
    $parts = $line -split "`t"
    if ($parts.Length -eq 3) {
        $oldPath = $parts[1].Trim().Replace('\', '/')
        $newPath = $parts[2].Trim().Replace('\', '/')
        # Linux 指令: mv "old" "new"
        Add-Content $renameSh "mv `"./$oldPath`" `"./$newPath`""
    }
}
Write-Host "改名指令已輸出至 rename_files.sh"

Write-Host "`n✅ 完成！結果位於：$outputDir"
Write-Host "提示：上傳至 Linux 後請執行 'chmod +x *.sh' 並注意檔案換行格式。" -ForegroundColor Yellow