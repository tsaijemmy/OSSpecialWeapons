#!/bin/bash
# Usage: ./ans2.sh [Target_JDK_Major] [Download_Path]
# 第二題是相依性管理的Script，比如從Spring 4到Spring 5
TARGET_JDK=$1
DOWNLOAD_PATH=${2:-"./downloads"} # 若無第二參數，預設下載到 ./downloads
COMPONENTS_FILE="components.txt"

# 色彩設定
green='\033[0;32m'
red='\033[0;31m'
endColor='\033[0m'

if [ -z "$TARGET_JDK" ]; then
    echo "Usage: $0 [JDK_Major_Version] [Optional: Destination_Path]"
    echo "Example: $0 52 /tmp/libs (52 is Java 8)"
    exit 1
fi

# 建立目標目錄
mkdir -p "$DOWNLOAD_PATH"

echo -e "--- 開始篩選 JDK 版本為 ${TARGET_JDK} 的組件 ---"

while read -r line; do
    [ -z "$line" ] && continue
    
    # 模擬從 Maven 倉庫取得 Jar 的邏輯 (實務上會從 Nexus 或本地 .m2 找檔案)
    # 這裡我們假設 Jar 檔名與 ArtifactId-Version.jar 一致
    artifact=$(echo $line | cut -d':' -f2)
    version=$(echo $line | cut -d':' -f3)
    jar_file="${artifact}-${version}.jar"

    # 檢查本地是否存在該檔案進行驗證 (假設檔案在目前目錄或指定 repo)
    if [ -f "$jar_file" ]; then
        # 呼叫第一題的邏輯：抓第一個 class 的版本
        major_version=$(javap -classpath "$jar_file" -verbose $(jar -tf "$jar_file" | grep '\.class$' | head -n 1 | sed 's/\.class$//') | grep 'major version' | cut -d':' -f2 | xargs)

        if [ "$major_version" == "$TARGET_JDK" ]; then
            echo -e "${green}[MATCH]${endColor} $line (Major: $major_version)"
            echo "正在複製/下載 $jar_file 到 $DOWNLOAD_PATH ..."
            cp "$jar_file" "$DOWNLOAD_PATH/"
        else
            echo "[SKIP ] $line (Major: $major_version)"
        fi
    else
        echo -e "${red}[ERROR]${endColor} 找不到實體檔案 $jar_file，無法驗證版本。"
    fi
done < "$COMPONENTS_FILE"