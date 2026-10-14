; 3. APPLICATIONS
; ---------------------------------------------------------
; [Alt + Key] Mapping Index
; ---------------------------------------------------------
; Microsoft Edge Legacy         |  LShift
; Microsoft Edge                |  Z
; Sublime Text 4                |  S
; Terminal                      |  CapsLock
; OneNote UWP                   |  Q
; Obsidian                      |  O
; Word                          |  W
; Excel                         |  E
; Desktop                       |  F
; Ren'Py                        |  R
; PdaNet+                       |  N
; Calculator                    |  C
; Proton VPN                    |  V
; BCUninstaller                 |  B
; LDPlayer                      |  A
; paint.net                     |  P
; Everything                    |  LWin
; LocalSend                     |  L
; HxD                           |  H
; Mp3tag                        |  M
; Audacity                      |  D
; Inkscape                      |  I
; CLIP STUDIO PAINT EX          |  \
; MuseScore 4                   |  [
; Ardour                        |  ]
; Chrome                        |  X
; OBS Studio                    |  U
; Close Active App              |  K
; ---------------------------------------------------------
; [Alt + Right Shift + Key] → Run as administrator
; ---------------------------------------------------------
; Sublime Text 4 (Admin)        |  S
; Terminal (Admin)              |  CapsLock
; PdaNet+ (Admin)               |  N
; BCUninstaller (Admin)         |  B
; Everything (Admin)            |  LWin
; HxD (Admin)                   |  H
; OBS Studio (Admin)            |  U
; ---------------------------------------------------------
; LDPlayer                      |  A
;  ├─ Inactive → activate
;  ├─ Not running → launch
;  └─ Re-press while active → toggle [Normal mode ⇄ Mini mode + 2x]
; ---------------------------------------------------------

; ★ Set this to your own .lnk shortcuts folder path.
global ShortcutsDir := "C:\Path\To\Your\Shortcuts"

; =========================================================
; Normal launch (Alt + Key)
; =========================================================

; Microsoft Edge Legacy  (Alt + Left Shift)
<!LShift::
{
    if WinExist("Edge ahk_exe ApplicationFrameHost.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Microsoft Edge Legacy")
}

; Microsoft Edge
!z::
{
    if WinExist("Edge ahk_class Chrome_WidgetWin_1")
        WinActivate()
    else
        Run(ShortcutsDir "\Microsoft Edge")
}

; Sublime Text 4
!s::
{
    if WinExist("ahk_exe sublime_text.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Sublime Text 4")
}

; Terminal
!CapsLock::
{
    if WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
        WinActivate()
    else
        Run(ShortcutsDir "\Terminal")
}

; OneNote UWP
!q::
{
    if WinExist("OneNote ahk_exe ApplicationFrameHost.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\OneNote UWP")
}

; Obsidian
!o::
{
    if WinExist("ahk_exe Obsidian.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Obsidian")
}

; Word
!w::Run(ShortcutsDir "\Word")

; Excel
!e::Run(ShortcutsDir "\Excel")

; Desktop
!f::
{
    if WinExist("Desktop ahk_exe explorer.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Desktop")
}

; Ren'Py
!r::
{
    if WinExist("Ren'Py ahk_exe renpy.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\renpy")
}

; PdaNet+
!n::Run(ShortcutsDir "\PdaNet+")

; Calculator
!c::
{
    if WinExist("Calculator ahk_exe ApplicationFrameHost.exe")
        WinActivate()
    else
        Run("ms-calculator:")
}

/*
; caffeine
!c::
{
    if !ProcessExist("caffeine64.exe")
        Run(ShortcutsDir "\caffeine")
}
*/

; Proton VPN
!v::Run(ShortcutsDir "\Proton VPN")

; BCUninstaller
!b::
{
    if WinExist("Uninstaller ahk_exe BCUninstaller.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\BCUninstaller")
}

; LDPlayer
global ldplayerMiniExpanded := false
global ldplayerMiniX := 0, ldplayerMiniY := 0
global ldplayerMiniW := 0, ldplayerMiniH := 0

!a::
{
    global ldplayerMiniExpanded
    global ldplayerMiniX, ldplayerMiniY, ldplayerMiniW, ldplayerMiniH

    if WinExist("LDPlayer ahk_exe dnplayer.exe")
    {
        if WinActive("LDPlayer ahk_exe dnplayer.exe")
        {
            if (!ldplayerMiniExpanded)
            {
                ; ── [Normal mode] → [Mini mode + 2x mini size] ──

                ; 1. Enter mini mode first (Ctrl + F1)
                Send("^{F1}")

                ; 2. Wait long enough for the mini-mode transition animation to finish
                Sleep(1200)

                ; 3. Read the window position/size of the resulting mini-mode state
                WinGetPos(&x, &y, &w, &h, "LDPlayer ahk_exe dnplayer.exe")
                ldplayerMiniX := x
                ldplayerMiniY := y
                ldplayerMiniW := w
                ldplayerMiniH := h

                ; 4. Expand to 2x that mini size
                WinMove(x, y, w * 2, h * 2, "LDPlayer ahk_exe dnplayer.exe")

                ldplayerMiniExpanded := true
            }
            else
            {
                ; ── [Mini mode + 2x] → [Normal mode] (exact reverse) ──

                ; 1. Shrink the window back to "mini mode original (1x)"
                WinMove(ldplayerMiniX, ldplayerMiniY
                      , ldplayerMiniW, ldplayerMiniH
                      , "LDPlayer ahk_exe dnplayer.exe")
                Sleep(300)

                ; 2. Exit mini mode (Ctrl + F1)
                Send("^{F1}")
                Sleep(1200)

                ldplayerMiniExpanded := false
            }
        }
        else
        {
            ; ── Inactive → activate only ──
            WinActivate("LDPlayer ahk_exe dnplayer.exe")
        }
    }
    else
    {
        ; ── Not running → reset state then launch ──
        ldplayerMiniExpanded := false
        Run(ShortcutsDir "\LDPlayer")
    }
}

; paint.net
!p::
{
    if WinExist("paint.net ahk_exe paintdotnet.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\paintdotnet")
}

; Everything
!LWin::
{
    if WinExist("Everything ahk_exe Everything.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Everything")
}

; LocalSend
!l::
{
    if WinExist("LocalSend ahk_exe localsend_app.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\LocalSend")
}

; HxD
!h::
{
    if WinExist("HxD ahk_exe HxD64.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\HxD")
}

; Mp3tag
!m::
{
    if WinExist("Mp3tag ahk_exe Mp3tag.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Mp3tag")
}

; Audacity
!d::
{
    if WinExist("ahk_exe Audacity.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Audacity")
}

; Inkscape
!i::
{
    if WinExist("Inkscape ahk_exe inkscape.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\inkscape")
}

; CLIP STUDIO PAINT EX
!\::
{
    if WinExist("CLIP ahk_exe CLIPStudioPaint.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\CLIPStudioPaint")
}

; MuseScore 4
![:: 
{
    if WinExist("MuseScore ahk_exe MuseScore4.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\MuseScore4")
}

; Ardour
!]::
{
    if WinExist("ahk_exe Ardour.exe")
        WinActivate()
    else
        Run(ShortcutsDir "\Ardour9")
}

; Chrome
!x::
{
    if WinExist("Chrome ahk_class Chrome_WidgetWin_1")
        WinActivate()
    else
        Run(ShortcutsDir "\Google Chrome")
}

; OBS Studio
!u::
{
    if WinExist("OBS ahk_exe obs64.exe")
        WinActivate()
    else
    {
        ; Trigger the elevated ThrottleStopOBS scheduled task
        Run("schtasks /run /tn ThrottleStopOBS", , "Hide")

        ; Launch OBS
        Run(ShortcutsDir "\OBS Studio")
    }
}

; Close the current active application
!k::
{
    if WinExist("A")
        WinClose()
}


; =========================================================
; Admin launch (Alt + Right Shift + Key)
; =========================================================

; Sublime Text 4 (Admin)
!>+s::LaunchAsAdmin(ShortcutsDir "\Sublime Text 4.lnk")

; Terminal (Admin)
!>+CapsLock::LaunchAsAdmin(ShortcutsDir "\Terminal.lnk")

; PdaNet+ (Admin)
!>+n::LaunchAsAdmin(ShortcutsDir "\PdaNet+.lnk")

; BCUninstaller (Admin)
!>+b::LaunchAsAdmin(ShortcutsDir "\BCUninstaller.lnk")

; HxD (Admin)
!>+h::LaunchAsAdmin(ShortcutsDir "\HxD.lnk")


; =========================================================
; App launch with admin privileges helper
; =========================================================
LaunchAsAdmin(appPath) {
    try {
        ; When using *RunAs, the file must include its extension (.lnk or .exe)
        Run('*RunAs "' appPath '"')
    } catch as e {
        ; Show the error cause on screen if launch fails
        MsgBox("Launch failed!`nPath: " appPath "`nError: " e.Message, "Admin launch error")
    }
}