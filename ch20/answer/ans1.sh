#!/bin/bash

### BEGIN INIT INFO
# Provides:          tomcat7
# Required-Start:    $network
# Required-Stop:     $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/Stop Tomcat server
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin

start() {
    echo "Starting Tomcat..."
    systemctl start tomcat
}

stop() {
    echo "Stopping Tomcat..."
    systemctl stop tomcat
}

# 執行指令
case $1 in
    start|stop) 
        $1
        ;;
    restart) 
        stop
        start
        ;;
    *) 
        echo "Run as $0 <start|stop|restart>"
        exit 1
        ;;
esac

# --- 自殺/清理邏輯 ---
# 檢查父行程是否存在，若存在則正常退出 (exit)
# 若希望腳本在執行完動作後絕對不要殘留背景，可以加上以下檢查
if ps -p ${PPID} > /dev/null 2>&1; then
    echo "Process completed. Cleaning up..."
    exit 0
fi

# 如果程式執行到這還沒死，強制結束當前腳本行程
kill -9 $$ 2>/dev/null