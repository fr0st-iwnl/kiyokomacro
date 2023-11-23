
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
    temp = 0
    protein = true
    Loop,
    {
        if protein = true
		{			
			temp++
			Sleep 100
			Send 2
			Sleep 50
			Send {Click 10}
			Sleep 8000
			Send 1
			if temp = 5
			{				
				protein = false
			}		
		}
        if protein = false
        {
            Sleep 1000
            Send 1 
            Sleep 100
            StartTime7 := A_TickCount
			Loop ,
			{				
				Click
				Sleep 16
			} Until A_TickCount - StartTime7 > 22000
            Send 1
            protein = true
            temp = 0
            Sleep 1000
        }
        StartTime3 := A_TickCount
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
        } Until A_TickCount - StartTime3 > 180000
        
    }
}
else
{
    Return
}
return

L::ExitApp
K::Pause