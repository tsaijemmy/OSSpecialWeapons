#!/bin/bash
# Usage: ./ans1.sh ./target/*.jar
# 修正版：支援多個 JAR 參數，且每個 JAR 只檢查第一個 class

# ANSI 色彩設定
blue='\033[0;34m'  
red='\033[0;31m'  
green='\033[0;32m'
endColor='\033[0m'

color_msg() {
  local l_color="$1"
  local l_msg="$2"
  echo -e "${l_color}$l_msg${endColor}"
}

usage() {
  echo "Usage: $0 jarfile1 [jarfile2 ...]"
  echo " -h|--help: show this usage"
  exit 1 
}

# 核心邏輯：判斷單一 JAR 檔的版本
check_jar_version() {
  local l_jar="$1"
  
  if [ ! -f "$l_jar" ]; then
    color_msg $red "Error: File '$l_jar' not found."
    return
  fi

  # 1. 取得第一個 .class 檔名 (使用 head -n 1 提升速度)
  local first_class=$(jar -tf "$l_jar" | grep '\.class$' | head -n 1)

  if [ -z "$first_class" ]; then
    color_msg $blue "[$l_jar] No class files found."
    return
  fi

  # 2. 轉換路徑格式並使用 javap 提取 major version
  local class_path_name=$(echo $first_class | sed -e 's/\.class$//')
  local major_version=$(javap -classpath "$l_jar" -verbose "$class_path_name" 2>/dev/null | grep 'major version' | cut -f2 -d ":" | xargs)

  # 3. 版本對照表
  case $major_version in
    45.3) java_version="Java 1.1";;
    46)   java_version="Java 1.2";;
    47)   java_version="Java 1.3";;
    48)   java_version="Java 1.4";;
    49)   java_version="Java 5";;
    50)   java_version="Java 6";;
    51)   java_version="Java 7";;
    52)   java_version="Java 8";;
    53)   java_version="Java 9";;
    54)   java_version="Java 10";;
    55)   java_version="Java 11";;
    56)   java_version="Java 12";;
    57)   java_version="Java 13";;
    58)   java_version="Java 14";;
    59)   java_version="Java 15";;
    60)   java_version="Java 16";;
    61)   java_version="Java 17";;
    62)   java_version="Java 18";;
    63)   java_version="Java 19";;
    64)   java_version="Java 20";;
    65)   java_version="Java 21";;
    66)   java_version="Java 22";;
    67)   java_version="Java 23";;
    *)    java_version="Unknown($major_version)";;
  esac

  # 4. 輸出結果：[版本] 檔案名稱
  printf "${green}[%-8s]${endColor} %s\n" "$java_version" "$l_jar"
}

# 檢查參數數量
if [ $# -lt 1 ]; then
  usage
fi

# 處理所有傳入的參數
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    *)
      check_jar_version "$1"
      ;;
  esac
  shift
done