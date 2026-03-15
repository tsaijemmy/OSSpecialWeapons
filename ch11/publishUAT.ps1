$account = Read-Host "Enter Tableau Account"
$securePwd = Read-Host "Enter Tableau's password" -AsSecureString
$plainPwd =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd))
$NOW = Get-Date -format "yyyyMMdd"
$folder = $folder.replace("YYYYMMDD", $NOW)
Get-ChildItem $folder -Recurse | ForEach { (Get-Content -Encoding UTF8 $_ | ForEach {$_ -replace '10.7.20.59', '$ip'}) | Set-Content -Encoding UTF8 $_ }
Get-ChildItem $folder -Recurse | ForEach { (Get-Content -Encoding UTF8 $_ | ForEach {$_ -replace "version='10.4'", "version='10.5'"}) | Set-Content -Encoding UTF8 $_ }
Get-ChildItem $folder -Recurse | ForEach { (Get-Content -Encoding UTF8 $_ | ForEach {$_ -replace "port='.+?'", "port='$port'"}) | Set-Content -Encoding UTF8 $_ }
Get-ChildItem $folder -Recurse | ForEach { (Get-Content -Encoding UTF8 $_ | ForEach {$_ -replace "service='.+?'", "service='$service'"}) | Set-Content -Encoding UTF8 $_ }

Get-ChildItem -Path $folder | ForEach {
    $logfile =  $_.FullName.replace('.twb', '.log')
    & $tabcmd publish $_.FullName -n $_.BaseName -s $url --username $account --password $plainPwd --db-username $dbaccount --db-password $dbpwd --Project $project --save-db-password --save-oauth --overwrite --tabbed 2> $logfile
}