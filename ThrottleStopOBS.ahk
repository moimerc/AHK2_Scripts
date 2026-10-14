#Requires AutoHotkey v2.0
#SingleInstance Force

obsExe := "obs64.exe"
throttleExe := "ThrottleStop.exe"

; 1. 폴링 없이 OBS가 실행될 때까지 OS 단에서 대기 (CPU 점유율 0%)
ProcessWait(obsExe)

; 프로필 1 (Elgato)로 전환
SwitchThrottleStop("1")

; 2. 폴링 없이 OBS가 종료될 때까지 OS 단에서 대기 (CPU 점유율 0%)
ProcessWaitClose(obsExe)

; 프로필 2 (Balanced)로 복귀
SwitchThrottleStop("2")

; 스크립트 종료
ExitApp

SwitchThrottleStop(profile) {
    if !ProcessExist("ThrottleStop.exe")
        return

    key := (profile = "1") ? "1" : "2"

    ; 각 키를 100ms씩 유지 (기존 코드 유지)
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