#Requires AutoHotkey v2.0
#SingleInstance Force

IsRemoteMac() {
    clientName := Trim(GetRdpClientName())
    if (clientName = "")
        return false

    if InStr(clientName, "zihao-macbook") {
        return true
    }

    return false
}
GetRdpClientName() {
    try {
        pBuffer := 0
        bytes := 0
        if !DllCall("wtsapi32\WTSQuerySessionInformationW"
            , "Ptr", 0              ; WTS_CURRENT_SERVER_HANDLE
            , "Int", -1             ; WTS_CURRENT_SESSION
            , "Int", 10             ; WTSClientName
            , "Ptr*", &pBuffer
            , "UInt*", &bytes)
            return ""
        
        name := StrGet(pBuffer, "UTF-16")
        DllCall("wtsapi32\WTSFreeMemory", "Ptr", pBuffer)
        return name
    } catch {
        return ""
    }
}

#HotIf IsRemoteMac()
$!Tab::
{
    SendInput "{LAlt up}"
    Sleep 10 ; 极短缓冲
    SendEvent "#{Tab}"
    return
}
$#/::Send "^/"
$#b::Send "^b"
$#s::Send "^s"
$#-::Send "^-"
$#=::Send "^="
$#p::Send "^p"
$#[::Send "^["

#HotIf

#HotIf !IsRemoteMac()
$!c::Send "^c"          ; 复制 (Alt + C -> Ctrl + C) 实现 Cmd + C
$!v::Send "^v"          ; 粘贴 (Alt + V -> Ctrl + V) 实现 Cmd + V
$!x::Send "^x"          ; 剪切 (Alt + X -> Ctrl + X) 实现 Cmd + X
$!z::Send "^z"          ; 撤销 (Alt + Z -> Ctrl + Z) 实现 Cmd + Z
$!+z::Send "^y"         ; 重做 (Alt + Shift + Z -> Ctrl + Y) 实现 Cmd + Shift + Z
$!a::Send "^a"          ; 全选 (Alt + A -> Ctrl + A) 实现 Cmd + A
$!s::Send "^s"          ; 保存 (Alt + S -> Ctrl + S) 实现 Cmd + S
$!/::Send "^/"          ; 注释 (Alt + / -> Ctrl + /) 实现 Cmd + /
$!p::Send "^p"          ; 搜素 (Alt + P -> Ctrl + P) 实现 Cmd + P
$!w::Send "^w"          ; 关闭 (Alt + W -> Ctrl + W) 实现 Cmd + W
$![::Send "^["          ; 反缩进 (Alt + [ -> Ctrl + [) 实现 Cmd + [
$#z::Send "!z"          ; 自动换行 (Win + Z -> Alt + Z) 实现 Cmd + Z

$!b::Send "^b"          ; 加粗 (Alt + B -> Ctrl + B) 实现 Cmd + B
$!n::Send "^n"          ; 新建 (Alt + N -> Ctrl + N) 实现 Cmd + N
$!e::Send "#e"          ; 打开资源管理器 (Alt + E -> Win + E) 实现 Cmd + E
$!f::Send "^f"          ; 查找 (Alt + F -> Ctrl + F) 实现 Cmd + F
$!h::Send "^h"          ; 替换 (Alt + H -> Ctrl + H) 实现 Cmd + H
$!t::Send "^t"          ; 新建标签页 (Alt + T -> Ctrl + T) 实现 Cmd + T
$!r::Send "^r"          ; 刷新 (Alt + R -> Ctrl + R) 实现 Cmd + R
$!=::Send "^{=}"        ; 放大 (Alt + = -> Ctrl + =) 实现 Cmd + =
$!-::Send "^{-}"        ; 缩小 (Alt + - -> Ctrl + -) 实现 Cmd + -
$!0::Send "^0"          ; 恢复大小 (Alt + 0 -> Ctrl + 0) 实现 Cmd + 0

$!Left::Send "{Home}"   ; 光标移至行首 (Alt + Left -> Home) 实现 Cmd + Left
$!Right::Send "{End}"   ; 光标移至行尾 (Alt + Right -> End) 实现 Cmd + Right
$!Up::Send "^{Home}"    ; 光标移至文档头 (Alt + Up -> Ctrl + Home) 实现 Cmd + Up
$!Down::Send "^{End}"   ; 光标移至文档尾 (Alt + Down -> Ctrl + End) 实现 Cmd + Down
$!+Left::Send "+{Home}" ; 选中至行首 (Alt + Shift + Left -> Shift + Home) 实现 Cmd + Shift + Left
$!+Right::Send "+{End}" ; 选中至行尾 (Alt + Shift + Right -> Shift + End) 实现 Cmd + Shift + Right
$!+Up::Send "^+{Home}"  ; 选中至文档头 (Alt + Shift + Up -> Ctrl + Shift + Home) 实现 Cmd + Shift + Up
$!+Down::Send "^+{End}" ; 选中至文档尾 (Alt + Shift + Down -> Ctrl + End) 实现 Cmd + Shift + Down
$!Space::Send "#s"               ; 聚焦搜索 (Alt + Space -> Win + S) 实现 Cmd + Space

$#1::Send "^!1"  ; 截图并复制 (Win + 1 -> Ctrl + Alt + 1) 实现 Cmd + 1
$#2::Send "^!2"  ; 贴图 (Win + 2 -> Ctrl + Alt + 2) 实现 Cmd + 2
$#3::Send "^!3"  ; 截图 (Win + 3 -> Ctrl + Alt + 3) 实现 Cmd + 3

~LAlt::Send "{Blind}{vkE8}"
~LAlt Up::
{
    if (A_PriorKey = "LAlt")
    {
        Send "{LWin}"
    }
}
#HotIf
