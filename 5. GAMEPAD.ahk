; 5. GAMEPAD
; ---------------------------------------------------------------------------
; [INDEX]
; ---------------------------------------------------------------------------
; ⬛ HOME button (Browser_Home)
;    ├─ Force-release all modifiers
;    ├─ D-PAD polling OFF (CheckPOV_A / CheckPOV_C)
;    └─ Launch Snipping Tool (ms-screenclip, 250ms debounce)
;
; 🎮 Gamepad buttons (single / long press)
;    ├─ A   (Joy1)                        |  Single: Sublime Text     Long: LDPlayer (+ D-PAD)
;    ├─ B   (Joy2)                        |  Single: Edge Legacy      Long: Edge
;    ├─ X   (Joy4)                        |  Single: CMD              Long: Terminal
;    ├─ Y   (Joy5)                        |  Single: OneNote          Long: Ctrl + P
;    ├─ L   (Joy7)                        |  Single: Release Alt/Shift   Long: Close window
;    ├─ R   (Joy8)                        |  Single: Alt + Tab        Long: Shift + Alt + Tab
;    ├─ L2  (Joy9)                        |  Single: Release Alt         Long: Close window
;    ├─ R2  (Joy10)                       |  Single: Alt + Tab        Long: OSK
;    ├─ ⊖   (Joy11)                       |  Single: Ctrl + Z         Long: Ctrl + S
;    └─ ⊕   (Joy12)                       |  Single: Ctrl + Y         Long: Ctrl + Shift + S
;
; 🕹 D-PAD (CheckPOV_A — activated by long-pressing A / deactivated by Home / LDPlayer only)
;    │   * Supports both positions of the LinYuvo KS54 physical mode switch (D-PAD ↔ Analog)
;    │
;    ├─ [D-PAD mode]  POV ↑    |  Alt + ←       |  Back
;    ├─ [D-PAD mode]  POV →    |  Alt + ↑       |  Home
;    ├─ [D-PAD mode]  POV ↓    |  Alt + →       |  Recent apps
;    ├─ [D-PAD mode]  POV ←    |  Alt + Enter   |  Fullscreen
;    │
;    ├─ [Analog mode] JoyX 0   |  Alt + Enter   |  Fullscreen
;    ├─ [Analog mode] JoyX 100 |  Alt + ↑       |  Home
;    ├─ [Analog mode] JoyY 0   |  Alt + ←       |  Back
;    └─ [Analog mode] JoyY 100 |  Alt + →       |  Recent apps
; ---------------------------------------------------------------------------


global lastHomePress_A := 0
global debounceTime_A := 250
global prevPOV_A := -1
global prevX_A := 50
global prevY_A := 50

; HOME-BUTTON
*Browser_Home::
{
    SendInput("{Blind}{LControl up}{RControl up}{LAlt up}{RAlt up}{LShift up}{RShift up}{LWin up}{RWin up}")

    ;Deactivate d-pad
    SetTimer(CheckPOV_A, 0)
    SetTimer(CheckPOV_C, 0)

    global lastHomePress_A
    currentTime := A_TickCount
    if (currentTime - lastHomePress_A > debounceTime_A)
    {
        Run("ms-screenclip:") 
        lastHomePress_A := currentTime
    }
    return
}


; A-BUTTON
Joy1::
{
    startTime := A_TickCount
    while GetKeyState("Joy1", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;Activate d-pad
            SetTimer(CheckPOV_C, 0) ;Prevent duplicate activation
            SetTimer(CheckPOV_A, 30) 

            ; --- Long Press ---
            if WinExist("LDPlayer ahk_exe dnplayer.exe")
            {   
                WinActivate()
            }
            else
            {
                Run(ShortcutsDir "\LDPlayer")
            } 
            return
        }
        Sleep 20
    }
    
    ; --- Single Press ---
    if WinExist("ahk_exe sublime_text.exe")
    {
        WinActivate()
    }
    else
    {
        Run(ShortcutsDir "\Sublime Text 4")
    }
}


; B-BUTTON
Joy2::
{
    startTime := A_TickCount
    while GetKeyState("Joy2", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            if WinExist("ahk_class Chrome_WidgetWin_1")
            {
                WinActivate()
            }
            else
            {
                Run(ShortcutsDir "\Microsoft Edge")
            }
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    if WinExist("Edge ahk_exe ApplicationFrameHost.exe")
    {   
        WinActivate()
    }
    else
    {
        Run(ShortcutsDir "\Microsoft Edge Legacy")
    }
}


; X-BUTTON
Joy4::
{
    startTime := A_TickCount
    while GetKeyState("Joy4", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            if WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
            {
                WinActivate()
            }
            else
            {
                Run(ShortcutsDir "\Terminal")
            }   
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    if WinExist("ahk_exe cmd.exe")
    {
        WinActivate()
    }
    else
    {
        Run(ShortcutsDir "\Command Prompt")
    }
}


; Y-BUTTON
Joy5::
{
    startTime := A_TickCount
    while GetKeyState("Joy5", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            SendInput("{Ctrl down}{p}{Ctrl up}")
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    if WinExist("OneNote ahk_exe ApplicationFrameHost.exe")
    {
        WinActivate()
    }
    else
    {
        Run(ShortcutsDir "\OneNote UWP")
    }
}


; L-BUTTON
Joy7::
{
    startTime := A_TickCount
    while GetKeyState("Joy7", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            if WinExist("A")
            {
                WinClose
            }
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    SendInput("{Alt up}{Shift up}")
}


; R-BUTTON
Joy8::
{
    startTime := A_TickCount
    while GetKeyState("Joy8", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            SendInput('{Shift down}{Alt down}{Tab}')
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    SendInput('{Shift up}{Alt down}{Tab}')
}


; L2-BUTTON
Joy9::
{
    startTime := A_TickCount
    while GetKeyState("Joy9", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            if WinExist("A")
            {
                WinClose
            }
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    SendInput("{Alt up}")
}


; R2-BUTTON
Joy10::
{
    startTime := A_TickCount
    while GetKeyState("Joy10", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            if WinExist("ahk_exe osk.exe")
            {
                WinActivate()
            }
            else
            {
                Run(ShortcutsDir "\On-Screen Keyboard")
            }
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    SendInput('{Alt down}{Tab}') 
}


; ⊖-BUTTON
Joy11::
{
    startTime := A_TickCount
    while GetKeyState("Joy11", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            SendInput('{Ctrl down}{s}{Ctrl up}')
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    SendInput('{Ctrl down}{z}{Ctrl up}')
}


; ⊕︀-BUTTON
Joy12::
{
    startTime := A_TickCount
    while GetKeyState("Joy12", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ; --- Long Press ---
            SendInput('{Ctrl down}{Shift down}{s}{Shift up}{Ctrl up}')
            return
        }
        Sleep 20
    }

    ; --- Single Press ---
    SendInput('{Ctrl down}{y}{Ctrl up}')
}


; D-PAD
CheckPOV_A() 
{
    global prevPOV_A, prevX_A, prevY_A
    pov := GetKeyState("JoyPOV")
    x := GetKeyState("JoyX")
    y := GetKeyState("JoyY")

    ; D-PAD1
    if (pov != prevPOV_A) 
    { 
        ; ↑ BUTTON  
        if (pov = 0) 
        {
            SendInput('{Alt down}{Left}{Alt up}')  
        }


        ; → BUTTON
        else if (pov = 9000)
        {
            SendInput('{Alt down}{Up}{Alt up}')
        }


        ; ↓ BUTTON
        else if (pov = 18000)
        {
            SendInput('{Alt down}{Right}{Alt up}')
        }


        ; ← BUTTON
        else if (pov = 27000)
        {
            SendInput('{Alt down}{Enter}{Alt up}')
        }
        prevPOV_A := pov
    }


    ; D-PAD2
    if (x != prevX_A)
    {
        ; ← BUTTON
        if (x = 0)
        {
            SendInput('{Alt down}{Enter}{Alt up}')
        } 
        ;→ BUTTON
        else if (x = 100)
        {
            SendInput('{Alt down}{Up}{Alt up}')
        }
        prevX_A := x
    }

    if (y != prevY_A)
    {
        ; ↑ BUTTON
        if (y = 0) 
        {
            SendInput('{Alt down}{Left}{Alt up}')
        } 
        ; ↓ BUTTON
        else if (y = 100) 
        {
            SendInput('{Alt down}{Right}{Alt up}')
        }
        prevY_A := y
    }
}