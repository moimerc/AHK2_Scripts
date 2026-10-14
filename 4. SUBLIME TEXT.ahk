; 4. SUBLIME TEXT
; ---------------------------------------------------------------------------
; [INDEX]
; ---------------------------------------------------------------------------
; 🟦 Sublime Text 전용 (WinActive: sublime_text.exe)
;    ├─ 연산자 삽입                       |  CapsLock + a / s / x / d / e / w
;    ├─ 괄호 자동 완성                    |  CapsLock + q / c / z
;    ├─ 수학 Hotstring                   |  ln, sin, cos, tan, asin, acos, atan,
;    │                                   |  deg, rad, pr, pi
;    ├─ 빌드 모드 토글                    |  Shift 2연타
;    ├─ 빌드 실행                         |  Shift + Enter
;    ├─ Git Log 열기                      |  Shift + CapsLock
;    └─ SHOW-COMMIT 커밋 이동             |  ← / →
;
; 🌐 전역 특수문자 (어디서나 입력 가능)
;    ├─ 그리스 문자                       |  AppsKey + a ~ w
;    └─ 위/아래 첨자                      |  AppsKey + 0 ~ 9, =, -, (, )
; ---------------------------------------------------------------------------

; --- [Sublime Text 전용 연산자/함수] ---
global st_caps_count := 0

#HotIf WinActive("ahk_exe sublime_text.exe")

; 1. CapsLock 누를 때 윈도우 기본 기능(LED 번쩍임 및 자동 반복) 완벽 차단
*CapsLock::return 

; 2. CapsLock을 뗐을 때 딱 한 번만 2연타 여부 검사
*CapsLock Up::{
    static lastTap := 0
    now := A_TickCount
    
    ; A_PriorKey로 다른 키(a, s 등)와 조합되지 않은 순수 CapsLock 단일 탭인지 확인
    if (A_PriorKey = "CapsLock") {
        if (now - lastTap < 300) {
            SetCapsLockState(!GetKeyState("CapsLock", "T"))
            lastTap := 0
        } else {
            lastTap := now
        }
    } else {
        lastTap := 0 ; 조합키로 사용되었으면 연타 카운트 강제 초기화
    }
}

; ---------------------------------------------------------------------------
; CapsLock을 물리적으로 누르고 있을 때만 작동하는 단축키
; ---------------------------------------------------------------------------
#HotIf WinActive("ahk_exe sublime_text.exe") && GetKeyState("CapsLock", "P")

*a::Send "{Blind}{Text} + "
*s::Send "{Blind}{Text} - "
*x::Send "{Blind}{Text} * "
*d::Send "{Blind}{Text} / "
*e::Send "{Blind}{Text} = "
*w::Send "{Blind}{Text} ** "

*q::
{
    Send "{Blind}{Text}()"
    Send "{Blind}{Left}"
}
*c::
{
    Send "{Blind}{Text}[]"
    Send "{Blind}{Left}"
}
*z::
{
    Send "{Blind}{Text}{}"
    Send "{Blind}{Left}"
}

; ---------------------------------------------------------------------------
; 다시 기존 조건으로 복귀 (이 아래부터는 수학 Hotstring 작동)
; ---------------------------------------------------------------------------
#HotIf WinActive("ahk_exe sublime_text.exe")

::ln::
{
    Send("math.log()")
    Send("{Left}")
}
::sin::
{
    Send("math.sin()")
    Send("{Left}")
}
::cos::
{
    Send("math.cos()")
    Send("{Left}")
}
::tan::
{
    Send("math.tan()")
    Send("{Left}")
}
::asin::
{
    Send("math.asin()")
    Send("{Left}")
}
::acos::
{
    Send("math.acos()")
    Send("{Left}")
}
::atan::
{
    Send("math.atan()")
    Send("{Left}")
}
::deg::
{
    Send("math.degrees()")
    Send("{Left}")
}
::rad::
{
    Send("math.radians()")
    Send("{Left}")
}
::pr::
{
    Send("print(f`"`"{Left 1} = {{}{}}{Left 5}")
}
::pi::
{
    Send("math.pi")
}


; --- 빌드 모드 (1 = Python_Anaconda, 2 = Java_Run) ---
global st_build_mode := 1

; Shift 두 번 연타(Up 기준) → 모드 토글
~LShift Up::
~RShift Up::
{
    static last_up_time := 0
    static last_toggle_time := 0

    now := A_TickCount

    ; 토글 후 400ms 동안은 무시 (연속 오작동 방지)
    if (now - last_toggle_time < 400)
        return

    ; 280ms 이내에 Shift를 두 번 뗐고, 직전에 눌렀던 키도 Shift일 때만 토글
    if (now - last_up_time < 280 && InStr(A_PriorKey, "Shift"))
    {
        global st_build_mode
        st_build_mode := (st_build_mode = 1) ? 2 : 1

        mode_name := (st_build_mode = 1) ? "Python_Anaconda" : "Java_Run"
        ToolTip "Build Mode → " mode_name
        SetTimer(() => ToolTip(), -1300)

        last_toggle_time := now
        last_up_time := 0          ; 3연타 방지
    }
    else
    {
        last_up_time := now
    }
}


; Shift + Enter → 현재 모드로 빌드
+Enter::
{
    global st_build_mode

    if (st_build_mode = 1)
        SendInput "^+1"      ; Python_Anaconda
    else
        SendInput "^+2"      ; Java_Run
}

; Shift + CapsLock → Git Log 열기 (gs_log)
+CapsLock::
{
    SendInput "^+3"          ; Ctrl + Alt + 3
}

#HotIf

; SHOW-COMMIT 창에서 좌우 방향키로 이전/다음 커밋 이동 (p / n 대체)
#HotIf WinActive("SHOW-COMMIT ahk_exe sublime_text.exe")

Left::SendInput("p")
Right::SendInput("n")

#HotIf ; 조건 해제 (이 아래부터는 다시 전역 설정으로 복귀)


; ---------------------------------------------------------------
; 🌐 [전역 특수문자 / 그리스 문자 / 위아래 첨자] (어디서나 입력 가능)
; ---------------------------------------------------------------

; --- [그리스 문자] ---
AppsKey & a:: Send(GetKeyState("Shift", "P") ? "{U+0391}" : "{U+03B1}") ; α Α
AppsKey & b:: Send(GetKeyState("Shift", "P") ? "{U+0392}" : "{U+03B2}") ; β Β
AppsKey & g:: Send(GetKeyState("Shift", "P") ? "{U+0393}" : "{U+03B3}") ; γ Γ
AppsKey & d:: Send(GetKeyState("Shift", "P") ? "{U+0394}" : "{U+03B4}") ; δ Δ
AppsKey & e:: Send(GetKeyState("Shift", "P") ? "{U+0395}" : "{U+03B5}") ; ε Ε
AppsKey & z:: Send(GetKeyState("Shift", "P") ? "{U+0396}" : "{U+03B6}") ; ζ Ζ
AppsKey & h:: Send(GetKeyState("Shift", "P") ? "{U+0397}" : "{U+03B7}") ; η Η
AppsKey & c:: Send(GetKeyState("Shift", "P") ? "{U+0398}" : "{U+03B8}") ; θ Θ
AppsKey & i:: Send(GetKeyState("Shift", "P") ? "{U+0399}" : "{U+03B9}") ; ι Ι
AppsKey & k:: Send(GetKeyState("Shift", "P") ? "{U+039A}" : "{U+03BA}") ; κ Κ
AppsKey & l:: Send(GetKeyState("Shift", "P") ? "{U+039B}" : "{U+03BB}") ; λ Λ
AppsKey & m:: Send(GetKeyState("Shift", "P") ? "{U+039C}" : "{U+03BC}") ; μ Μ
AppsKey & n:: Send(GetKeyState("Shift", "P") ? "{U+039D}" : "{U+03BD}") ; ν Ν
AppsKey & q:: Send(GetKeyState("Shift", "P") ? "{U+039E}" : "{U+03BE}") ; ξ Ξ
AppsKey & o:: Send(GetKeyState("Shift", "P") ? "{U+039F}" : "{U+03BF}") ; ο Ο
AppsKey & p:: Send(GetKeyState("Shift", "P") ? "{U+03A0}" : "{U+03C0}") ; π Π
AppsKey & r:: Send(GetKeyState("Shift", "P") ? "{U+03A1}" : "{U+03C1}") ; ρ Ρ
AppsKey & s:: Send(GetKeyState("Shift", "P") ? "{U+03A3}" : "{U+03C3}") ; σ Σ
AppsKey & t:: Send(GetKeyState("Shift", "P") ? "{U+03A4}" : "{U+03C4}") ; τ Τ
AppsKey & u:: Send(GetKeyState("Shift", "P") ? "{U+03A5}" : "{U+03C5}") ; υ Υ
AppsKey & y:: Send(GetKeyState("Shift", "P") ? "{U+03A5}" : "{U+03C5}") ; υ Υ
AppsKey & f:: Send(GetKeyState("Shift", "P") ? "{U+03A6}" : "{U+03C6}") ; φ Φ
AppsKey & x:: Send(GetKeyState("Shift", "P") ? "{U+03A7}" : "{U+03C7}") ; χ Χ
AppsKey & v:: Send(GetKeyState("Shift", "P") ? "{U+03A8}" : "{U+03C8}") ; ψ Ψ
AppsKey & w:: Send(GetKeyState("Shift", "P") ? "{U+03A9}" : "{U+03C9}") ; ω Ω

; --- [위/아래 첨자] ---
AppsKey & 1:: Send(GetKeyState("Shift", "P") ? "{U+00B9}" : "{U+2081}") ; ₁ ¹
AppsKey & 2:: Send(GetKeyState("Shift", "P") ? "{U+00B2}" : "{U+2082}") ; ₂ ²
AppsKey & 3:: Send(GetKeyState("Shift", "P") ? "{U+00B3}" : "{U+2083}") ; ₃ ³
AppsKey & 4:: Send(GetKeyState("Shift", "P") ? "{U+2074}" : "{U+2084}") ; ₄ ⁴
AppsKey & 5:: Send(GetKeyState("Shift", "P") ? "{U+2075}" : "{U+2085}") ; ₅ ⁵
AppsKey & 6:: Send(GetKeyState("Shift", "P") ? "{U+2076}" : "{U+2086}") ; ₆ ⁶
AppsKey & 7:: Send(GetKeyState("Shift", "P") ? "{U+2077}" : "{U+2087}") ; ₇ ⁷
AppsKey & 8:: Send(GetKeyState("Shift", "P") ? "{U+2078}" : "{U+2088}") ; ₈ ⁸
AppsKey & 9:: Send(GetKeyState("Shift", "P") ? "{U+2079}" : "{U+2089}") ; ₉ ⁹
AppsKey & 0:: Send(GetKeyState("Shift", "P") ? "{U+2070}" : "{U+2080}") ; ₀ ⁰
AppsKey & =:: Send(GetKeyState("Shift", "P") ? "{U+207A}" : "{U+208A}") ; ₊ ⁺
AppsKey & -:: Send(GetKeyState("Shift", "P") ? "{U+207B}" : "{U+208B}") ; ₋ ⁻
AppsKey & (:: Send(GetKeyState("Shift", "P") ? "{U+207D}" : "{U+208D}") ; ₍ ⁽
AppsKey & ):: Send(GetKeyState("Shift", "P") ? "{U+207E}" : "{U+208E}") ; ₎ ⁾