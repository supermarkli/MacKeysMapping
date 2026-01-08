#Requires AutoHotkey v2.0
#SingleInstance Force

; 切换映射开关：F8（始终可用）
#SuspendExempt
F8::Suspend
#SuspendExempt false

; ============================================================================
; MacKeys.ahk - Windows 下模拟 Mac 键位布局
; ============================================================================
;
; 功能说明：
;   - 将 Alt 键模拟为 Mac 的 Cmd 键
;   - 支持远程 Mac 模式（通过 RDP 连接时）和本地 Windows 模式自动切换
;
; 使用方式：
;   - 双击运行此脚本，托盘区会出现 AHK 图标
;   - 右键图标可退出或重新加载脚本
;
; ============================================================================

; ============================================================================
; 函数定义
; ============================================================================

IsRemoteMac() {
    clientName := Trim(GetRdpClientName())
    if (clientName = "")
        return false

    if InStr(clientName, "macbook") {
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

; ============================================================================
; 远程 Mac 模式 (通过 RDP 连接到 Win 时)
; ============================================================================

#HotIf IsRemoteMac()

; Alt + Tab -> Win + Tab (任务切换)
$!Tab::
{
    SendInput "{LAlt up}"
    Sleep 10
    SendEvent "#{Tab}"
    return
}

; Win 键映射
$#/::Send "^/"          ; 斜杠 (Win + / -> Ctrl + /)
$#b::Send "^b"          ; 加粗 (Win + B -> Ctrl + B)
$#s::Send "^s"          ; 保存 (Win + S -> Ctrl + S)
$#-::Send "^-"          ; 缩小 (Win + - -> Ctrl + -)
$#=::Send "^="          ; 放大 (Win + = -> Ctrl + =)
$#p::Send "^p"          ; 打印 (Win + P -> Ctrl + P)
$#[::Send "^["          ; 反缩进 (Win + [ -> Ctrl + [)
$#t::Send "^t"          ; 新建标签页 (Win + T -> Ctrl + T)
$#+k::Send "^+k"        ; 插入代码块 (Win + Shift + K -> Ctrl + Shift + K)

; ---- 光标移动 (Mac 上 Cmd+方向键) ----
$#Left::Send "{Home}"       ; Win + 左箭头 -> Home (行首)
$#Right::Send "{End}"       ; Win + 右箭头 -> End (行尾)
$#Up::Send "^{Home}"        ; Win + 上箭头 -> Ctrl+Home (文档头)
$#Down::Send "^{End}"       ; Win + 下箭头 -> Ctrl+End (文档尾)

; ---- Rectangle 分屏控制 (Mac 上 Ctrl+Option+方向键) ----
$^!Left::Send "#{Left}"     ; Ctrl + Option + 左箭头 -> Win + 左箭头 (左半屏)
$^!Right::Send "#{Right}"   ; Ctrl + Option + 右箭头 -> Win + 右箭头 (右半屏)
$^!Up::Send "#{Up}"         ; Ctrl + Option + 上箭头 -> Win + 上箭头 (最大化)
$^!Down::Send "#{Down}"     ; Ctrl + Option + 下箭头 -> Win + 下箭头 (还原)

#HotIf

; ============================================================================
; 本地 Windows 模式 (将 Alt 模拟 Mac 的 Cmd 键)
; ============================================================================

#HotIf !IsRemoteMac()

; ---- 基础编辑操作 ----
$!c::Send "^c"          ; 复制 (Alt + C -> Ctrl + C) 实现 Cmd + C
$!v::Send "^v"          ; 粘贴 (Alt + V -> Ctrl + V) 实现 Cmd + V
$!x::Send "^x"          ; 剪切 (Alt + X -> Ctrl + X) 实现 Cmd + X
$!z::Send "^z"          ; 撤销 (Alt + Z -> Ctrl + Z) 实现 Cmd + Z
$!+z::Send "^y"         ; 重做 (Alt + Shift + Z -> Ctrl + Y) 实现 Cmd + Shift + Z
$!a::Send "^a"          ; 全选 (Alt + A -> Ctrl + A) 实现 Cmd + A

; ---- 文件操作 ----
$!s::Send "^s"          ; 保存 (Alt + S -> Ctrl + S) 实现 Cmd + S
$!n::Send "^n"          ; 新建 (Alt + N -> Ctrl + N) 实现 Cmd + N
$!w::Send "^w"          ; 关闭 (Alt + W -> Ctrl + W) 实现 Cmd + W
$!p::Send "^p"          ; 搜索 (Alt + P -> Ctrl + P) 实现 Cmd + P
$!,::Send "^,"          ; 菜单 (Alt + , -> Ctrl + ,) 实现 Cmd + ,

; ---- 文本编辑 ----
$!b::Send "^b"          ; 加粗 (Alt + B -> Ctrl + B) 实现 Cmd + B
$!f::Send "^f"          ; 查找 (Alt + F -> Ctrl + F) 实现 Cmd + F
$!h::Send "^h"          ; 替换 (Alt + H -> Ctrl + H) 实现 Cmd + H
$!/::Send "^/"          ; 注释 (Alt + / -> Ctrl + /) 实现 Cmd + /
$![::Send "^["          ; 反缩进 (Alt + [ -> Ctrl + [) 实现 Cmd + [
$!+k::Send "^+k"        ; 插入代码块 (Alt + Shift + K -> Ctrl + Shift + K) 实现 Cmd + Shift + K

; ---- 浏览器/标签页 ----
$!t::Send "^t"          ; 新建标签页 (Alt + T -> Ctrl + T) 实现 Cmd + T
$!r::Send "^r"          ; 刷新 (Alt + R -> Ctrl + R) 实现 Cmd + R

; ---- 缩放控制 ----
$!=::Send "^{=}"        ; 放大 (Alt + = -> Ctrl + =) 实现 Cmd + =
$!-::Send "^{-}"        ; 缩小 (Alt + - -> Ctrl + -) 实现 Cmd + -
$!0::Send "^0"          ; 恢复大小 (Alt + 0 -> Ctrl + 0) 实现 Cmd + 0

#HotIf

; ============================================================================
; 应用专属快捷键
; ============================================================================

; ---- Typora 专属 ----
#HotIf !IsRemoteMac() && WinActive("ahk_exe Typora.exe")
{
    $!1::Send "^1"          ; 一级标题 (Alt + 1 -> Ctrl + 1) 实现 Cmd + 1
    $!2::Send "^2"          ; 二级标题 (Alt + 2 -> Ctrl + 2) 实现 Cmd + 2
    $!3::Send "^3"          ; 三级标题 (Alt + 3 -> Ctrl + 3) 实现 Cmd + 3
    $!4::Send "^4"          ; 四级标题 (Alt + 4 -> Ctrl + 4) 实现 Cmd + 4
    $!5::Send "^5"          ; 五级标题 (Alt + 5 -> Ctrl + 5) 实现 Cmd + 5
    $+!l::Send "^+l"        ; 侧边栏开关 (Alt + Shift + L -> Ctrl + Shift + L) 实现 Cmd + Shift + L
}
#HotIf

; ---- 浏览器专属 (Chrome, Edge, Firefox) ----
#HotIf !IsRemoteMac() && (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe msedge.exe") || WinActive("ahk_exe firefox.exe"))
{
    $!Left::Send "!{Left}"      ; 后退 (Alt + Left -> Alt + Left) 实现 Cmd + [
    $!Right::Send "!{Right}"    ; 前进 (Alt + Right -> Alt + Right) 实现 Cmd + ]
}
#HotIf

; ---- VS Code 专属 ----
#HotIf !IsRemoteMac() && WinActive("ahk_exe Code.exe")
{
    $!+p::Send "^+p"        ; 命令面板 (Alt + Shift + P -> Ctrl + Shift + P) 实现 Cmd + Shift + P
    $!g::Send "^g"          ; 跳转行号 (Alt + G -> Ctrl + G) 实现 Cmd + G
}
#HotIf

; ============================================================================
; 本地 Windows 模式 - 通用快捷键 (在应用专属之后处理)
; ============================================================================

#HotIf !IsRemoteMac()

; ---- 光标移动 ----
$!Left::Send "{Home}"   ; 光标移至行首 (Alt + Left -> Home) 实现 Cmd + Left
$!Right::Send "{End}"   ; 光标移至行尾 (Alt + Right -> End) 实现 Cmd + Right
$!Up::Send "^{Home}"    ; 光标移至文档头 (Alt + Up -> Ctrl + Home) 实现 Cmd + Up
$!Down::Send "^{End}"   ; 光标移至文档尾 (Alt + Down -> Ctrl + End) 实现 Cmd + Down

; ---- 文本选择 ----
$!+Left::Send "+{Home}"     ; 选中至行首 (Alt + Shift + Left -> Shift + Home) 实现 Cmd + Shift + Left
$!+Right::Send "+{End}"     ; 选中至行尾 (Alt + Shift + Right -> Shift + End) 实现 Cmd + Shift + Right
$!+Up::Send "^+{Home}"      ; 选中至文档头 (Alt + Shift + Up -> Ctrl + Shift + Home) 实现 Cmd + Shift + Up
$!+Down::Send "^+{End}"     ; 选中至文档尾 (Alt + Shift + Down -> Ctrl + Shift + End) 实现 Cmd + Shift + Down

; ---- 系统快捷键 ----
$!e::Send "#e"          ; 打开资源管理器 (Alt + E -> Win + E) 实现 Cmd + E

; ---- 聚焦搜索 (Alt + Space -> Win + S) 实现 Cmd + Space ----
; 使用 ~ 前缀允许原生 Alt+Space 行为，延迟触发 Win+S
~!Space::
{
    KeyWait "Alt"
    Sleep 50
    Send "#s"
    return
}

; ---- Win 键特殊映射 ----
$#z::Send "!z"          ; 自动换行 (Win + Z -> Alt + Z) 实现 Cmd + Z
$#1::Send "^!1"         ; 截图并复制 (Win + 1 -> Ctrl + Alt + 1) 实现 Cmd + 1
$#2::Send "^!2"         ; 贴图 (Win + 2 -> Ctrl + Alt + 2) 实现 Cmd + 2
$#3::Send "^!3"         ; 截图 (Win + 3 -> Ctrl + Alt + 3) 实现 Cmd + 3

; ---- 单击 LAlt 发送 Win 键 ----
~LAlt::Send "{Blind}{vkE8}"
~LAlt Up::
{
    if (A_PriorKey = "LAlt")
    {
        Send "{LWin}"
    }
}

; ---- Rectangle 分屏控制 (本地 Ctrl+Win+方向键) ----
$^#Left::Send "#{Left}"    ; Ctrl + Win + 左箭头 -> Win + 左箭头 (左半屏)
$^#Right::Send "#{Right}"  ; Ctrl + Win + 右箭头 -> Win + 右箭头 (右半屏)
$^#Up::Send "#{Up}"        ; Ctrl + Win + 上箭头 -> Win + 上箭头 (最大化)
$^#Down::Send "#{Down}"    ; Ctrl + Win + 下箭头 -> Win + 下箭头 (还原)

#HotIf
