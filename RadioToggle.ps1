param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('WiFi', 'Bluetooth')]
    [string]$RadioType
)

; ★ 하드코딩된 경로 대신 $PSScriptRoot 사용 (스크립트가 위치한 폴더 기준)
$signalPath = Join-Path $PSScriptRoot "RadioToggle.signal"
$resultPath = Join-Path $PSScriptRoot "RadioToggle.result"
$logPath    = Join-Path $PSScriptRoot "RadioToggle.log"

if (Test-Path $signalPath) { Remove-Item $signalPath -Force }
if (Test-Path $resultPath) { Remove-Item $resultPath -Force }

function Write-Log($msg) {
    "[$(Get-Date -Format 'HH:mm:ss.fff')] $msg" |
        Out-File $logPath -Append -Encoding UTF8
}

Write-Log "===== START | RadioType=$RadioType ====="

try {
    Add-Type -AssemblyName System.Runtime.WindowsRuntime

    $asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
        $_.Name -eq 'AsTask' -and
        $_.GetParameters().Count -eq 1 -and
        $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'
    })[0]

    Function Await($WinRtTask, $ResultType) {
        $asTask  = $asTaskGeneric.MakeGenericMethod($ResultType)
        $netTask = $asTask.Invoke($null, @($WinRtTask))
        $netTask.Wait() | Out-Null
        return $netTask.Result
    }

    $RadioClass        = [Windows.Devices.Radios.Radio,Windows.System.Devices,ContentType=WindowsRuntime]
    $AccessStatusClass = [Windows.Devices.Radios.RadioAccessStatus,Windows.System.Devices,ContentType=WindowsRuntime]
    $RadioStateClass   = [Windows.Devices.Radios.RadioState,Windows.System.Devices,ContentType=WindowsRuntime]

    # 1) 접근 권한
    Write-Log "Step 1: RequestAccessAsync"
    $access = Await ($RadioClass::RequestAccessAsync()) ($AccessStatusClass)
    Write-Log "  Access = $access"
    if ($access.ToString() -ne 'Allowed') {
        Write-Log "  → exit 10 (AccessDenied)"
        [System.IO.File]::WriteAllText($resultPath, "AccessDenied:" + $access.ToString())
        exit 10
    }

    # 2) 라디오 목록
    Write-Log "Step 2: GetRadiosAsync"
    $radios = Await ($RadioClass::GetRadiosAsync()) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Radios.Radio]])
    Write-Log "  Radio count = $($radios.Count)"

    $target = $null
    foreach ($r in $radios) {
        Write-Log "  Found: Kind=$($r.Kind) State=$($r.State)"
        if ($r.Kind.ToString() -eq $RadioType) { $target = $r; break }
    }
    if (-not $target) {
        Write-Log "  → exit 2 (NoTarget)"
        [System.IO.File]::WriteAllText($resultPath, "NoTarget")
        exit 2
    }

    # 3) 방향 결정
    $currentState = $target.State.ToString()
    Write-Log "Step 3: Current = $currentState"

    if ($currentState -eq 'On') {
        $newState  = $RadioStateClass::Off
        $direction = "Off"
    } else {
        $newState  = $RadioStateClass::On
        $direction = "On"
    }

    # 4) signal 파일 기록
    [System.IO.File]::WriteAllText($signalPath, $direction)
    Write-Log "Step 4: signal written = $direction"

    # 5) SetStateAsync
    Write-Log "Step 5: SetStateAsync → $newState"
    $result = Await ($target.SetStateAsync($newState)) ($AccessStatusClass)
    $resultStr = $result.ToString()
    Write-Log "  SetState result = $resultStr"

    if ($resultStr -eq 'Allowed') {
        Write-Log "  → exit 0 (OK)"
        [System.IO.File]::WriteAllText($resultPath, "OK")
        exit 0
    } else {
        Write-Log "  → exit 3 (SetState:$resultStr)"
        [System.IO.File]::WriteAllText($resultPath, "SetState:" + $resultStr)
        exit 3
    }
}
catch {
    $errType = $_.Exception.GetType().FullName
    $errMsg  = $_.Exception.Message
    $errStk  = $_.ScriptStackTrace
    Write-Log "EXCEPTION: $errType"
    Write-Log "MESSAGE  : $errMsg"
    Write-Log "STACK    : $errStk"
    [System.IO.File]::WriteAllText($resultPath, "Exception:" + $errMsg)
    exit 99
}