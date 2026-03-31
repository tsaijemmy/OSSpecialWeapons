#!/bin/bash
# versionSQL.sh

# 1. 隱藏輸入密碼
read -s -p "Please input the password of DBACCOUNT: " DB_PWD
echo ""

# 2. 環境清理與時間設定
rm -f *.sql *.log *.err
DATE=$(date +"%Y%m%d")
echo "start version...$DATE"

HOST="1.1.1.1"
FTP_USER="ftpuser"
FTP_PWD="ftppwd"
REMOTE_DIR="UAT/${DATE}_UAT/DB"

# 3. 使用 lftp 進行操作
lftp -u $FTP_USER,$FTP_PWD $HOST <<EOF
cd "$REMOTE_DIR"
mkdir -p "$DATE"
# 下載所有 .sql 檔案
mget *.sql
quit
EOF

# 4. 執行 SQL 並處理結果
for file in *.sql; do
    [ -e "$file" ] || continue
    echo "GET $file"
    
    # 複製成 log 檔案
    cp "$file" "${file}.log"
    
    # 執行 sqlplus (假設環境變數已設定)
    echo "exit" | sqlplus DBACCOUNT/"$DB_PWD"@DBSID @"$file" >> "${file}.log" 2> "${file}.err"
    
    # 5. 上傳結果回 FTP
    lftp -u $FTP_USER,$FTP_PWD $HOST <<EOF
    cd "$REMOTE_DIR/$DATE"
    put "${file}.log"
    # 若錯誤檔大小大於 0 則上傳
    if [ -s "../${file}.err" ]; then put "../${file}.err"; fi
    quit
EOF
done