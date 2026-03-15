Get-ChildItem -Path "'D:\projects" -Recurse -Filter *.java | ForEach-Object {
    Select-String -Pattern 'RemoteInvocation' -Path $_.FullName | ForEach-Object {
        "$($_.Path):$($_.LineNumber): $($_.Line.Trim())"
    }
}

