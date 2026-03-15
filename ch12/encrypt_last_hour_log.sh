$#!/bin/ksh
# encrypt_last_hour_log.sh
# 設定基本變數
export PATH=/usr/bin:/usr/sbin:/bin:/usr/local/bin # 確保 cron 環境找得到指令
LOG_DIR="/opt/app/log"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="/tmp/encrypt_log_$(date '+%Y%m%d_%H%M').log"

# 取得上一小時時間戳記
LAST_HOUR=$(perl -MPOSIX -le 'print strftime("%Y-%m-%d_%H", localtime(time - 3600))')

echo "[INFO] ===== $(date '+%Y-%m-%d %H:%M:%S') Start Encrypting =====" >> "$LOG_FILE"

# 檢查 SALT 環境變數
if [ -z "$SALT" ]; then
  echo "[ERROR] SALT 環境變數未設定，請 export SALT=your_passphrase" >> "$LOG_FILE"
  exit 1
fi

# 切換至 LOG 目錄
if ! cd "$LOG_DIR"; then
  echo "[ERROR] 無法切換到日誌目錄：$LOG_DIR" >> "$LOG_FILE"
  exit 1
fi

# 找出上一小時的壓縮檔並進行加密
FOUND=0
for SRC_FILE in *"${LAST_HOUR}.log.zip"; do
  [ -e "$SRC_FILE" ] || continue
  FOUND=1

  ENC_FILE="${SRC_FILE}.enc"
  echo "[INFO] 加密中：$SRC_FILE → $ENC_FILE" >> "$LOG_FILE"

  if openssl enc -aes-256-cbc -salt -in "$SRC_FILE" -out "$ENC_FILE" -pass env:SALT; then
    echo "[INFO] 加密成功，刪除原始檔：$SRC_FILE" >> "$LOG_FILE"
    rm -f "$SRC_FILE"
  else
    echo "[ERROR] 加密失敗：$SRC_FILE" >> "$LOG_FILE"
  fi
done

[ "$FOUND" -eq 0 ] && echo "[INFO] 無符合 ${LAST_HOUR}.log.zip 的檔案" >> "$LOG_FILE"

echo "[INFO] ===== Encrypting Finished =====" >> "$LOG_FILE"


# openssl enc -aes-256-cbc -salt -in "$SRC_FILE" -out "$ENC_FILE" -pass env:SALT
# openssl enc -d -aes-256-cbc -in xxx.zip.enc -out xxx.zip -pass pass:YourStrongPassword
# 0 * * * * /path/to/encrypt_last_hour_log.sh >> /var/log/encrypt_zip.log 2>&1
