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
; [Alt + Right Shift + Key] → 관리자 권한 실행
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
;  ├─ 비활성 → 활성화
;  ├─ 미실행 → 실행
;  └─ 활성 상태에서 재입력 → [일반모드 ⇄ 미니모드+2배] 토글
; ---------------------------------------------------------

; ★ 본인의 .lnk 단축아이콘 폴더 경로로 수정하세요.
global ShortcutsDir := "C:\Path\To\Your\Shortcuts"

; =========================================================
; 일반 실행 (Alt + Key)
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
                ; ── [일반모드] → [미니모드 + 미니크기 2배] ──

                ; 1. 먼저 미니 모드 진입 (Ctrl + F1)
                Send("^{F1}")

                ; 2. 미니 모드 전환 애니메이션이 끝날 때까지 충분히 대기
                Sleep(1200)

                ; 3. 미니 모드가 된 "그 상태"의 창 위치/크기 읽기
                WinGetPos(&x, &y, &w, &h, "LDPlayer ahk_exe dnplayer.exe")
                ldplayerMiniX := x
                ldplayerMiniY := y
                ldplayerMiniW := w
                ldplayerMiniH := h

                ; 4. 그 미니 크기의 2배로 확장
                WinMove(x, y, w * 2, h * 2, "LDPlayer ahk_exe dnplayer.exe")

                ldplayerMiniExpanded := true
            }
            else
            {
                ; ── [미니모드 + 2배] → [일반모드] (정확히 거꾸로) ──

                ; 1. 창 크기를 "미니 모드 원본(1배)"으로 축소
                WinMove(ldplayerMiniX, ldplayerMiniY
                      , ldplayerMiniW, ldplayerMiniH
                      , "LDPlayer ahk_exe dnplayer.exe")
                Sleep(300)

                ; 2. 미니 모드 해제 (Ctrl + F1)
                Send("^{F1}")
                Sleep(1200)

                ldplayerMiniExpanded := false
            }
        }
        else
        {
            ; ── 비활성 → 활성화만 ──
            WinActivate("LDPlayer ahk_exe dnplayer.exe")
        }
    }
    else
    {
        ; ── 미실행 → 상태 초기화 후 실행 ──
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
        ; 관리자 권한 ThrottleStopOBS 작업 트리거
        Run('schtasks /run /tn ThrottleStopOBS', , 'Hide')

        ; OBS 실행
        Run(ShortcutsDir "\OBS Studio")
    }
}

; Close the current active application
!k::
{
    if WinExist("A")
        WinClose
}


; =========================================================
; 관리자 실행 (Alt + Right Shift + Key)
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
; 관리자 권한으로 앱 실행 헬퍼
; =========================================================
LaunchAsAdmin(appPath) {
    try {
        ; *RunAs를 사용할 때는 파일 끝에 확장자(.lnk 또는 .exe)가 필수입니다.
        Run('*RunAs "' appPath '"')
    } catch as e {
        ; 실행 실패 시 화면에 에러 원인을 표시합니다.
        MsgBox("실행 실패!`n경로: " appPath "`n에러 원인: " e.Message, "관리자 실행 에러")
    }
}