; 2. SURFACE PEN
; ---------------------------------------------------------------------------
; [INDEX]
; ---------------------------------------------------------------------------
; ⬛ Surface Pen 전용 단축키 (LWin 조합)
;    ├─ 활성 프로세스 강제 종료           |  LWin + F18
;    ├─ Alt-Tab 메뉴 닫기                |  LWin + F19
;    └─ Alt-Tab 메뉴 열기                |  LWin + F20
; ---------------------------------------------------------------------------

; Kill the current active process
<#F18::
{
    if WinExist("A")
    {
        processId := WinGetPID("A")
        ProcessClose(processId)
    }    
}

; Dismiss Alt-Tab Menu
<#F19::AltTabMenuDismiss

; Alt-Tab Menu
<#F20::AltTabAndMenu
