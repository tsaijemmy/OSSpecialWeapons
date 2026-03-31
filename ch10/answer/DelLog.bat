@echo off
:: 刪除 7 天前的 .log 檔案
forfiles /p "D:\EAP-6.3.0\jboss-eap-6.3\standalone\log" /s /m *.log /d -7 /c "cmd /c del @path"