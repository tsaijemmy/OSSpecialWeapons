# 用schtasks建立排程
schtasks /create ^
 /tn "Monitor JBoss" ^
 /sc MINIUTE ^
 /mo 5 ^
 /st 00:00 ^
 /ru "SYSTEM" ^
 /tr "powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\Jemmy\MonitorJBoss.ps1" ^
 /wd "D:\Jemmy"

