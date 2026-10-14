; 6. CLIP STUDIO
; -------------------------------

#HotIf WinActive("ahk_exe CLIPStudioPaint.exe")

global TapCount := 0
global LastTapTime := 0
global lastHomePress_C := 0
global debounceTime_C := 250
global prevPOV_C := -1
global prevX_C := 50
global prevY_C := 50

; HOME-BUTTON
$Browser_Home::
{
    SendInput("{Blind}{LControl up}{RControl up}{LAlt up}{RAlt up}{LShift up}{RShift up}{LWin up}{RWin up}")

    ;Deactivate d-pad
    SetTimer(CheckPOV_A, 0)
    SetTimer(CheckPOV_C, 0)

    global lastHomePress_C
    currentTime := A_TickCount
    if (currentTime - lastHomePress_C > debounceTime_C)
    {
        SendInput("{LWin}")
        lastHomePress_C := currentTime
    }
    return
}


; A-BUTTON
Joy1::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy1", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy1CheckTaps, -250)
}

Joy1CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    TapCount := 0
    LastTapTime := 0
}


; B-BUTTON
Joy2::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy2", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy2CheckTaps, -250)
}

Joy2CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    TapCount := 0
    LastTapTime := 0
}


; X-BUTTON
Joy4::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy4", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy4CheckTaps, -250)
}

Joy4CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    TapCount := 0
    LastTapTime := 0
}


; Y-BUTTON
Joy5::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy5", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            SetTimer(CheckPOV_A, 0) ;Prevent duplicate activation
            SetTimer(CheckPOV_C, 30)

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy5CheckTaps, -250)
}

Joy5CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }  
    TapCount := 0
    LastTapTime := 0
}


; L-BUTTON
Joy7::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime
    
    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime
    startTime := A_TickCount

    while GetKeyState("Joy7", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY
        }
        Sleep 20
    }   
    SetTimer(Joy7CheckTaps, -250)
}

Joy7CheckTaps()
{
    global TapCount, LastTapTime

    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    TapCount := 0
    LastTapTime := 0
}


; R-BUTTON
Joy8::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy8", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy8CheckTaps, -250)
}

Joy8CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    
    TapCount := 0
    LastTapTime := 0
}


; L2-BUTTON
Joy9::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy9", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy9CheckTaps, -250)
}

Joy9CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    
    TapCount := 0
    LastTapTime := 0
}


; R2-BUTTON
Joy10::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy10", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy10CheckTaps, -250)
}

Joy10CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        ;EMPTY
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    
    TapCount := 0
    LastTapTime := 0
}


; ⊖-BUTTON
Joy11::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime

    startTime := A_TickCount
    while GetKeyState("Joy11", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy11CheckTaps, -250)
}

Joy11CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        SendInput("{Ctrl down}{z}{Ctrl up}")
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    
    TapCount := 0
    LastTapTime := 0
}


; ⊕︀-BUTTON
Joy12::
{
    global TapCount, LastTapTime
    currentTime := A_TickCount
    timeSinceLastTap := currentTime - LastTapTime

    if (timeSinceLastTap < 250 && TapCount = 1)
    {
        TapCount := 2
        LastTapTime := currentTime
        return
    }
    
    TapCount := 1
    LastTapTime := currentTime
    startTime := A_TickCount

    while GetKeyState("Joy12", "P")
    {
        if (A_TickCount - startTime >= 250)
        {
            ;--- Long Press ---
            ;EMPTY

            TapCount := 0
            LastTapTime := 0
            return
        }
        Sleep 20
    }
    SetTimer(Joy12CheckTaps, -250)
}

Joy12CheckTaps()
{
    global TapCount, LastTapTime
    
    if (TapCount = 1)
    {
        ;--- Single Press ---
        SendInput("{Ctrl down}{y}{Ctrl up}")
    }
    else if (TapCount = 2)
    {
        ;--- Double Press ---
        ;EMPTY
    }
    TapCount := 0
    LastTapTime := 0
}


; D-PAD
CheckPOV_C() 
{
    global prevPOV_C, prevX_C, prevY_C
    pov := GetKeyState("JoyPOV")
    x := GetKeyState("JoyX")
    y := GetKeyState("JoyY")

    ; D-PAD1
    if (pov != prevPOV_C) 
    { 
        ; ↑ BUTTON  
        if (pov = 0) 
        {
            SendInput("{Alt down}{Left}{Alt up}")  
        }


        ; → BUTTON
        else if (pov = 9000)
        {
            SendInput("{Alt down}{Up}{Alt up}")
        }


        ; ↓ BUTTON
        else if (pov = 18000)
        {
            SendInput("{Alt down}{Right}{Alt up}")
        }


        ; ← BUTTON
        else if (pov = 27000)
        {
            SendInput("{Alt down}{Enter}{Alt up}")
        }
        prevPOV_C := pov
    }


    ; D-PAD2
    if (x != prevX_C)
    {
        ; ← BUTTON
        if (x = 0)
        {
            SendInput("{Alt down}{Tab}")
        } 
        ;→ BUTTON
        else if (x = 100)
        {
            SendInput("{Alt down}{Tab}")
        }
        prevX_C := x
    }

    if (y != prevY_C)
    {
        ; ↑ BUTTON
        if (y = 0) 
        {
            SendInput("{Alt down}{Tab}")
        } 
        ; ↓ BUTTON
        else if (y = 100) 
        {
            SendInput("{Alt down}{Tab}")
        }
        prevY_C := y
    }
}
#HotIf