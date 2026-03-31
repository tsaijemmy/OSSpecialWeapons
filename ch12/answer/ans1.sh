#!/bin/bash

# 1. 取得上一小時的時間字串 (例如：2026032908)
# %Y%m%d%H 會產生 年月日時，-d "1 hour ago" 確保跨日/跨月時邏輯正確
PREV_HOUR=$(date -d "1 hour ago" +"%Y%m%d%H")

# 2. 定義路徑與變數
LOG_DIR="/var/log/jboss"
TARGET_LOG="${LOG_DIR}/access.${PREV_HOUR}.log"
OUTPUT_ZIP="/backup/log/access.${PREV_HOUR}.zip"

# 3. 檢查檔案是否存在，避免 zip 報錯
if [ ! -f "$TARGET_LOG" ]; then
    echo "錯誤：找不到上一小時的 Log 檔案 ($TARGET_LOG)"
    exit 1
fi

# 4. 使用 zip 加密壓縮
# -j: (junk paths) 不保留原始目錄結構，只存檔案本身
# -P: 直接帶入密碼，這裡讀取環境變數 $SALT
zip -j -P "$SALT" "$OUTPUT_ZIP" "$TARGET_LOG"

# 5. 檢查執行結果
if [ $? -eq 0 ]; then
    echo "成功：Log 已加密壓縮至 $OUTPUT_ZIP"
else
    echo "失敗：壓縮過程發生錯誤"
fi