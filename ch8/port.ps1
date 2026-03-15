Get-NetTCPConnection -State Listen | ForEach-Object {
    $pida = $_.OwningProcess
    $proc = Get-Process -Id $pida -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        LocalPort = $_.LocalPort
        Protocol  = $_.Protocol
        ProcessID = $pida
        Process   = $proc.ProcessName
    }
} | Sort-Object LocalPort | Format-Table -AutoSize

