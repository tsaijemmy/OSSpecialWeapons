# MakeExeUAT.ps1
$account = Read-Host "Enter DB Account"
if (-not(Test-Path -Path ./"${account}.ini")) {
    Write-Host "No config for $account"
    Exit
}
$content = ( Get-Content .\${account}.ini | ConvertFrom-StringData)
$content = $content + @{dbaccount=$account}
$securePwd = Read-Host "Enter password" -AsSecureString
$plainPwd =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd))
$securePwd2 = Read-Host "Enter password Again" -AsSecureString
$plainPwd2 =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd2))
if ($plainPwd -cne $plainPwd2) {
    Write-Host "Password Inconsistent"
    Exit
}
$content = $content + @{dbpwd=$plainPwd}
"#publish.ps1 " | Out-File "publish.ps1"
$content.Keys | % {
    "`$$_ = " + '"' + $content.$_ + '"' | Add-Content "publish.ps1"
}
Get-Content .\publishUAT.ps1 | Add-Content "publish.ps1"

# 產出exe要改檔名，以DB Account前綴：TFA_publish.exe
."D:\hostdata\Jemmy\TechNet-Gallery-master\PS2EXE-GUI\ps2exe.ps1" .\publish.ps1 ".\${account}_publishUAT.exe" -verbose
# Remove-Item .\publish.ps1