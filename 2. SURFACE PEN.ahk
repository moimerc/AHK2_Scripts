; 2. SURFACE PEN
; ---------------------------------------------------------------------------
; [INDEX]
; ---------------------------------------------------------------------------
; ⬛ Surface Pen Hotkeys (LWin combos)
;    ├─ Force-kill active process         |  LWin + F18
;    ├─ Dismiss Alt-Tab menu              |  LWin + F19
;    └─ Open Alt-Tab menu                 |  LWin + F20
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