#Persistent
SetBatchLines -1

ToolTip, F1 Start | F3 Close Roblox | Alt + H Help Menu | J Exit Macro

isPaused := true
startTime := 0
isMacroActive := false

F1::
    isPaused := !isPaused
    isMacroActive := !isPaused

    if (isPaused)
    {
        SetTimer, ClickLoop, Off
    }
    else
    {
        startTime := A_TickCount
        SetTimer, ClickLoop, 1000

        WinGetPos, winX, winY, winWidth, winHeight, Roblox
        SysGet, screenWidth, 78 
        SysGet, screenHeight, 79

        if (winWidth != screenWidth or winHeight != screenHeight)
        {
            ToolTip, Resizing screen...
            Sleep, 2000

            Send, {F11}

            ToolTip
        }
        else
        {
            ToolTip, Roblox is already in fullscreen mode.
            Sleep, 2000
            ToolTip
        }
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
    ToolTip, F1 Start (%elapsedTime% minutes) | F3 Close Roblox | J Exit Macro

Return

!h::
    if (isMacroActive)
    {
        return
    }
    else
    {
        MsgBox, 64, Help Menu, The macro keeps clicking on the chat to prevent AFK kicks. `n` `n`Time spent in bed is tracked and shown in the tooltip. `n` `n` Enjoy :)
    }
Return

j::ExitApp
