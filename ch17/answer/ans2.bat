# 營業日啟動 (週一至週五 09:00)
schtasks /create /tn "SFTP_WorkDay_Start" /tr "powershell.exe -Command Start-Service sshd" /sc weekly /d MON,TUE,WED,THU,FRI /st 09:00 /rl HIGHEST /f

# 營業日關閉 (週一至週五 14:00)
schtasks /create /tn "SFTP_WorkDay_Stop" /tr "powershell.exe -Command Stop-Service sshd -Force" /sc weekly /d MON,TUE,WED,THU,FRI /st 14:00 /rl HIGHEST /f