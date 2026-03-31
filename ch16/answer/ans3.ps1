# 設定輸出編碼為 UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Escape-XmlChar {
    param([string]$s)
    $esc = @{
        '&' = '&amp;'; "'" = '&apos;'; '<' = '&lt;'; '>' = '&gt;'; '"' = '&quot;'
        '↑' = '[up arrow]';    '↓' = '[down arrow]'
        '←' = '[left arrow]';  '→' = '[right arrow]'
        '↖' = '[up-left]';     '↗' = '[up-right]'
        '↙' = '[down-left]';   '↘' = '[down-right]'
    }
    
    foreach ($key in $esc.Keys) {
        $s = $s.Replace($key, $esc[$key])
    }
    return $s
}

function Unescape-XmlChar {
    param([string]$s)
    # 反向定義
    $desc = @{
        '&amp;' = '&'; '&apos;' = "'"; '&lt;' = '<'; '&gt;' = '>'; '&quot;' = '"'
        '\[up arrow\]'    = '↑'; '\[down arrow\]'  = '↓'
        '\[left arrow\]'  = '←'; '\[right arrow\]' = '→'
        '\[up-left\]'     = '↖'; '\[up-right\]'    = '↗'
        '\[down-left\]'   = '↙'; '\[down-right\]'  = '↘'
    }
    
    foreach ($key in $desc.Keys) {
        # 使用 -replace 支援正則表達式 (處理括號轉義)
        $s = $s -replace $key, $desc[$key]
    }
    return $s
}

$name = "方向測試: ↖↗↙↘ 加上 <XML> 標籤 & '單引號'"
Write-Host "原文: $name"

$name1 = Escape-XmlChar $name
Write-Host "轉譯後: $name1"

$name2 = Unescape-XmlChar $name1
Write-Host "復原後: $name2"