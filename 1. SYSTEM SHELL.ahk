; 1. SYSTEM SHELL
; ---------------------------------------------------------------------------
; [INDEX]
; ---------------------------------------------------------------------------
; ⬜ 전역 기본 단축키
;    ├─ 파일 이름 변경 (F2)             |  Ctrl + R
;    ├─ 다시 실행 (Redo)                |  Ctrl + Shift + Z
;    └─ 캡처 도구 (ms-screenclip)       |  PrtScn
;
; 🟦 한/영 오타 양방향 즉시 교정        |  LAlt + RAlt
; 🟪 괄호 및 루비 텍스트 제거 (전체선택) |  LCtrl + AppsKey
; 🟧 긴급 키 고정 해제 및 탐색기 재시작  |  Shift + Esc
;
; 🔲 공통 레이아웃 판별 함수            |  IsJapaneseLayout, IsKoreanLayout 등
;
; 🟥 일본어 레이아웃 전용 핫키
;    ├─ 일/영 전환                      |  AppsKey + RAlt
;    ├─ 히라가나 전환                   |  RAlt
;    └─ 카타카나 전환                   |  AppsKey
;
; 🟩 한국어 레이아웃 전용 핫키
;    ├─ 한/영 전환                      |  RAlt
;    └─ 한자 입력                       |  AppsKey
;
; 🟨 터미널 & CMD 전용 단축키
;    ├─ 탭 이전/다음 이동               |  Ctrl + Left / Right
;    ├─ 파이썬 & 자바 코드 빌드         |  CapsLock 연타 (+ ExecuteCapsAction)
;    └─ Conda Venv 활성화              |  Ctrl + Alt + LWin
;
; ⬛ 브라우저 전용 단축키
;    └─ 탭 이전/다음 이동               |  Ctrl + Left / Right
;
; 🟫 윈도우 탐색기 전용 단축키 (RClone 스태시 엔진)
;    ├─ 스태시 파일명 복사              |  CapsLock 1회
;    ├─ 스태시 경로 저장 & RClone 실행  |  CapsLock 2회
;    └─ 내부 함수                      |  ExecuteExplorerCapsAction
;
; ⏰ 절전 방지 타이머 (Caffeine 대체)  |  Alt + Space
;    ├─ 입력 있음   : 지정 시간 후 자동 해제
;    ├─ 빈 값 / 0   : 무기한 활성 (Override: active)
;    └─ 트레이 툴팁 : 60초마다 갱신
;
; 🟣 음소거 & Auto-Mute 제어
;    ├─ 네이티브 음소거 & Auto-Mute 토글 |  Volume_Mute
;    └─ 장치 변경 감지 (Auto-Mute 부속)  |  CheckAudioDeviceChange (내부)
;
; 🟢 WiFi 토글 (Volume Up)              |  Volume_Up
; 🔵 Bluetooth 토글 (Volume Down)       |  Volume_Down
; ---------------------------------------------------------------------------
;
SetKeyDelay(40, 40)

; --- [전역 변수 및 객체 초기화] ---
; EveryHangul 기능을 사용하려면 아래 두 가지를 진행하세요:
;   1. EveryHangul.ahk 파일을 main.ahk와 같은 폴더에 다운로드
;   2. 아래 주석을 해제 (main.ahk의 #Include EveryHangul.ahk도 함께 해제)
; global hangul := EveryHangul()
global caps_count := 0
global explorer_caps_count := 0
global CompareQueue := []
global WorkDir := "C:\Path\To\Your\Workspace"  ; <-- 본인의 워크스페이스 경로로 수정하세요

; ---------------------------------------------------------------------------
; ⬜ 전역 기본 단축키
; ---------------------------------------------------------------------------

; Ctrl + R → F2 (Rename)
^r::Send("{F2}")

; Ctrl + Shift + Z → Ctrl + Y (Redo)
^+z::Send("^y")

; PrtScn 누르면 캡처 도구 프로토콜 직접 실행
$PrintScreen::
{
    Run("ms-screenclip:")
}


; ---------------------------------------------------------------------------
; 🟦 한/영 오타 양방향 교정 (LAlt -> RAlt 순서 필수)
;    ※ 사용하려면 main.ahk 및 상단의 EveryHangul 관련 주석을 해제하세요.
; ---------------------------------------------------------------------------
/*
~LAlt & RAlt::
{
    ; 1. 물리적 키 해제 대기 (Alt 고정 원천 차단)
    KeyWait "LAlt"
    KeyWait "RAlt"
    Sleep(15)

    ; 2. 클립보드 백업 (텍스트만 → 매우 빠름)
    savedClipboard := A_Clipboard
    A_Clipboard := ""

    ; 3. 현재 선택 영역 확인
    SendInput("^c")
    ClipWait(0.03)

    ; 4. 선택 없음 OR 라인 카피(Sublime 등) → 단어 선택 폴백
    if (A_Clipboard = "" || InStr(A_Clipboard, "`n")) {
        A_Clipboard := ""
        SendInput("^+{Left}^c")
        if !ClipWait(0.08) {
            A_Clipboard := savedClipboard
            return
        }
    }

    original := A_Clipboard

    try {
        ; 5. 방향 자동 감지
        if (RegExMatch(original, "[가-힣ㄱ-ㅎㅏ-ㅣ]"))
            converted := hangul.EngKey(original)
        else
            converted := hangul.KorKey(original)

        ; 6. IME를 먼저 원하는 상태로 (붙여넣기 후 재변환 방지)
        SendInput("{vk15}")
        Sleep(15)

        ; 7. 선택 영역 삭제 후 텍스트 입력
        SendInput("{BackSpace}")
        Sleep(5)
        SendText(converted)
    }

    ; 8. 클립보드 복구
    Sleep(10)
    A_Clipboard := savedClipboard
}
*/


; ---------------------------------------------------------------------------
; 🟪 괄호 및 루비 텍스트 즉시 제거 (텍스트 전체선택)
; ---------------------------------------------------------------------------

~LCtrl & AppsKey::
{
    ; 1. 기존 클립보드 백업
    savedClipboard := ClipboardAll()
    A_Clipboard := ""

    ; 2. 선택된 텍스트 복사
    Send("^c")
    if !ClipWait(0.2) {
        A_Clipboard := savedClipboard
        return
    }

    original := A_Clipboard

    ; 3. 괄호와 그 안의 텍스트 제거
    converted := RegExReplace(original, "[(（][^)）]*[)）]", "")

    ; 4. 변환된 텍스트로 선택 영역 대체
    A_Clipboard := converted
    Send("^v")

    ; 5. 기존 클립보드 복구
    Sleep(50)
    A_Clipboard := savedClipboard
}


; ---------------------------------------------------------------------------
; 🟧 긴급 키 고정 해제 및 탐색기 재시작 (전역)
; ---------------------------------------------------------------------------

; * (와일드카드)를 붙여서 다른 키가 고정(Stuck)된 상태라도 무조건 작동하도록 강제함
*+Esc::
{
    ; 1. 사용자가 물리적으로 Ctrl 키를 같이 눌렀다면 작업 관리자를 직접 실행하고 종료
    if GetKeyState("Ctrl", "P")
    {
        Run("taskmgr.exe")
        return
    }

    ; 2. 그 외의 경우 (순수하게 Shift + Esc만 눌렀거나 Alt 등이 꼬였을 때) 강제 해제 진행
    Send "{Blind}{LControl Up}{RControl Up}{LAlt Up}{RAlt Up}{LWin Up}{RWin Up}{Shift Up}"
    SetCapsLockState("Off")
    RunWait("taskkill /f /im explorer.exe", , "Hide")
    Run("explorer.exe")
    MsgBox "모든 키 고정을 해제하고 탐색기(explorer.exe)를 재시작했습니다."
}


; ---------------------------------------------------------------------------
; 🔲 공통 레이아웃 함수
; ---------------------------------------------------------------------------

IsJapaneseLayout() {
    langId := GetInputLangID()
    Return (langId = "0x411") ; 일본어
}

IsKoreanLayout() {
    langId := GetInputLangID()
    Return (langId = "0x412") ; 한국어
}


GetInputLangID(hWnd := "") {
    if (!hWnd) {
        ; 1. 단순히 활성 창이 아니라, 현재 키보드 포커스가 있는 실제 창(컨트롤)을 찾음
        hWnd := WinActive("A")
        
        ; UWP 앱인 경우, 더 깊숙한 곳의 포커스 핸들을 가져와야 즉시 갱신됨
        if WinGetProcessName(hWnd) = "ApplicationFrameHost.exe" {
            static stGTI := Buffer(24 + 6 * A_PtrSize, 0)
            NumPut("UInt", stGTI.Size, stGTI)
            ; GetGUIThreadInfo를 통해 현재 스레드의 실제 포커스 핸들을 획득
            if DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", stGTI) {
                hwndFocus := NumGet(stGTI, 8 + A_PtrSize, "Ptr")
                if hwndFocus
                    hWnd := hwndFocus
            }
        }
    }

    ; 2. IME 핸들 가져오기 (가장 정확한 레이아웃 판별법)
    imeHwnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hWnd, "Ptr")
    
    ; IME 핸들이 있으면 해당 핸들의 스레드에서 레이아웃 추출
    targetHwnd := imeHwnd ? imeHwnd : hWnd
    threadId := DllCall('GetWindowThreadProcessId', 'Ptr', targetHwnd, 'UInt', 0)
    lyt := DllCall('GetKeyboardLayout', 'Ptr', threadId, 'UInt')
    
    return Format("{:#x}", lyt & 0x3FFF)
}


; ---------------------------------------------------------------------------
; 🟥 일본어 레이아웃 전용 핫키
; ---------------------------------------------------------------------------

#HotIf IsJapaneseLayout()

; AppsKey + RAlt → Alt + ` (일/영 전환)
AppsKey & RAlt::SendEvent("!{vkC0}")

; RAlt → Ctrl + Caps (히라가나 전환)
*RAlt::
{
    SendEvent("^{CapsLock}")
}

; AppsKey → Alt + Caps (카타카나 전환)
*AppsKey::
{
    SendEvent("!{CapsLock}")
}

#HotIf  ; 조건 초기화


; ---------------------------------------------------------------------------
; 🟩 한국어 레이아웃 전용 핫키
; ---------------------------------------------------------------------------

#HotIf IsKoreanLayout()

; RAlt → Shift + Space (한/영 전환)
*RAlt::
{
    SendEvent("{vk15}")
}

; AppsKey → Ctrl + Space (한자 입력)
*AppsKey::
{
    SendEvent("{vk19}")
}

#HotIf  ; 조건 초기화


; ---------------------------------------------------------------------------
; 🟨 터미널 & CMD 전용 단축키
; ---------------------------------------------------------------------------

#HotIf WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe cmd.exe")

; Alt + 좌/우 방향키 → 이전 탭 / 다음 탭으로 이동
^Left::Send("^+{Tab}")
^Right::Send("^{Tab}")

; CapsLock 연타 (1: python, 2: java, 3: javac)
CapsLock::
{
    global caps_count
    caps_count++
    SetTimer(ExecuteCapsAction, -180)
}

; Ctrl + Alt + Win → Activate venv
^!LWin::Send("conda activate whisper_env")

#HotIf


; ---------------------------------------------------------------------------
; 🟨 ExecuteCapsAction (터미널 CapsLock 연타 전용 함수)
; ---------------------------------------------------------------------------
ExecuteCapsAction()
{
    global caps_count
    
    if (caps_count == 1)      ; 1번 툭
    {
        SendText "python .py"
        Send "{Left 3}"
    }
    else if (caps_count == 2) ; 2번 연타
    {
        SendText "java "
    }
    else if (caps_count >= 3) ; 3번 이상 연타
    {
        SendText "javac .java"
        Send "{Left 5}"
    }
    
    caps_count := 0 ; 카운트 초기화
}


; ---------------------------------------------------------------------------
; ⬛ 브라우저 전용 단축키
; ---------------------------------------------------------------------------

#HotIf WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("Edge ahk_exe ApplicationFrameHost.exe")

; Ctrl + 좌/우 방향키 → 이전 탭 / 다음 탭으로 이동
^Left::Send("^+{Tab}")
^Right::Send("^{Tab}")

#HotIf


; ---------------------------------------------------------------------------
; 🟫 윈도우 탐색기 전용 단축키 (RClone 스태시 엔진)
; ---------------------------------------------------------------------------

#HotIf WinActive("ahk_exe explorer.exe")

; CapsLock 1번(스태시 비우기 및 파일명 복사) / 2번(경로 스태시 및 RClone 실행)
CapsLock::
{
    global explorer_caps_count
    explorer_caps_count++
    SetTimer(ExecuteExplorerCapsAction, -180)
}

#HotIf


; ---------------------------------------------------------------------------
; 🟫 ExecuteExplorerCapsAction (탐색기 CapsLock 연타 전용 함수)
; ---------------------------------------------------------------------------
ExecuteExplorerCapsAction()
{
    global explorer_caps_count, CompareQueue, WorkDir

    if (explorer_caps_count == 1)
    {
        ; 1번 연타: 큐(스태시) 초기화 후 확장자 제외 파일명 복사
        CompareQueue := []

        oldClip := ClipboardAll()
        A_Clipboard := ""
        Send "^c" 

        if ClipWait(0.3)
        {
            targetPath := StrSplit(A_Clipboard, "`n", "`r")[1]
            SplitPath targetPath, , , , &nameNoExt
            A_Clipboard := nameNoExt
            
            ToolTip "복사 완료: " nameNoExt
            SetTimer () => ToolTip(), -1200
        }
        else
        {
            A_Clipboard := oldClip
        }
        oldClip := ""
    }
    else if (explorer_caps_count >= 2)
    {
        ; 2번 연타: 경로 복사 후 CompareQueue 추가
        oldClip := ClipboardAll()
        A_Clipboard := ""
        Send "^c"

        if ClipWait(0.3)
        {
            ; 클립보드 문자열 추출 및 쌍따옴표 제거
            targetPath := StrSplit(A_Clipboard, "`n", "`r")[1]
            targetPath := StrReplace(targetPath, '"', "")
            
            ; 쌍따옴표가 제거된 순수 경로를 클립보드에 다시 덮어쓰기
            A_Clipboard := targetPath
            
            CompareQueue.Push(targetPath)

            if (CompareQueue.Length == 1)
            {
                ToolTip "경로 1 저장 완료: " targetPath
                SetTimer () => ToolTip(), -1500
            }
            else if (CompareQueue.Length == 2)
            {
                path1 := CompareQueue[1]
                path2 := CompareQueue[2]
                CompareQueue := []

                ; 폴더/파일 속성 정밀 감별
                isDir1 := DirExist(path1) != ""
                isDir2 := DirExist(path2) != ""

                cmdStr := ""

                if (isDir1 && isDir2)
                {
                    ; [Case 1] 둘 다 폴더
                    cmdStr := 'rclone check "' path1 '" "' path2 '" -P -v'
                }
                else if (!isDir1 && !isDir2)
                {
                    ; [Case 2] 둘 다 파일
                    SplitPath path1, &file1, &dir1
                    SplitPath path2, &file2, &dir2

                    if (file1 == file2)
                    {
                        cmdStr := 'rclone check "' dir1 '" "' dir2 '" --include "/' file1 '" -P -v'
                    }
                    else
                    {
                        ; 이름/확장자가 다르면 실행 안 함
                        ToolTip "이름이나 확장자가 다른 파일은 비교할 수 없습니다."
                        SetTimer () => ToolTip(), -2000
                        return
                    }
                }
                else
                {
                    ; [Case 3] 파일 vs 폴더
                    if (!isDir1)
                    {
                        SplitPath path1, &file1, &dir1
                        cmdStr := 'rclone check "' dir1 '" "' path2 '" --include "/' file1 '" -P -v'
                    }
                    else
                    {
                        SplitPath path2, &file2, &dir2
                        cmdStr := 'rclone check "' path1 '" "' dir2 '" --include "/' file2 '" -P -v'
                    }
                }

                ToolTip "경로 2 저장 완료! 비교를 시작합니다."
                SetTimer () => ToolTip(), -1500

                ; 창 제목 고정 + 프롬프트 고정 + 명령어 에코(출력) 후 실행
                Run(A_ComSpec ' /k "(title Command Prompt) & prompt WORKSPACE$G & echo WORKSPACE^>' cmdStr ' & ' cmdStr '"', WorkDir)
            }
        }
        else
        {
            A_Clipboard := oldClip
        }
        oldClip := ""
    }

    explorer_caps_count := 0
}


; ---------------------------------------------------------------------------
; ⏰ 절전 방지 타이머 (Caffeine 대체)  |  Alt + Space
; ---------------------------------------------------------------------------
global KeepAwakeActive   := false
global KeepAwakeInfinite := false
global KeepAwakeEndTime  := 0

global SIM_INTERVAL_MS        := 270000   ; 270초 (Sleep 300초 대비 30초 마진)
global USER_IDLE_THRESHOLD_MS := 240000   ; 4분 (Windows 화면 끄기와 맞춤)

A_IconTip := "Override: inactive"

!Space::
{
    global KeepAwakeActive, KeepAwakeInfinite, KeepAwakeEndTime

    if (KeepAwakeActive)
    {
        if (KeepAwakeInfinite)
            status := "현재 상태: 무기한 활성 (Override: active)"
        else
            status := "남은 시간: " FormatRemaining(KeepAwakeEndTime - A_TickCount)

        text := "절전 방지 모드가 활성화되어 있습니다.`n`n"
              . status "`n`n"
              . "계속 유지할까요, 아니면 종료할까요?"

        if ShowConfirmDialog("절전 방지 상태", text)
            StopKeepAwake()
        return
    }

    ib := InputBox(
        "절전 방지 유지 시간을 '시간' 단위로 입력하세요.`n"
        "(예: 1.5 = 1시간 30분, 0.25 = 15분)`n`n"
        "비워두거나 0을 입력하면 무기한 활성화됩니다.",
        "절전 방지 타이머",
        "w360 h150"
    )

    if (ib.Result = "Cancel")
        return

    val := Trim(ib.Value)

    if (val = "" || (IsNumber(val) && Float(val) = 0))
    {
        KeepAwakeActive   := true
        KeepAwakeInfinite := true
        KeepAwakeEndTime  := 0

        DllCall("kernel32.dll\SetThreadExecutionState", "UInt", 0x80000001)

        SetTimer(SimulateActivity, -SIM_INTERVAL_MS)
        UpdateTrayTip()

        ToolTip("절전 방지: 무기한 활성화`n(화면은 정상적으로 꺼집니다)")
        SetTimer(() => ToolTip(), -3000)
        return
    }

    if (!IsNumber(val) || Float(val) < 0)
    {
        ToolTip("0보다 큰 숫자를 입력해주세요.")
        SetTimer(() => ToolTip(), -2000)
        return
    }

    hours := Float(val)
    ms    := Round(hours * 3600000)

    KeepAwakeActive   := true
    KeepAwakeInfinite := false
    KeepAwakeEndTime  := A_TickCount + ms

    DllCall("kernel32.dll\SetThreadExecutionState", "UInt", 0x80000001)

    SetTimer(SimulateActivity, -SIM_INTERVAL_MS)
    SetTimer(StopKeepAwake, -ms)
    SetTimer(UpdateTrayTip, 60000)
    UpdateTrayTip()

    ToolTip("절전 방지 시작: " FormatHours(hours) "`n(화면은 정상적으로 꺼집니다)")
    SetTimer(() => ToolTip(), -3000)
}

; ─────────────────────────────────────────────────────────────────────────
; F16 시뮬레이션 + 조건부 화면 끄기
; ─────────────────────────────────────────────────────────────────────────
SimulateActivity()
{
    global KeepAwakeActive, SIM_INTERVAL_MS, USER_IDLE_THRESHOLD_MS

    if (!KeepAwakeActive)
        return

    SendInput("{F16}")

    ; 자리 비움 판정
    if (A_TimeIdlePhysical > USER_IDLE_THRESHOLD_MS)
    {
        ; ★ 오디오 재생 중이면 사용자가 미디어 시청 중으로 판단 → 화면 유지
        if (IsAudioPlaying())
        {
            SetTimer(SimulateActivity, -SIM_INTERVAL_MS)
            return
        }

        Sleep(50)
        SendMessage(0x0112, 0xF170, 2, , "Program Manager")   ; 화면 강제 끄기
    }

    SetTimer(SimulateActivity, -SIM_INTERVAL_MS)
}

; ─────────────────────────────────────────────────────────────────────────
; 오디오 재생 여부 감지 (IAudioMeterInformation::GetPeakValue)
;   - 기본 출력 장치의 피크 레벨이 0보다 크면 오디오 재생 중
;   - 잠금 화면 상태에서도 감지 가능
; ─────────────────────────────────────────────────────────────────────────
IsAudioPlaying()
{
    static IID_IAudioMeterInformation := "{C02216F6-8C67-4B5B-9D00-D008E73E0064}"
    try {
        meter := SoundGetInterface(IID_IAudioMeterInformation)
        if (!meter)
            return false

        peak := 0.0
        ComCall(3, meter, "Float*", &peak)   ; GetPeakValue (vtable index 3)
        ObjRelease(meter)

        return peak > 0.001
    } catch {
        return false
    }
}

; ─────────────────────────────────────────────────────────────────────────
; 절전 방지 종료
; ─────────────────────────────────────────────────────────────────────────
StopKeepAwake()
{
    global KeepAwakeActive, KeepAwakeInfinite, KeepAwakeEndTime

    if (!KeepAwakeActive)
        return

    SetTimer(SimulateActivity, 0)
    SetTimer(StopKeepAwake, 0)
    SetTimer(UpdateTrayTip, 0)

    DllCall("kernel32.dll\SetThreadExecutionState", "UInt", 0x80000000)

    KeepAwakeActive   := false
    KeepAwakeInfinite := false
    KeepAwakeEndTime  := 0

    A_IconTip := "Override: inactive"

    ToolTip("절전 방지가 종료되었습니다.`nPC가 정상적으로 절전 모드에 들어갈 수 있습니다.")
    SetTimer(() => ToolTip(), -3000)
}

; ─────────────────────────────────────────────────────────────────────────
; 트레이 툴팁 갱신
; ─────────────────────────────────────────────────────────────────────────
UpdateTrayTip()
{
    global KeepAwakeActive, KeepAwakeInfinite, KeepAwakeEndTime

    if (!KeepAwakeActive)
        return

    if (KeepAwakeInfinite)
    {
        A_IconTip := "Override: active"
        return
    }

    remaining := KeepAwakeEndTime - A_TickCount
    if (remaining < 0)
        remaining := 0

    remainMin := Ceil(remaining / 60000)
    A_IconTip := "Will go inactive in " remainMin " minute(s)"
}

; ─────────────────────────────────────────────────────────────────────────
; 시간 포맷 헬퍼
; ─────────────────────────────────────────────────────────────────────────
FormatRemaining(ms)
{
    totalSec := Floor(ms / 1000)
    h := Floor(totalSec / 3600)
    m := Floor(Mod(totalSec, 3600) / 60)
    s := Mod(totalSec, 60)

    if (h > 0)
        return h "시간 " m "분"
    if (m > 0)
        return m "분 " s "초"
    return s "초"
}

FormatHours(hours)
{
    totalMin := Round(hours * 60)
    h := Floor(totalMin / 60)
    m := Mod(totalMin, 60)

    if (h > 0 && m > 0)
        return h "시간 " m "분"
    if (h > 0)
        return h "시간"
    return m "분"
}

; ─────────────────────────────────────────────────────────────────────────
; 커스텀 확인 다이얼로그
; ─────────────────────────────────────────────────────────────────────────
ShowConfirmDialog(title, text)
{
    dlg := Gui("+AlwaysOnTop +ToolWindow -MinimizeBox", title)
    dlg.SetFont("s10", "Malgun Gothic")
    dlg.MarginX := 20
    dlg.MarginY := 15

    dlg.AddText("w340", text)
    dlg.ConfirmResult := false

    dlg.AddButton("w120 h32 Default", "유지").OnEvent("Click", (*) => dlg.Destroy())
    dlg.AddButton("x+20 w120 h32", "종료").OnEvent("Click", ExitConfirm.Bind(dlg))

    dlg.Show("AutoSize Center")
    WinWaitClose("ahk_id " dlg.Hwnd)

    return dlg.ConfirmResult
}

ExitConfirm(dlg, *)
{
    dlg.ConfirmResult := true
    dlg.Destroy()
}


; ---------------------------------------------------------------------------
; 🟣 음소거 & Auto-Mute 제어
; ---------------------------------------------------------------------------
global prevAudioDevice := ""
global autoMuteEnabled := false     ; Auto-Mute 기능 ON/OFF (기본 OFF)

; 스크립트 시작 시 현재 기본 오디오 장치 이름 저장
try {
    prevAudioDevice := SoundGetName()
}


; ---------------------------------------------------------------------------
; 🟣 Volume_Mute: 네이티브 음소거 + Auto-Mute 토글 (동시)
; ---------------------------------------------------------------------------
~Volume_Mute::
{
    global autoMuteEnabled

    autoMuteEnabled := !autoMuteEnabled

    if (autoMuteEnabled)
    {
        SetTimer(CheckAudioDeviceChange, 500)
        ToolTip("Auto-Mute : ON")
    }
    else
    {
        SetTimer(CheckAudioDeviceChange, 0)
        ToolTip("Auto-Mute : OFF")
    }
    SetTimer(() => ToolTip(), -1500)
}


; ---------------------------------------------------------------------------
; 🟣 CheckAudioDeviceChange (Auto-Mute 부속 함수 - 장치 변경 감지)
; ---------------------------------------------------------------------------
CheckAudioDeviceChange()
{
    global prevAudioDevice
    try
    {
        currentAudioDevice := SoundGetName()

        ; 오디오 장치가 바뀌면 무조건 즉시 음소거
        if (prevAudioDevice != "" && currentAudioDevice != prevAudioDevice)
        {
            SoundSetMute(1)
        }

        prevAudioDevice := currentAudioDevice
    }
}


; ---------------------------------------------------------------------------
; 🟢 WiFi 토글 (Volume Up)
; ---------------------------------------------------------------------------
global radioBusyWiFi := false

$Volume_Up::ToggleRadio("WiFi")


; ---------------------------------------------------------------------------
; 🔵 Bluetooth 토글 (Volume Down)
; ---------------------------------------------------------------------------
global radioBusyBluetooth := false

$Volume_Down::ToggleRadio("Bluetooth")


; ---------------------------------------------------------------------------
; 🟢🔵 ToggleRadio (WiFi / Bluetooth 토글 전용 공용 함수)
; ---------------------------------------------------------------------------
ToggleRadio(radioType) {
    global radioBusyWiFi, radioBusyBluetooth

    ; ── busy 확인 + 즉시 잠금 ──
    if (radioType = "WiFi") {
        if (radioBusyWiFi)
            return
        radioBusyWiFi := true
    } else if (radioType = "Bluetooth") {
        if (radioBusyBluetooth)
            return
        radioBusyBluetooth := true
    } else {
        return
    }

    ; ★ 하드코딩된 경로 대신 A_ScriptDir 사용 (RadioToggle.ps1과 같은 폴더 기준)
    signalPath := A_ScriptDir "\RadioToggle.signal"
    resultPath := A_ScriptDir "\RadioToggle.result"
    psPath     := A_ScriptDir "\RadioToggle.ps1"

    if FileExist(signalPath)
        FileDelete(signalPath)
    if FileExist(resultPath)
        FileDelete(resultPath)

    ; ── PS 비동기 실행 ──
    Run(
        'powershell.exe -Mta -WindowStyle Hidden -NoProfile '
        '-ExecutionPolicy Bypass -File "' psPath '" '
        '-RadioType ' radioType,
        , "Hide", &pid
    )

    startTime := A_TickCount
    tooltipShown := false

    ; ── signal 감시 + PS 종료 대기 ──
    Loop {
        if (!tooltipShown && FileExist(signalPath)) {
            dir := ""
            Loop 5 {
                try {
                    dir := Trim(FileRead(signalPath))
                } catch {
                    dir := ""
                }
                if (dir != "")
                    break
                Sleep(30)
            }
            if (dir = "On" || dir = "Off") {
                ToolTip(radioType " " dir)
                tooltipShown := true
                SetTimer(() => ToolTip(), -2000)
            }
        }

        if !ProcessExist(pid)
            break

        ; ★ 타임아웃 15초 → 30초 (BT Off는 오래 걸릴 수 있음)
        if (A_TickCount - startTime > 30000) {
            try ProcessClose(pid)
            break
        }

        Sleep(50)
    }

    ; ── 파일 flush 대기 ──
    Sleep(150)

    ; ── signal 놓친 경우 폴백 ──
    if (!tooltipShown && FileExist(signalPath)) {
        dir := ""
        Loop 5 {
            try {
                dir := Trim(FileRead(signalPath))
            } catch {
                dir := ""
            }
            if (dir != "")
                break
            Sleep(50)
        }
        if (dir = "On" || dir = "Off") {
            ToolTip(radioType " " dir)
            tooltipShown := true
            SetTimer(() => ToolTip(), -2000)
        }
    }

    ; ── result 읽기 (재시도) ──
    result := ""
    Loop 10 {
        if FileExist(resultPath) {
            try {
                result := Trim(FileRead(resultPath))
            } catch {
                result := ""
            }
            if (result != "")
                break
        }
        Sleep(100)
    }

    ; ── 최종 판정 ──
    if (result = "OK") {
        ; 성공: 아무것도 안 함
    } else if (result = "") {
        ; PS가 result를 못 씀 (타임아웃으로 강제 종료, 또는 파일 flush 실패)
        ; signal을 이미 봤다면 토글 방향은 확정된 것이므로 실패 표시하지 않음
        if (!tooltipShown) {
            ToolTip(radioType " : timeout")
            SetTimer(() => ToolTip(), -2000)
        }
        ; signal 봤으면 아무것도 안 함 (이미 "Bluetooth Off" 표시됨)
    } else {
        ; 명확한 실패 (SetState:Denied, Exception 등)
        ToolTip(radioType " toggle failed")
        SetTimer(() => ToolTip(), -2000)
    }

    ; ── 정리 ──
    if FileExist(signalPath)
        FileDelete(signalPath)
    if FileExist(resultPath)
        FileDelete(resultPath)

    ; ── busy 해제 ──
    if (radioType = "WiFi")
        radioBusyWiFi := false
    else
        radioBusyBluetooth := false
}