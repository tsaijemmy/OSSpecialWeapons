param (
    [string]$Directory,
    [string]$Keyword
)

if (-not $Directory) {
    $Directory = Read-Host "Enter the directory to search"
}

if (-not $Keyword) {
    $Keyword = Read-Host "Enter the keyword to search for"
}

# Get all .pom files in the specified directory and its subdirectories
$pomFiles = Get-ChildItem -Path $Directory -Recurse -Filter *.pom

foreach ($file in $pomFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if ($content -match $Keyword) {
        Write-Output "Found '$Keyword' in file: $($file.FullName)"
    }
}
