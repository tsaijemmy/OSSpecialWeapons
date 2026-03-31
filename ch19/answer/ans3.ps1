$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$name = "MaxUserPort"
$value = 65534

# 如果該路徑下還沒有這個數值，會自動建立；若已有則覆蓋
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord -Force