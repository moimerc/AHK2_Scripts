; 1. SYSTEM SHELL
; ---------------------------------------------------------------------------
; [INDEX]
; ---------------------------------------------------------------------------
; ⬜ Global Basics
;    ├─ Rename file (F2)                |  Ctrl + R
;    ├─ Redo                            |  Ctrl + Shift + Z
;    └─ Snipping Tool (ms-screenclip)   |  PrtScn
;
; 🟦 Bidirectional Korean/English Typo Converter |  LAlt + RAlt
; 🟪 Parenthesis / Ruby Text Remover (with selection) |  LCtrl + AppsKey
; 🟧 Emergency Key-Unstick & Explorer Restart    |  Shift + Esc
;
; 🔲 Shared Layout Detection Functions           |  IsJapaneseLayout, IsKoreanLayout, etc.
;
; 🟥 Japanese Layout Hotkeys
;    ├─ JP/EN toggle                    |  AppsKey + RAlt
;    ├─ Hiragana toggle                 |  RAlt
;    └─ Katakana toggle                 |  AppsKey
;
; 🟩 Korean Layout Hotkeys
;    ├─ KO/EN toggle                    |  RAlt
;    └─ Hanja input                     |  AppsKey
;
; 🟨 Terminal & CMD Hotkeys
;    ├─ Previous / next tab             |  Ctrl + Left / Right
;    ├─ Python & Java build             |  CapsLock multi-tap (+ ExecuteCapsAction)
;    └─ Activate Conda venv             |  Ctrl + Alt + LWin
;
; ⬛ Browser Hotkeys
;    └─ Previous / next tab             |  Ctrl + Left / Right
;
; 🟫 Explorer Hotkeys (RClone Stash Engine)
;    ├─ Copy stashed filename           |  CapsLock 1 tap
;    ├─ Stash path & run RClone         |  CapsLock 2 taps
;    └─ Internal function               |  ExecuteExplorerCapsAction
;
; ⏰ Keep-Awake Timer (Caffeine alternative) |  Alt + Space
;    ├─ With input   : auto-release after set time
;    ├─ Empty / 0    : indefinite (Override: active)
;    └─ Tray tooltip : refreshed every 60s
;
; 🟣 Mute & Auto-Mute Control
;    ├─ Native mute & Auto-Mute toggle          |  Volume_Mute
;    └─ Device change detection (Auto-Mute sub) | CheckAudioDeviceChange (internal)
;
; 🟢 WiFi toggle (Volume Up)             |  Volume_Up
; 🔵 Bluetooth toggle (Volume Down)      |  Volume_Down
; ---------------------------------------------------------------------------
;
SetKeyDelay(40, 40)

; --- [Global variables & object initialization] ---
; To use the EveryHangul feature, do the following:
;   1. Download EveryHangul.ahk and place it next to main.ahk
;   2. Uncomment the two lines below (and the #Include line in main.ahk)
; global hangul := EveryHangul()
global caps_count := 0
global explorer_caps_count := 0
global CompareQueue := []
global WorkDir := "C:\Path\To\Your\Workspace"  ; <-- set this to your workspace path
global DefaultVenvCmd := "conda activate my_env" ; <-- Modify this to match your environment name (e.g., "conda activate my_env").

; ---------------------------------------------------------------------------
; ⬜ Global Basics
; ---------------------------------------------------------------------------

; Ctrl + R → F2 (Rename)
^r::Send("{F2}")

; Ctrl + Shift + Z → Ctrl + Y (Redo)
^+z::Send("^y")

; PrtScn → launch Snipping Tool protocol directly
$PrintScreen::
{
    Run("ms-screenclip:")
}


; ---------------------------------------------------------------------------
; 🟦 Bidirectional Korean/English Typo Converter (LAlt -> RAlt order required)
;    * To enable: uncomment the block below and the EveryHangul lines above + in main.ahk
; ---------------------------------------------------------------------------
/*
~LAlt & RAlt::
{
    ; 1. Wait for physical key release (prevents stuck Alt)
    KeyWait "LAlt"
    KeyWait "RAlt"
    Sleep(15)

    ; 2. Backup clipboard (text only -> very fast)
    savedClipboard := A_Clipboard
    A_Clipboard := ""

    ; 3. Check current selection
    SendInput("^c")
    ClipWait(0.03)

    ; 4. No selection OR line copy (Sublime, etc.) -> word-select fallback
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
        ; 5. Auto-detect direction
        if (RegExMatch(original, "[가-힣ㄱ-ㅎㅏ-ㅣ]"))
            converted := hangul.EngKey(original)
        else
            converted := hangul.KorKey(original)

        ; 6. Set IME to desired state first (prevents re-conversion after paste)
        SendInput("{vk15}")
        Sleep(15)

        ; 7. Delete selection then insert text
        SendInput("{BackSpace}")
        Sleep(5)
        SendText(converted)
    }

    ; 8. Restore clipboard
    Sleep(10)
    A_Clipboard := savedClipboard
}
*/


; ---------------------------------------------------------------------------
; 🟪 Parenthesis / Ruby Text Remover (with selection)
; ---------------------------------------------------------------------------

~LCtrl & AppsKey::
{
    ; 1. Backup existing clipboard
    savedClipboard := ClipboardAll()
    A_Clipboard := ""

    ; 2. Copy selected text
    Send("^c")
    if !ClipWait(0.2) {
        A_Clipboard := savedClipboard
        return
    }

    original := A_Clipboard

    ; 3. Remove parentheses and their contents
    converted := RegExReplace(original, "[(（][^)）]*[)）]", "")

    ; 4. Replace selection with converted text
    A_Clipboard := converted
    Send("^v")

    ; 5. Restore existing clipboard
    Sleep(50)
    A_Clipboard := savedClipboard
}


; ---------------------------------------------------------------------------
; 🟧 Emergency Key-Unstick & Explorer Restart (global)
; ---------------------------------------------------------------------------

; * (wildcard) so it always works even if other keys are stuck
*+Esc::
{
    ; 1. If the user physically pressed Ctrl too, launch Task Manager directly and exit
    if GetKeyState("Ctrl", "P")
    {
        Run("taskmgr.exe")
        return
    }

    ; 2. Otherwise (pure Shift+Esc, or Alt etc. stuck), force-release
    Send("{Blind}{LControl Up}{RControl Up}{LAlt Up}{RAlt Up}{LWin Up}{RWin Up}{Shift Up}")
    SetCapsLockState("Off")
    RunWait("taskkill /f /im explorer.exe", , "Hide")
    Run("explorer.exe")
    MsgBox("All key states have been released and Explorer (explorer.exe) has been restarted.")
}


; ---------------------------------------------------------------------------
; 🔲 Shared Layout Functions
; ---------------------------------------------------------------------------

IsJapaneseLayout() {
    langId := GetInputLangID()
    Return (langId = "0x411") ; Japanese
}

IsKoreanLayout() {
    langId := GetInputLangID()
    Return (langId = "0x412") ; Korean
}


GetInputLangID(hWnd := "") {
    if (!hWnd) {
        ; 1. Not just the active window - find the actual focused window/control
        hWnd := WinActive("A")
        
        ; For UWP apps, must fetch the deeper focus handle for immediate refresh
        if WinGetProcessName(hWnd) = "ApplicationFrameHost.exe" {
            static stGTI := Buffer(24 + 6 * A_PtrSize, 0)
            NumPut("UInt", stGTI.Size, stGTI)
            ; Fetch the actual focus handle of the current thread via GetGUIThreadInfo
            if DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", stGTI) {
                hwndFocus := NumGet(stGTI, 8 + A_PtrSize, "Ptr")
                if hwndFocus
                    hWnd := hwndFocus
            }
        }
    }

    ; 2. Get IME handle (most accurate layout detection)
    imeHwnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hWnd, "Ptr")
    
    ; If IME handle exists, extract layout from its thread
    targetHwnd := imeHwnd ? imeHwnd : hWnd
    threadId := DllCall('GetWindowThreadProcessId', 'Ptr', targetHwnd, 'UInt', 0)
    lyt := DllCall('GetKeyboardLayout', 'Ptr', threadId, 'UInt')
    
    return Format("{:#x}", lyt & 0x3FFF)
}


; ---------------------------------------------------------------------------
; 🟥 Japanese Layout Hotkeys
; ---------------------------------------------------------------------------

#HotIf IsJapaneseLayout()

; AppsKey + RAlt → Alt + ` (JP/EN toggle)
AppsKey & RAlt::SendEvent("!{vkC0}")

; RAlt → Ctrl + Caps (Hiragana toggle)
*RAlt::
{
    SendEvent("^{CapsLock}")
}

; AppsKey → Alt + Caps (Katakana toggle)
*AppsKey::
{
    SendEvent("!{CapsLock}")
}

#HotIf  ; reset condition


; ---------------------------------------------------------------------------
; 🟩 Korean Layout Hotkeys
; ---------------------------------------------------------------------------

#HotIf IsKoreanLayout()

; RAlt → Shift + Space (KO/EN toggle)
*RAlt::
{
    SendEvent("{vk15}")
}

; AppsKey → Ctrl + Space (Hanja input)
*AppsKey::
{
    SendEvent("{vk19}")
}

#HotIf  ; reset condition


; ---------------------------------------------------------------------------
; 🟨 Terminal & CMD Hotkeys
; ---------------------------------------------------------------------------

#HotIf WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe cmd.exe")

; Ctrl + Left/Right → previous / next tab
^Left::Send("^+{Tab}")
^Right::Send("^{Tab}")

; CapsLock multi-tap (1: python, 2: java, 3: javac)
CapsLock::
{
    global caps_count
    caps_count++
    SetTimer(ExecuteCapsAction, -180)
}

; Ctrl + Alt + Win → Activate my default virtual environment
^!LWin::Send(DefaultVenvCmd)

#HotIf


; ---------------------------------------------------------------------------
; 🟨 ExecuteCapsAction (terminal CapsLock multi-tap helper)
; ---------------------------------------------------------------------------
ExecuteCapsAction()
{
    global caps_count
    
    if (caps_count == 1)      ; 1 tap
    {
        SendText("python .py")
        Send("{Left 3}")
    }
    else if (caps_count == 2) ; 2 taps
    {
        SendText("java ")
    }
    else if (caps_count >= 3) ; 3+ taps
    {
        SendText("javac .java")
        Send("{Left 5}")
    }
    
    caps_count := 0 ; reset count
}


; ---------------------------------------------------------------------------
; ⬛ Browser Hotkeys
; ---------------------------------------------------------------------------

#HotIf WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("Edge ahk_exe ApplicationFrameHost.exe")

; Ctrl + Left/Right → previous / next tab
^Left::Send("^+{Tab}")
^Right::Send("^{Tab}")

#HotIf


; ---------------------------------------------------------------------------
; 🟫 Explorer Hotkeys (RClone Stash Engine)
; ---------------------------------------------------------------------------

#HotIf WinActive("ahk_exe explorer.exe")

; CapsLock 1 tap (clear stash & copy filename) / 2 taps (stash path & run RClone)
CapsLock::
{
    global explorer_caps_count
    explorer_caps_count++
    SetTimer(ExecuteExplorerCapsAction, -180)
}

#HotIf


; ---------------------------------------------------------------------------
; 🟫 ExecuteExplorerCapsAction (Explorer CapsLock multi-tap helper)
; ---------------------------------------------------------------------------
ExecuteExplorerCapsAction()
{
    global explorer_caps_count, CompareQueue, WorkDir

    if (explorer_caps_count == 1)
    {
        ; 1 tap: reset queue (stash) then copy filename without extension
        CompareQueue := []

        oldClip := ClipboardAll()
        A_Clipboard := ""
        Send("^c") 

        if ClipWait(0.3)
        {
            targetPath := StrSplit(A_Clipboard, "`n", "`r")[1]
            SplitPath targetPath, , , , &nameNoExt
            A_Clipboard := nameNoExt
            
            ToolTip("Copy complete: " nameNoExt)
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
        ; 2 taps: copy path and push to CompareQueue
        oldClip := ClipboardAll()
        A_Clipboard := ""
        Send("^c")

        if ClipWait(0.3)
        {
            ; Extract clipboard string and strip double quotes
            targetPath := StrSplit(A_Clipboard, "`n", "`r")[1]
            targetPath := StrReplace(targetPath, '"', "")
            
            ; Overwrite clipboard with the pure path (no quotes)
            A_Clipboard := targetPath
            
            CompareQueue.Push(targetPath)

            if (CompareQueue.Length == 1)
            {
                ToolTip("Path 1 saved: " targetPath)
                SetTimer () => ToolTip(), -1500
            }
            else if (CompareQueue.Length == 2)
            {
                path1 := CompareQueue[1]
                path2 := CompareQueue[2]
                CompareQueue := []

                ; Precisely distinguish folder/file types
                isDir1 := DirExist(path1) != ""
                isDir2 := DirExist(path2) != ""

                cmdStr := ""

                if (isDir1 && isDir2)
                {
                    ; [Case 1] Both folders
                    cmdStr := 'rclone check "' path1 '" "' path2 '" -P -v'
                }
                else if (!isDir1 && !isDir2)
                {
                    ; [Case 2] Both files
                    SplitPath path1, &file1, &dir1
                    SplitPath path2, &file2, &dir2

                    if (file1 == file2)
                    {
                        cmdStr := 'rclone check "' dir1 '" "' dir2 '" --include "/' file1 '" -P -v'
                    }
                    else
                    {
                        ; Skip if names/extensions differ
                        ToolTip("Files with different names/extensions cannot be compared.")
                        SetTimer () => ToolTip(), -2000
                        return
                    }
                }
                else
                {
                    ; [Case 3] File vs folder
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

                ToolTip("Path 2 saved! Starting comparison.")
                SetTimer () => ToolTip(), -1500

                ; Fix window title + fixed prompt + echo command then execute
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
; ⏰ Keep-Awake Timer (Caffeine alternative)  |  Alt + Space
; ---------------------------------------------------------------------------
global KeepAwakeActive   := false
global KeepAwakeInfinite := false
global KeepAwakeEndTime  := 0

global SIM_INTERVAL_MS        := 270000   ; 270s (30s margin against Sleep 300s)
global USER_IDLE_THRESHOLD_MS := 240000   ; 4 min (aligned with Windows display off)

A_IconTip := "Override: inactive"

!Space::
{
    global KeepAwakeActive, KeepAwakeInfinite, KeepAwakeEndTime

    if (KeepAwakeActive)
    {
        if (KeepAwakeInfinite)
            status := "Current: indefinite active (Override: active)"
        else
            status := "Remaining: " FormatRemaining(KeepAwakeEndTime - A_TickCount)

        text := "Keep-awake mode is active.`n`n"
              . status "`n`n"
              . "Keep it active, or stop?"

        if ShowConfirmDialog("Keep-Awake Status", text)
            StopKeepAwake()
        return
    }

    ib := InputBox(
        "Enter the keep-awake duration in hours.`n"
        "(e.g. 1.5 = 1h 30m, 0.25 = 15m)`n`n"
        "Leave empty or enter 0 for indefinite mode.",
        "Keep-Awake Timer",
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

        ToolTip("Keep-awake: indefinite mode`n(display will still turn off normally)")
        SetTimer(() => ToolTip(), -3000)
        return
    }

    if (!IsNumber(val) || Float(val) < 0)
    {
        ToolTip("Please enter a number greater than 0.")
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

    ToolTip("Keep-awake started: " FormatHours(hours) "`n(display will still turn off normally)")
    SetTimer(() => ToolTip(), -3000)
}

; ─────────────────────────────────────────────────────────────────────────
; F16 simulation + conditional display off
; ─────────────────────────────────────────────────────────────────────────
SimulateActivity()
{
    global KeepAwakeActive, SIM_INTERVAL_MS, USER_IDLE_THRESHOLD_MS

    if (!KeepAwakeActive)
        return

    SendInput("{F16}")

    ; Idle detection
    if (A_TimeIdlePhysical > USER_IDLE_THRESHOLD_MS)
    {
        ; ★ If audio is playing, assume the user is watching media -> keep display on
        if (IsAudioPlaying())
        {
            SetTimer(SimulateActivity, -SIM_INTERVAL_MS)
            return
        }

        Sleep(50)
        SendMessage(0x0112, 0xF170, 2, , "Program Manager")   ; Force display off
    }

    SetTimer(SimulateActivity, -SIM_INTERVAL_MS)
}

; ─────────────────────────────────────────────────────────────────────────
; Audio playback detection (IAudioMeterInformation::GetPeakValue)
;   - If the default output device's peak level > 0, audio is playing
;   - Detectable even on the lock screen
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
; Stop keep-awake
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

    ToolTip("Keep-awake stopped.`nThe PC can now sleep normally.")
    SetTimer(() => ToolTip(), -3000)
}

; ─────────────────────────────────────────────────────────────────────────
; Refresh tray tooltip
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
; Time formatting helpers
; ─────────────────────────────────────────────────────────────────────────
FormatRemaining(ms)
{
    totalSec := Floor(ms / 1000)
    h := Floor(totalSec / 3600)
    m := Floor(Mod(totalSec, 3600) / 60)
    s := Mod(totalSec, 60)

    if (h > 0)
        return h "h " m "m"
    if (m > 0)
        return m "m " s "s"
    return s "s"
}

FormatHours(hours)
{
    totalMin := Round(hours * 60)
    h := Floor(totalMin / 60)
    m := Mod(totalMin, 60)

    if (h > 0 && m > 0)
        return h "h " m "m"
    if (h > 0)
        return h "h"
    return m "m"
}

; ─────────────────────────────────────────────────────────────────────────
; Custom confirmation dialog
; ─────────────────────────────────────────────────────────────────────────
ShowConfirmDialog(title, text)
{
    dlg := Gui("+AlwaysOnTop +ToolWindow -MinimizeBox", title)
    dlg.SetFont("s10", "Malgun Gothic")
    dlg.MarginX := 20
    dlg.MarginY := 15

    dlg.AddText("w340", text)
    dlg.ConfirmResult := false

    dlg.AddButton("w120 h32 Default", "Keep").OnEvent("Click", (*) => dlg.Destroy())
    dlg.AddButton("x+20 w120 h32", "Stop").OnEvent("Click", ExitConfirm.Bind(dlg))

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
; 🟣 Mute & Auto-Mute Control
; ---------------------------------------------------------------------------
global prevAudioDevice := ""
global autoMuteEnabled := false     ; Auto-Mute ON/OFF (default OFF)

; Save current default audio device name at script start
try {
    prevAudioDevice := SoundGetName()
}


; ---------------------------------------------------------------------------
; 🟣 Volume_Mute: native mute + Auto-Mute toggle (simultaneous)
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
; 🟣 CheckAudioDeviceChange (Auto-Mute sub - device change detection)
; ---------------------------------------------------------------------------
CheckAudioDeviceChange()
{
    global prevAudioDevice
    try
    {
        currentAudioDevice := SoundGetName()

        ; Immediately mute whenever the audio device changes
        if (prevAudioDevice != "" && currentAudioDevice != prevAudioDevice)
        {
            SoundSetMute(1)
        }

        prevAudioDevice := currentAudioDevice
    }
}


; ---------------------------------------------------------------------------
; 🟢 WiFi toggle (Volume Up)
; ---------------------------------------------------------------------------
global radioBusyWiFi := false

$Volume_Up::ToggleRadio("WiFi")


; ---------------------------------------------------------------------------
; 🔵 Bluetooth toggle (Volume Down)
; ---------------------------------------------------------------------------
global radioBusyBluetooth := false

$Volume_Down::ToggleRadio("Bluetooth")


; ---------------------------------------------------------------------------
; 🟢🔵 ToggleRadio (shared function for WiFi / Bluetooth toggle)
; ---------------------------------------------------------------------------
ToggleRadio(radioType) {
    global radioBusyWiFi, radioBusyBluetooth

    ; ── Check busy + acquire lock immediately ──
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

    ; ★ Use A_ScriptDir instead of hardcoded path (RadioToggle.ps1 lives next to this script)
    signalPath := A_ScriptDir "\RadioToggle.signal"
    resultPath := A_ScriptDir "\RadioToggle.result"
    psPath     := A_ScriptDir "\RadioToggle.ps1"

    if FileExist(signalPath)
        FileDelete(signalPath)
    if FileExist(resultPath)
        FileDelete(resultPath)

    ; ── Launch PS asynchronously ──
    Run(
        'powershell.exe -Mta -WindowStyle Hidden -NoProfile '
        '-ExecutionPolicy Bypass -File "' psPath '" '
        '-RadioType ' radioType,
        , "Hide", &pid
    )

    startTime := A_TickCount
    tooltipShown := false

    ; ── Watch signal + wait for PS to exit ──
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

        ; ★ Timeout 15s -> 30s (BT Off can take a while)
        if (A_TickCount - startTime > 30000) {
            try ProcessClose(pid)
            break
        }

        Sleep(50)
    }

    ; ── Wait for file flush ──
    Sleep(150)

    ; ── Fallback if signal was missed ──
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

    ; ── Read result (retry) ──
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

    ; ── Final decision ──
    if (result = "OK") {
        ; Success: do nothing
    } else if (result = "") {
        ; PS couldn't write result (forced kill on timeout, or flush failed)
        ; If signal was already seen, the toggle direction is confirmed - don't mark as failure
        if (!tooltipShown) {
            ToolTip(radioType " : timeout")
            SetTimer(() => ToolTip(), -2000)
        }
        ; If signal was seen, do nothing (already showing "Bluetooth Off")
    } else {
        ; Clear failure (SetState:Denied, Exception, etc.)
        ToolTip(radioType " toggle failed")
        SetTimer(() => ToolTip(), -2000)
    }

    ; ── Cleanup ──
    if FileExist(signalPath)
        FileDelete(signalPath)
    if FileExist(resultPath)
        FileDelete(resultPath)

    ; ── Release lock ──
    if (radioType = "WiFi")
        radioBusyWiFi := false
    else
        radioBusyBluetooth := false
}