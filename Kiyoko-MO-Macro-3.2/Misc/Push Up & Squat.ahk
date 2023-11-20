#MaxThreadsPerHotkey, 2
Loop, 3
{	
	CenterWindow("ahk_exe RobloxPlayerBeta.exe")
	Sleep 100
}
CenterWindow(WinTitle)
{	
	WinGetPos,,, Width, Height, %WinTitle%
	WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2), 400, 400
}
InputBox, wait, Enter Cooldown, on Squat and Push Up put in number in miliseconds 1000 = 1 Seconds
if ErrorLevel = 1
{
    ExitApp
}
return

rtooltip(){
    Tooltip
}
end::Reload



F1::
current = 0
slot = 2
macro_on := !macro_on
if (macro_on)
{
    CoordMode , Pixel, Window
    PixelGetColor , color2, 250, 134,
    Sleep 100
    Send 1
    Loop,
    {
        Send {Click}
        Sleep %wait%
        PixelSearch , x, y, 40, 133, 45, 135, 0x3A3A3A, 40, Fast
        If ErrorLevel = 0
        {
            StartTime4 := A_TickCount
            Loop,
            {
                Sleep 100
                PixelSearch , x, y, 249, 133, 250, 135, color2, , Fast
                If ErrorLevel = 0
                {
                    Break
                } 
            } Until A_TickCount - StartTime4 > 16000
        }
        PixelSearch , x, y, 80, 144, 85, 146, 0x3A3A3A, 40, Fast
        If ErrorLevel = 0
        {
            tooltip, eat
            settimer, rtooltip, -3000
            if current <= 5
            {
	    	Send 1
                Sleep 100
                Send %slot%
                Sleep 200
                Send {Click 10}
                Sleep 5500
                Send %slot%
                Sleep 100
                Send 1
                current++
            }
            if slot = 0
            {
                if current >= 5
                {
                    Send !{f4}
                    Exitapp
                }
            }
            if current >= 5
            {
                slot++
                current = 0
                if slot >= 10
                {
                    slot = 0
                }
            }
        }
    }
}
else
{
    Return
}
return

L::ExitApp
K::Pause