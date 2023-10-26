#Persistent
SetBatchLines -1

ToolTip, F1 Start | F3 Close Roblox | L Exit Macro

isPaused := true
startTime := 0

F1::
    isPaused := !isPaused

    if (isPaused)
    {
        SetTimer, ClickLoop, Off
    }
    else
    {
        startTime := A_TickCount
        SetTimer, ClickLoop, 1000
    }
Return

F3::
    WinClose, Roblox
    ExitApp
Return

ClickLoop:
    IfWinActive, Roblox
    {
        if (!isPaused)
        {
            Click, 74, 15
        }
    }


    elapsedTime := (A_TickCount - startTime) // 60000

    ToolTip, F1 Start (%elapsedTime% minutes) | F3 Close Roblox | L Exit Macro

Return

L::ExitApp
