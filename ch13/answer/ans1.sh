#!/bin/bash
# mask-ip.sh

for file in ./*.txt; do
    # 檢查檔案是否存在（避免 glob 失敗）
    [ -e "$file" ] || continue
    
    log="${file}.log"
    echo "gen $log ..."

    # 使用正則表達式取代 IP
    # [0-9]\{1,3\} 對應 Perl 的 \d{1,3}
    sed -E 's/([0-9]{1,3}\.){3}([0-9]{1,3})/x.y.z.\2/g' "$file" > "$log"
done