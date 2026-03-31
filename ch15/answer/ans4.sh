perl_string="精誠資訊Systex"

# 編碼
encoded=$(echo -n "$perl_string" | jq -sRr @uri)
echo "Encoded: $encoded"

# 解碼 (利用 jq 的自訂處理)
decoded=$(echo -n "$encoded" | jq -r '@uri | test(".")') # jq 直接解碼需配合 printf 或自訂
# 或是更簡單的 python 解碼
echo -n "$encoded" | python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))"