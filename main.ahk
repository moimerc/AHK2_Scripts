#Requires AutoHotkey v2.0
DetectHiddenWindows true
InstallKeybdHook()  ; Force AHK to more strongly track the physical keyboard state
A_HotkeyModifierTimeout := 100  ; Increase modifier restore delay from 50ms to 100ms to prevent stuck keys

; ─────────────────────────────────────────────────────────────────────────
; To use the EveryHangul feature, do the following:
;   1. Download EveryHangul.ahk and place it in the same folder as this script (main.ahk)
;      (https://github.com/devPnal/every-hangul-v2)
;   2. Uncomment the #Include line below, plus the global hangul and ~LAlt & RAlt:: lines in 1. SYSTEM SHELL.ahk
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