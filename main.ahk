#Requires AutoHotkey v2.0
DetectHiddenWindows true
InstallKeybdHook()  ; AHK가 키보드 물리적 상태를 더 강하게 추적하도록 강제
A_HotkeyModifierTimeout := 100  ; 모디파이어 키 복원 대기 시간을 50ms에서 100ms로 늘려 꼬임 방지

; ─────────────────────────────────────────────────────────────────────────
; EveryHangul 기능을 사용하려면 아래 두 가지를 진행하세요:
;   1. EveryHangul.ahk 파일을 이 스크립트(main.ahk)와 같은 폴더에 다운로드
;      (https://github.com/devPnal/every-hangul-v2)
;   2. 아래 #Include 줄과 1. SYSTEM SHELL.ahk의 global hangul, ~LAlt & RAlt:: 주석을 모두 해제
; ─────────────────────────────────────────────────────────────────────────

; #Include EveryHangul.ahk
#Include 1. SYSTEM SHELL.ahk
#Include 2. SURFACE PEN.ahk
#Include 3. APPLICATIONS.ahk
#Include 4. SUBLIME TEXT.ahk
#Include 5. GAMEPAD.ahk
#Include 6. CLIP STUDIO.ahk


/*

Auto Hot Key V2

! = Alt
^ = Ctrl
+ = Shift
# = Windows

GAMEPAD
; Android: X + HOME
; Switch: Y + HOME
; Xbox: B + HOME
; Keyboard: A + HOME

; LED + L = LED SC
; LED + A = LED Breathing SC
; LED + B = LED Cycle SC  
; LED + AA = LED Breathing MC
; LED + BB = LED Cycle MC
; LED + X = LED Flow
; LED + Y = LED Double Cycle
; LEDLED = ON/OFF LED

; LED + ⊕︀ = L1/R1 ⇌ L2/R2
; LED + ⊖ = D-PAD1 ⇌ D-PAD2

*/