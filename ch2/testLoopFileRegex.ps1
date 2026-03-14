$filename = "data.txt"

Get-Content $filename | ForEach-Object {
    $line = $_
    if ($line -match "ITHome") {
        Write-Output "Found ITHome: $line"
    } else {
        Write-Output "No match: $line"
    }
}

