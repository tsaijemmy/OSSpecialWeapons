$file = "SoapGen.java"
$bytes = [System.IO.File]::ReadAllBytes($file)

# 檢查 UTF-8 BOM
if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    "File has UTF-8 BOM, removing..."
    [System.IO.File]::WriteAllBytes($file, $bytes[3..($bytes.Length-1)])
} else {
    "File does not have UTF-8 BOM"
}

