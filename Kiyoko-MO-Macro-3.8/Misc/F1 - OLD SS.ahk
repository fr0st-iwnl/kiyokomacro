SSOLD2:
Gui, Submit, Hide
Gui, Destroy
InputBox, logs, How many ss do you want to take? ,(After the macro finishes the amount you put it will automatically close the roblox)
if ErrorLevel = 1
{
    ExitApp
}
InputBox, chargeRhythm, Charge Rhythm?, Do you want to charge Rhythm? (Yes/No)

if (chargeRhythm = "Yes" or chargeRhythm = "yes" or chargeRhythm = "Y" or chargeRhythm = "y")
{
    useSend1r := true
}
else
{
    useSend1r := false
}

removetooltip:
ToolTip
return

f1::
loop,
{
    Tooltip, % A_Index
    SetTimer, removetooltip, -3000
    Send {Click 3}
    Sleep 500
    Send 2{Click}
    Sleep 500
    if (useSend1r)
    {
        Send 1r
    }
    else
    {
        Send 1
    }
    Sleep 2700
    Loop, 4
    {
        Loop, 4
        {
            Send {Click}
            Sleep 1050
        }
        Sleep 100
        Send {Click, Right}
        Sleep 1050
    }
    Send {Click}
    Sleep 1100
    Send {Click}
    Sleep 1100
    Send {Click}
    Sleep 1100
    Send 1
    Sleep 1100
    if A_Index = %logs%
    {
        Send !{f4}
        ExitApp
    } 
}
Return

j::ExitApp