#Requires AutoHotkey v2.0
#SingleInstance Force

obsExe := "obs64.exe"
throttleExe := "ThrottleStop.exe"

; 1. Wait at the OS level until OBS starts - no polling (0% CPU usage)
ProcessWait(obsExe)

; Switch to profile 1 (Elgato)
SwitchThrottleStop("1")

; 2. Wait at the OS level until OBS exits - no polling (0% CPU usage)
ProcessWaitClose(obsExe)

; Revert to profile 2 (Balanced)
SwitchThrottleStop("2")

; Exit the script
ExitApp

SwitchThrottleStop(profile) {
    if !ProcessExist("ThrottleStop.exe")
        return

    key := (profile = "1") ? "1" : "2"

    ; Hold each key for 100ms (unchanged from original)
    SendInput "{Ctrl down}"
    Sleep 100
    SendInput "{Alt down}"
    Sleep 100
    SendInput "{" key " down}"
    Sleep 100
    SendInput "{" key " up}"
    Sleep 100
    SendInput "{Alt up}"
    Sleep 100
    SendInput "{Ctrl up}"
    Sleep 200
}