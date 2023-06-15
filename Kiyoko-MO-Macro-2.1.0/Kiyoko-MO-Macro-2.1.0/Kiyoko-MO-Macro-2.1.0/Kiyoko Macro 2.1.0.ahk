#NoEnv
#SingleInstance, force
SetCapsLockState, Off 
SetBatchLines -1
SoundPlay, SugiPula\Sound\plug.mp3
Version = 2.1.0
if (A_ScreenDPI != 96) {
    Run, ms-settings:display
    MsgBox,	16,Kiyoko's Macro, Your Scale `& layout settings need to be on 100`%
    ExitApp
}
If !FileExist("SugiPula") {
    MsgBox, the data file "SugiPula" folder is missing`nExtract file.
    ExitApp
}
__Index__ := "Basic"
Gui, 2:Font, cBlack, Consolas
Gui, 2:+AlwaysOnTop -Caption
Gui, 2:Add, Text,xm-8 ym,Kiyoko's macro L to Exit K to Pause
Gui, 2:Add, Edit,ym+18 xm-8  -VScroll w214 h43 vStatus 
Gui, 2:Add, GroupBox,xm-10 ym-12 w300 h30
Gui, 2:Show, w216 h68, Kiyoko's Status Window
OnMessage(0x200,"MOUSEOVER")
WinWait, Kiyoko's Status Window
WinGetPos,,, W, H, Kiyoko's Status Window
WinGetPos,,,, _h_, ahk_class Shell_TrayWnd
ArrayPosition := [(A_ScreenWidth)-W, (A_ScreenHeight)-(H+_h_)]
WinMove, Kiyoko's Status Window,, ArrayPosition[1], ArrayPosition[2]
global Status
Notify(NewMessage) {
    Status.= NewMessage "`n"
    If (GetLine(Status, "`n") > 4)
        Status := SubStr(Status, InStr(Status,"`n") + 1)
    GuiControl, 2:, Status, %Status%
    Gui, 2:Submit, NoHide
}
Notify("Checking Webhook. . .")
switch CheckforWebhook() {
    case "Missing" : {
        Notify("Enter Webhook")
        InputBox, Webhook, Enter Webhook,, hide, 300 , 100
        Notify("Enter UserID")
        InputBox, UserID, Enter User ID,,, 300 , 100
        If (!UserID) or (!Webhook) {
            Notify("No Webhook")
            MsgBox,,Kiyoko's Macro, Are you sure? No webhook?
        } else if (Webhook) And (UserID) {
            UserID := "<@" UserID ">"
            If (GetUrlStatus(Webhook, 10) != 200) {
                Notify("Failed to Connect Webhook")
                MsgBox,,Viavce's Macro, Failed to connect to server`, Please make sure the link is correct and try again.
                Msgbox, 4, Kiyoko's Macro, Do you want to disable webhook and Continue the macro?
                IfMsgBox, Yes
                {
                    IniDelete, settings, Notifications , Webhook
                    IniDelete, settings, Notifications , UserID
                } else {
                    ExitApp
                }
            } else {
                whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
                post={"username":"i love Kiyoko's macro","content":"%UserID% Hello kid!"}
                whr.Open("POST", Webhook, False),whr.SetRequestHeader("Content-Type", "application/json"),whr.Send(post)
                Notify("Posted")
                MsgBox,4, Kiyoko's Macro, Do you get Ping? / Is that ur name?
                IfMsgBox, No 
                {
                    Reload
                }
                IniWrite, %Webhook%, settings.ini, Notifications, Webhook
                IniWrite, %UserID%, settings.ini, Notifications, UserID
                Notify("Webhook Notifications Saved")
            }
        }
    }
    case "Error" : MsgBox,,Viavce's Macro, Failed to connect to server`, Please make sure the link is correct and try again.
    case "timedout" : MsgBox,,Viavce's Macro, this site can't be reached, took too long to respond.
}
Gui, +AlwaysOnTop -DPIScale -Caption +LastFound
Gui, Color, Aqua, Font, cBlack, ,Consolas
Gui, Add, Text,x35 y10 w700 h50 +BackgroundTrans Center gMove, Version: %Version%  Version: %A_AhkVersion%
Gui, Add, Text, ym xm, Kiyoko's Macro
Gui, Add, GroupBox, xm ym+20 w30 h260
Gui, Add, GroupBox, xm+50 ym+20 w411 h260 vTitle, Home
Gui, Add, Text, xm+10 ym+40 gBack, K 
Gui, Add, Picture,w27 h30 xm+1 ym+65          gTabTreadmill, SugiPula\Icon&Menu\treadmill.png
Gui, Add, Picture,w27 h30 xm+1 ym+98          gTabWeight, SugiPula\Icon&Menu\weight.png
Gui, Add, Picture,w27 h30 xm+1 ym+131         gTabSP, SugiPula\Icon&Menu\sp.png
Gui, Add, Picture,w27 h30 xm+1 ym+164         gTabSS, SugiPula\Icon&Menu\ss.png
Gui, Add, Picture,w27 h30 xm+1 ym+197         gTabDura, SugiPula\Icon&Menu\heart.png
Gui, Add, Picture,w27 h30 xm+1 ym+230         gTaball41, SugiPula\Icon&Menu\frost.png
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vT1            ,Treadmill macro made by Kiyoko - fr0st-iwnl
Gui, Add, Text,ym+23 xm          vT2            ,! Minimize ur Roblox first. !
Gui, Add, Text,ym+45 xm          vT3            ,Press on done to macro.
Gui, Add, Button, x356 y250      vT18 gTreadmill,Done
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vW1            ,Weight macro made by Kiyoko - fr0st-iwnl. 
Gui, Add, Text,ym+23 xm          vW2            ,! Minimize ur Roblox first. !
Gui, Add, Text,ym+45 xm          vW3            ,Press on done to macro.
Gui, Add, Button, x356 y250      vW13  gWeight  ,Done
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vSP1           ,Rhythm
Gui, Add, DDL, w150 ym+20 xm     vSP2           ,Do nothing|Rhythm|Flow
Gui, Add, Text,ym+45 xm          vSP3           ,Choose method for eating 
Gui, Add, DDL, w150 ym+65 xm     vSP4           ,Inventory|2-0|Scalar+Inventory|Strave
Gui, Add, Text,ym+90 xm          vSP5           ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vSP6           ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text, ym+135 xm        vSP7           ,Pick Stamina Regen  
Gui, Add, DDL, ym+155 xm w150    vSP8           ,Fast|Medium|Slow
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vSP9           ,Leave Setting
Gui, Add, DDL, ym+20 xm w150     vSP10          ,Exit Roblox|Shutdown|Do nothing
Gui, Add, Text,ym+45 xm          vSP11          ,Clip Username
Gui, Add, DDL, ym+65 xm w150     vSP12          ,Video|Screenshot|Do nothing
Gui, Add, Button, x356 y250      vSP14   gSP    ,Done
Gui, Add, Text,ym+100 xm             vSP15      ,Dont use combat when u macro !
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vSS1           ,Macro by Kiyoko - fr0st-iwnl.
Gui, Add, Text,ym+23 xm          vSS2           ,! Press on F1 to start the macro !
Gui, Add, Text,ym+45 xm          vSS3           ,!! You gotta choose how many ss do u want to take !!
Gui, Add, Text,ym+65 xm          vSS4           ,Press on done to macro.  
Gui, Add, Button, x356 y250      vSS14   gSS    ,Done
Gui, Margin, 80, 50
; Gui, Add, Text,ym xm             vd1            ,which side to dura
; Gui, Add, DDL, w150 ym+20 xm     vd2            ,Left|Both
; Gui, Add, Text,ym+45 xm          vd3            ,Left side options
; Gui, Add, DDL, w150 ym+65 xm     vd4            ,Rhythm|Do nothing
; Gui, Add, Text,ym+90 xm          vd5            ,Duration Settings  
; Gui, Add, DDL, w150 ym+110 xm    vd6            ,Macro Indefinitely|Fatigue Estimate
; Gui, Add, Text,ym+135 xm         vd7            ,Leave Setting 
; Gui, Add, DDL, w150 ym+155 xm    vd8            ,Exit Roblox|Shutdown|Do nothing
; Gui, Margin, 300, 50
; Gui, Add, Text,ym xm             vd9            ,Slow hp detection
; Gui, Add, DDL, ym+20 xm w150     vd10           ,Left|Both|Right|None
; Gui, Add, Text,ym+45 xm          vd11           ,Right side options
; Gui, Add, DDL, w150 ym+65 xm     vd12           ,Rhythm|Do nothing
; Gui, Add, Button, x356 y250      vd15  gDura    ,Done
Gui, Add, Text,ym+10 xm       vd16       ,Probably coming soon!
Gui, Margin, 80, 50
Gui, Add, Text, ym xm vm1 , Push up, Squat Macro - Another tab will open when u press on start.
Gui, Add, Button, ym+20 xm vm2 w70 gmuscle, Start 
Gui, Add, Text, ym+45 xm vm3 , Basic Run Macro - Another tab will open when u press on start.
Gui, Add, Button, ym+65 xm vm4 w70 grunmacro, Start
Notify("Loaded Ui")
HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Notify("Hide Tab")
IniRead, Treadmill, settings.ini, Data, Treadmill
IniRead, Weight, settings.ini, Data, Weight
IniRead, StrikePower, settings.ini, Data, StrikePower
IniRead, StrikeSpeed, settings.ini, Data, StrikeSpeed
IniRead, Durability, settings.ini, Data, Durability
for Item, Value in {"T": Treadmill, "W": Weight, "SP": Strikepower, "SS": StrikeSpeed, "d": Durability} {
    If (Value != "ERROR") {
        Loop, Parse, Value, `,
        {
            v := Item (A_Index * 2)
            GuiControl, ChooseString, %v%, %A_LoopField%
        }
    }
}
Notify("Loaded Settings")
Gui, Show, w480 h300
WinSet, Region, 0-0 R6-6 w480 h300
Notify("Succesfully Loaded Macro")Notify("Started at " A_Hour ":" A_Min ":" A_Sec)
Return
~k::pause
~l::ExitApp
Move:
    PostMessage, 0xA1, 2
Return
Back:
    GuiControl,, title, Home
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabTreadmill:
    GuiControl,, title, Treadmill Tab
    ShowTab("Treadmill")
    Notify("Displaying Treadmill Tab")
    HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabWeight:
    GuiControl,, title, Weight Tab
    ShowTab("Weight")
    Notify("Displaying Weight Tab")
    HideTab("Treadmill") HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabSP:
    GuiControl,, title, Strike Power Tab
    ShowTab("StrikePower")
    Notify("Displaying StrikePower Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabSS:
    GuiControl,, title, Strike Speed Tab
    ShowTab("StrikeSpeed")
    Notify("Displaying StrikeSpeed Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("Durability")HideTab("Misc")
Return
TabDura:
    GuiControl,, title, Durability Tab
    ShowTab("Durability")
    Notify("Displaying Durability Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Misc")
Return
Taball41:
    GuiControl,, title, Miscellaneous Tab
    ShowTab("Misc")
    Notify("Displaying Miscellaneous Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")
Return


HideTab(Tab) {
    Switch Tab {
        case "Treadmill": v := "T"
        case "Weight": v := "W"
        case "StrikePower": v := "SP"
        case "StrikeSpeed": v := "SS"
        case "Durability": v := "d"
        case "Misc" : v:= "m"
    }
    Loop, 20
    {
        GuiControl, Hide, % v A_Index
    }
}
ShowTab(Tab) {
    Switch Tab {
        case "Treadmill": v := "T"
        case "Weight": v := "W"
        case "StrikePower": v := "SP"
        case "StrikeSpeed": v := "SS"
        case "Durability": v := "d"
        case "Misc" : v := "m"
    }
    Loop, 20
    {
        GuiControl, Show, % v A_Index
    }
}

Treadmill:
    if !WinExist("Ahk_exe RobloxPlayerBeta.exe") {
        MsgBox,,Kiyoko's Macro,Roblox not active,3
        ExitApp
    }
    Notify("Starting Treadmill")
    Gui, Submit, Hide
    Gui, Destroy
    
    #maxThreadsPerHotkey, 2

SetPrimaryMonitorScaling(100) ; https://www.autohotkey.com/boards/viewtopic.php?t=94218
Sleep 100
SetPrimaryMonitorScaling(value) {
; possible values 100, 125, 150, 175, 200, 225, 250, 300, 350, 400, 450, 500
   static SPI_GETLOGICALDPIOVERRIDE := 0x009E
        , SPI_SETLOGICALDPIOVERRIDE := 0x009F
        , SPIF_UPDATEINIFILE := 0x00000001
        , MONITOR_DEFAULTTOPRIMARY := 0x00000001
        , ScaleValues := [100, 125, 150, 175, 200, 225, 250, 300, 350, 400, 450, 500]
        
   for k, v in ScaleValues
      if (value = v && found := true)
         break
   if !found
      throw "Incorrect value: " . value . ". Allowed values: 100, 125, 150, 175, 200, 225, 250, 300, 350, 400, 450, 500"
   if !DllCall("SystemParametersInfo", "UInt", SPI_GETLOGICALDPIOVERRIDE, "Int", 0, "IntP", v, "UInt", 0)
      throw "SPI_GETLOGICALDPIOVERRIDE unsupported"
   if !recommendedScaling := ScaleValues[ 1 - v ]
      throw "Something wrong"
   for k, v in ScaleValues {
      (v = value && s := k)
      (v = recommendedScaling && r := k)
   } until s && r
   if !DllCall("SystemParametersInfo", "UInt", SPI_SETLOGICALDPIOVERRIDE, "Int", s - r, "Ptr", 0, "UInt", SPIF_UPDATEINIFILE)
      throw "Failed to set new scale factor"
   hMon := DllCall("MonitorFromWindow", "Ptr", 0, "UInt", MONITOR_DEFAULTTOPRIMARY, "Ptr")
   DllCall("Shcore\GetScaleFactorForMonitor", "Ptr", hMon, "UIntP", scale)
   Return scale
}

IfNotExist, %A_ScriptDir%\bin\w.png
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
IfNotExist, %A_ScriptDir%\bin\a.png
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
IfNotExist, %A_ScriptDir%\bin\s.png
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
IfNotExist, %A_ScriptDir%\bin\d.png
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
IfNotExist, %A_ScriptDir%\bin
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
MsgBox, 4, Kiyoko - Stamina or RunningSpeed?, Press Yes for Stamina or No for RunningSpeed
IfMsgBox Yes
{
    tread = false
}
else
{
	tread = true
}

InputBox, level, Kiyoko - Treadmill Level, Please enter level., , 200, 150
if ErrorLevel = 1
{
	ExitApp
}

If not (level = "1" or level = "2" or level = "3" or level = "4" or level = "5")
{
    tooltip, Look like level %level% not exist in this version of macro
    SetTimer, removetooltip, -3000
    return
}

InputBox, logs, Kiyoko - Auto Leave, How many treads you want to do?`nEnter Number., , 400, 150

MsgBox, 4, Stamina Detection
IfMsgBox Yes
{
	detect = true
}
Else
{
	detect = false
}

if WinExist("Roblox") {
	WinActivate
}
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




removetooltip()
{
	ToolTip
}




macro_on := !macro_on
if (macro_on)
{	
	CoordMode , Pixel, Window
	slot = 1
	current = 0
	PixelGetColor , color2, 250, 130,
	Loop ,
	{	   
		CoordMode , Click, Window
		toolTip, %A_Index%
		SetTimer, removetooltip, -3000
		if tread = true ; rs
		{
			Click , 520, 310
			Click , 520, 311
			Sleep 1000
		}
		if tread = false ; stam
		{
			Click , 290, 310
			Click , 290, 311
			Sleep 1000
		}

		if level = 5
		{
			Click , 340, 370
			Click , 340, 371
			Sleep 200
		}
		if level = 4
		{
			Click , 340, 340
			Click , 340, 341
			Sleep 200
		}
		if level = 3
		{
			Click , 340, 310
			Click , 340, 311
			Sleep 200
		}
		if level = 2
		{
			Click , 340, 280
			Click , 340, 281
			Sleep 200
		}
		if level = 1
		{
			Click , 340, 250
			Click , 340, 251
			Sleep 200
		}
		Sleep 100
		Click , 410, 355
		Click , 410, 351
		Sleep 3000
		StartTime := A_TickCount
		Loop ,
		{			
			CoordMode , Pixel, Window
			CoordMode , Click, Window
			SetBatchLines, -1
			ImageSearch , FoundX, FoundY, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\w.png
			if (errorlevel = 0)
			{				
				Send {w down}{w up}
			}			
			ImageSearch , FoundX, FoundY, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\a.png
			if (errorlevel = 0)
			{				
				Send {a down}{a up}
			}			
			ImageSearch , FoundX, FoundY, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\s.png
			if (errorlevel = 0)
			{				
				Send {s down}{s up}
			}			
			ImageSearch , FoundX, FoundY, 200, 240, 600, 300, *50 %A_ScriptDir%\bin\d.png
			if (errorlevel = 0)
			{				
				Send {d down}{d up}
			}
			if detect = true
			{
				PixelSearch , x, y, 30, 130, 40, 133, 0x3A3A3A, 40, Fast
				If ErrorLevel = 0
				{				
					Sleep 8000
				}	
			}
		} Until A_TickCount - StartTime > 60000
		PixelSearch , x, y, 70, 144, 75, 146, 0x3A3A3A, 40, Fast
		If ErrorLevel = 0
		{
			if current <= 5
			{
                Loop,
                {
                    PixelSearch, x, y, 439, 455, 440, 456, 0x494995, 3, Fast
                    If ErrorLevel = 0
                    {
                        Sleep 100
                    }
                    else
                    {
                        Break
                    }
                }
                Sleep 100
				Send %slot%
				Click, 400, 610, 10
				Sleep 3500
				Send %slot%
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
		StartTime2 := A_TickCount
		Loop ,
		{			
			Click , 409, 296
			Click , 409, 295
		} Until A_TickCount - StartTime2 > 4000
			
		if A_Index = %logs%
		{			
			Send !{f4}
			ExitApp
		}		
		StartTime4 := A_TickCount
		Loop,
		{			
			Sleep 100
			PixelSearch , x, y, 249, 129, 250, 130, color2, , Fast
			If ErrorLevel = 0
			{				
				Break
			}		
		} Until A_TickCount - StartTime4 > 17000
	}
}
else
{	
	ExitApp
}
Return



Weight:
if !WinExist("Ahk_exe RobloxPlayerBeta.exe") {
        MsgBox,,Kiyoko's Macro,Roblox not active,3
        ExitApp
    }
    Gui, Submit, Hide
    Gui, Destroy
    IfNotExist, %A_ScriptDir%\bin\yellow.png
{
    msgbox,, file missing,Look like you didn't extract file,3
    ExitApp 
}
InputBox, level, Kiyoko - Weight Level, Please enter level., , 200, 150
if ErrorLevel = 1
{
	ExitApp
}

If not (level = "1" or level = "2" or level = "3" or level = "4" or level = "5" or level = "6")
{
    tooltip, Look like level %level% not exist in this version of macro
    SetTimer, removetooltip, -3000
    return
}
InputBox, logs, Kiyoko -  How many weight you want to do?, If u want to macro nonstop put text in here.
if ErrorLevel = 1
{	
    ExitApp
}
MsgBox, 4, Kiyoko - Auto Protein, Do you want to use protein? (Put it on Slot 0)
IfMsgBox Yes
{
	protein = true
}
Else
{
	protein = false
}
MsgBox, 4, Kiyoko - Stamina Detection, Do you want stamina detection? If yes then select.
IfMsgBox Yes
{
	stam = true
}
Else
{
	stam = false
}


#maxThreadsPerHotkey, 2
Loop, 3
{	
	CenterWindow("ahk_exe RobloxPlayerBeta.exe")
	Sleep 100
}
{
CenterWindow(WinTitle)
}
{	
	WinGetPos,,, Width, Height, %WinTitle%
	WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2), 400, 400
}
{
removetooltip()
}
{
    Tooltip
}
CoordMode, Pixel, Window
CoordMode, Mouse, Window
macro_on := !macro_on
if (macro_on)
{	bruh = 0
	CoordMode , Pixel, Window
	PixelGetColor , color2, 250, 134,
    Loop,
    {

		if protein = true
		{			
			temp++
			Sleep 100
			Click , 410, 455
			Sleep 100
			Send 0
			Sleep 50
			Send {Click 10}
			Sleep 8000
			Send 0
			StartTime7 := A_TickCount
			Loop ,
			{				
				Click, 400, 390
				Sleep 16
			} Until A_TickCount - StartTime7 > 2000
			if temp = 5
			{				
				protein = false
			}		
		}
		Loop, 3
		{
			toolTip, %A_Index%
			SetTimer, removetooltip, -3000
			if level = 6
			{
				Click , 340, 400 ; select level
				Click , 340, 401 ; select level
				Sleep 200
			}
			if level = 5
			{
				Click , 340, 370
				Click , 340, 371
				Sleep 200
			}
			if level = 4
			{
				Click , 340, 340
				Click , 340, 341
				Sleep 200
			}
			if level = 3
			{
				Click , 340, 310
				Click , 340, 311
				Sleep 200
			}
			if level = 2
			{
				Click , 340, 280
				Click , 340, 281
				Sleep 200
			}
			if level = 1
			{
				Click , 340, 250
				Click , 340, 251
				Sleep 200
			}
			Sleep 400
			Click , 410, 355 ; hand
			StartTime := A_TickCount
			Loop,
			{
				SetBatchLines, -1
				StartTime22 := A_TickCount
				ImageSearch, x , y , 250 , 220 , 560 , 440, *25 %A_ScriptDir%\bin\yellow.png
				if (errorlevel = 0)
				{
					ElapsedTime := A_TickCount - StartTime22
					MouseMove, x+5, y+5, 0
					MouseMove, x+5, y+6, 0
					Click, 5
					Sleep 70
					MouseMove, 400, 541, 0
					MouseMove, 400, 540, 0
					Sleep 20
					tooltip, %ElapsedTime% ms
					settimer, removetooltip, -300
				}
				If Stam = true
				{
					PixelSearch, x, y, 40, 132, 65, 134, 0x3A3A3A, 40, Fast
					if ErrorLevel = 0
					{
							Sleep 5000
					}
				}
					
			} Until A_TickCount - StartTime > 62000
			StartTime2 := A_TickCount
			Loop ,
			{				
				Click, 400, 390
				Click, 400, 391
			} Until A_TickCount - StartTime2 > 6000
			bruh++
			if bruh = %logs%
			{				
				Send !{f4}
				ExitApp
			} 
			StartTime4 := A_TickCount
			Loop,
			{				
				Sleep 100
				PixelSearch , x, y, 249, 133, 250, 134, color2, , Fast
				If ErrorLevel = 0
				{					
					Break
				}			
			} Until A_TickCount - StartTime4 > 7000
		}
    }
}
Else
{
    ExitApp
}
Return


SP:
    Gui, Submit, Hide
    Gui, Destroy
    CheckVars([SP2, SP4, SP6, SP8, SP10, SP12], "StrikePower")
    if (SP12 = "Video") {
        Gui, 3:Add, Text, y10,Record Key:
        Gui, 3:Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
        Gui, 3:Add, Button, ym gRecorder, Done
        Gui, 3:Add, Text, xm,Record Type:
        Gui, 3:Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
        Gui, 3:Show,, Kiyoko's Recording
        WinWaitClose, Kiyoko's Recording
    }
    if (SP6 = "Fatigue Estimate") {
        Inputbox, MaxRound, Enter Round,,, 300, 100
    }
    notify("Equip your combat")
    notify("and have shift lock on")
    notify("press k to continue")
    if WinExist("Ahk_exe RobloxPlayerBeta.exe") {
        WinActivate
        WinGetPos,,,W,H,A
        if ((W >= A_ScreenWidth) & (H >= A_ScreenHeight)) {
            Send, % sw("F11")
            Sleep, 1000
        }
        if ((W > 816) & ( H > 638)) {
            WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
            Notify("Resized Window")
        }
    } else {
        MsgBox,,Kiyoko's Macro,Roblox not active,3
        ExitApp
    }
    Winactive("Roblox")
    Pause
    global recordingtype := SP12
    Tagfunc := Func("Tag").Bind(List, SP10)
    SetTimer, %Tagfunc% , 1000
    Winactive("Roblox")
    Loop,
    {
        if WinExist("Ahk_exe RobloxPlayerBeta.exe") {
            WinActivate
            WinGetPos,,,W,H,A
            if ((W >= A_ScreenWidth) & (H >= A_ScreenHeight)) {
                Send, % sw("F11")
                Sleep, 1000
            }
            if ((W > 816) & ( H > 638)) {
                WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
                Notify("Resized Window")
            }
        } else {
            MsgBox,,Kiyoko's Macro,Roblox not active,3
            ExitApp
        }
        ImageSearch,,, 20, 120, 260, 140, *20 SugiPula\BasicUI\Stamina.bmp
        If (ErrorLevel = 0) {
            Sleep, 1000
            SendInput, % sw("s", "down")sw("w")sw("w", "down")
            Sleep, 8000
            Loop,
            {
                Switch SP8 {
                    case "Fast"     : ErrLevel := GetColors(145, 130, "0x3A3A3A", 40)
                    case "Medium"   : ErrLevel := GetColors(165, 130, "0x3A3A3A", 40)
                    case "Slow"     : ErrLevel := GetColors(185, 130, "0x3A3A3A", 40)
                }
                If (ErrLevel) {
                    SendInput, % sw("w", "up")sw("s", "up")sw("BackSpace")sw("1")
                    If (SP2 = "Rhythm") or (SP2 = "Flow") {
                        SetTimer, PressR, -400
                    }
                    Timer := A_TickCount, CheckTimer := A_TickCount
                    Break
                }
                ImageSearch,,, 20, 120, 260, 140, *20 SugiPula\BasicUI\Stamina.bmp
                If (ErrorLevel = 0) {
                    SendInput, % sw("w", "up")sw("s", "up")
                    Break
                }
            }
        } else {
            Notify("Freeze: " A_TickCount - CheckTimer)
            Notify("Reset: " A_TickCount - Timer)
            IniRead, allowed, settings.ini, Additional_Settings, SPFreeze
            If (allowed = "ERROR") or (!allowed) {
                IniWrite, "true", settings.ini, Additional_Settings, SPFreeze
            }
            If (A_TickCount - CheckTimer > 300000) and (allowed = "true") { ; 5 Minute
                ; Inf Stam
                Notify("Stam Freeze")
                Ping("Your Stamina Is Freezing / Been Hitting for over 5 Minute Straight Without Reset Stamina") Exit(SP10)
            }
            If (A_TickCount - Timer < 30000) { ; this is mean been hitting with over stamnina rate for 30 sec to restart run
                Click, 80
                Click, Right
                Round++
            } else {
                Loop,
                {
                    ImageSearch,,, 20, 120, 260, 140, *20 SugiPula\BasicUI\Stamina.bmp
                    If (ErrorLevel = 0) {
                        Break
                    }
                } 
            }
            Switch SP8 {
                case "Fast"     : ErrLevel := GetColors(145, 130, "0x3A3A3A", 40)
                case "Medium"   : ErrLevel := GetColors(165, 130, "0x3A3A3A", 40)
                case "Slow"     : ErrLevel := GetColors(185, 130, "0x3A3A3A", 40)
            }
            If (ErrLevel) {
                Timer := A_TickCount
            } else {
                CheckTimer := A_TickCount
            }
        }
        If (GetColors(35, 130, "0x3A3A3A", 40)) {
            Switch SP8 {
                case "Fast"     : Sleep, 6000
                case "Medium"   : Sleep, 7000
                case "Slow"     : Sleep, 8000
            }
            CheckTimer := A_TickCount, Timer := A_TickCount
        }
        If (SP6 = "Fatigue Estimate") {
            Notify("Auto Leave " Round "/" MaxRound)
            If (Round >= MaxRound) {
                Ping("max round has reached") Exit(SP10)
            }
        }
        If (SP4 != "Strave") {
            If (SP4 = "Scalar+Inventory") {
                i := "3-0"
                Notify("Searching for status")
                ImageSearch,,, 0, 145, 70, 170, *10 SugiPula\BasicUI\DrinkStatus2.bmp
                If (ErrorLevel = 1) {
                    Notify("status not found")
                    Sendinput, {BackSpace}2
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, SugiPula\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        notify("scalar has ranout from inventory")Ping("scalar Ranout, Continue Macroing")
                        SS4 := "Inventory"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop,
                        {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *10 SugiPula\BasicUI\DrinkStatus2.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("dranked scalar")
                        Sendinput, {BackSpace}1
                        If (SP2 = "Rhythm") or (SP2 = "Flow") {
                            SetTimer, PressR, -400
                        }
                    }
                }
            } else {
                i := "2-0"
            }
            ImageSearch,,, 40, 135, 50, 150, *30 SugiPula\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                SendInput, % sw("Shift")
                Switch Eat(i, SP4) {
                    Case "Empty" : Ping("Food Ranout") Exit(SP10)
                    Case "Timeout" : Ping("Eat Timeout") Exit(SP10)
                    Case "Success" : Sendinput, % sw("BackSpace")sw("1")
                }
                If (SP2 = "Rhythm") or (SP2 = "Flow") {
                    SetTimer, PressR, -400
                }
                SendInput, % sw("Shift")
                Timer := A_TickCount, CheckTimer := A_TickCount
            }
        }
        If (SP2 = "Flow") {
            ImageSearch,,, 390, 115, 430, 180, *10 SugiPula\BasicUI\flowstate.bmp
            If (ErrorLevel = 0) {
                Sendinput, % sw("t")
                Sleep 200
            }
        }
    }
Return

muscle:
    #MaxThreadsPerHotkey, 2
Loop, 3
{	
	CenterWindow("ahk_exe RobloxPlayerBeta.exe")
	Sleep 100
}
{
CenterWindow(WinTitle)
}
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

SS:
if !WinExist("Ahk_exe RobloxPlayerBeta.exe") {
        MsgBox,,Kiyoko's Macro,Roblox not active,3
        ExitApp
    }
Gui, Submit, Hide
Gui, Destroy
InputBox, logs, How many ss do you want to take?
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






Dura:
    Gui, Submit, Hide
    Gui, Destroy
    __Index__ := "Durability"
    CheckVars([d2, d4, d6, d8, d10, d12], "Durability")
    If (d6 = "Fatigue Estimate") {
        InputBox, MaxRound, Enter Round,,, 300 , 100
    }
    MsgBox, 262144,Kiyoko's Macro,Select account for left side
    IfMsgBox, Ok
    {
        Global LeftPID := Resize("Left")
    }
    MsgBox, 262144,Kiyoko's Macro,Select account for right side
    IfMsgBox, Ok
    {
        Global RightPID := Resize("Right")
    }
    MsgBox, 4,Kiyoko Auto Dura,both side are set correctly?
    IfMsgBox, No
    {
        Reload
    }
    If (d4 := "Rhythm") {
        f(LeftPID)
        SendInput, {Backspace}1 
        Sleep 400
        Sendinput, r
    }
    If (d12 := "Rhythm") {
        f(RightPID)
        SendInput, {Backspace}1 
        Sleep 400
        Sendinput, r
    }
    Loop
    {
        CoordMode, Mouse, Screen
        CoordMode, Pixel, Screen
        ImageSearch,,, 10, 90, 260, 120, *30 SugiPula\BasicUI\HPBar.bmp
        If (ErrorLevel = 0) {
            f(LeftPID)
            Sleep 3000
            ImageSearch,,, 50, 515, 735, 580, *30 *Trans0x00FF00 SugiPula\BasicUI\Dura.bmp
            If (ErrorLevel = 1) {
                Timer := A_TickCount
                Loop
                {
                    Sendinput, {Backspace}
                    Click, 50, 470, 20
                    ImageSearch,,, 50, 515, 735, 580, *30 *Trans0x00FF00 SugiPula\BasicUI\Dura.bmp
                    If (A_TickCount - Timer > 10000) {
                        Ping("can not buy durability") Exit(d8)
                    }
                } Until (ErrorLevel = 0)
                Sleep 1000
            }
            Switch DurabilityFunction(d10, "Left") {
                ; for catch errors
                case "Push" : Ping("you got pushed") Exit(d8)
            }
            Round++
            If (d6 = "Fatigue Estimate") {
                Notify("Auto Leave " Round "/" MaxRound)
                If (Round >= MaxRound) {
                    Ping("max round has reached") Exit(d8)
                }
            }
            f(LeftPID)
            Click, 50, 470, 30
            SendInput, {Backspace}1 
            Sleep 400
            If (d4 := "Rhythm") {
                Sendinput, r
            } 
        }
        CoordMode, Pixel, Window
        f(LeftPID)
        ImageSearch,,, 40, 135, 50, 150, *30 SugiPula\BasicUI\Hunger.bmp
        If (ErrorLevel = 0) {
            Switch Eat("3-0", "Inventory") {
                Case "Empty" : Ping("Food Ranout") Exit(d8)
                Case "Timeout" : Ping("Eat Timeout") Exit(d8)
                Case "Success" : {
                    Sendinput, % sw("BackSpace")sw("1")
                    Sleep 1000
                    If (d4 := "Rhythm") {
                        Sendinput, % sw("r")
                    } 
                }
                
            }
        }
        if (d2 = "Both") {
            CoordMode, Pixel, Screen
            ImageSearch,,, 810, 90, 1060, 120, *30 SugiPula\BasicUI\HPBar.bmp
            If (ErrorLevel = 0) {
                f(RightPID)
                Sleep 3000
                ImageSearch,,, 850, 515, 1535, 580, *30 *Trans0x00FF00 SugiPula\BasicUI\Dura.bmp
                If (ErrorLevel = 1) {
                    Timer := A_TickCount
                    Loop
                    {
                        Sendinput, % sw("BackSpace")
                        Click, 850, 470, 20
                        ImageSearch,,, 850, 515, 1535, 580, *30 *Trans0x00FF00 SugiPula\BasicUI\Dura.bmp
                        If (A_TickCount - Timer > 10000) {
                            Ping("can not buy durability") Exit(d8)
                        }
                    } Until (ErrorLevel = 0)
                    Sleep 1000
                }
                Switch DurabilityFunction(d10, "Right") {
                    ; for catch errors
                    case "Push" : Ping("you got pushed") Exit(d8)
                }
                Round++
                If (d6 = "Fatigue Estimate") {
                    Notify("Auto Leave " Round "/" MaxRound)
                    If (Round >= MaxRound) {
                        Ping("max round has reached") Exit(d8)
                    }
                }
                f(RightPID)
                Click, 850, 470, 30
                SendInput, % sw("Backspace")sw("1")
                Sleep 1000
                If (d12 := "Rhythm") {
                    Sendinput, % sw("r")
                } 
            }
            CoordMode, Pixel, Window
            f(RightPID)
            ImageSearch,,, 40, 135, 50, 150, *30 SugiPula\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Switch Eat("3-0", "Inventory") {
                    Case "Empty" : Ping("Food Ranout") Exit(d8)
                    Case "Timeout" : Ping("Eat Timeout") Exit(d8)
                    Case "Success" : {
                        Sendinput, % sw("BackSpace")sw("1")
                        Sleep 1000
                        If (d12 := "Rhythm") {
                            Sendinput, % sw("BackSpace")sw("1")
                        } 
                    }
                }
            }
        }
    }
Return

CheckforWebhook() {
    IniRead, Webhook, settings.ini, Notifications, Webhook
    IniRead, UserID, settings.ini, Notifications, UserID
    If (!Webhook) or (!UserID) or (UserID = "ERROR") or (Webhook = "ERROR") {
        return "Missing"
    }
    Switch GetUrlStatus(Webhook, 10) {
        case 200 : return "Working" 
        case "" : return "Error"
        case 0 : return "timedout"
    }
}
Ping(i) {
    IniRead, Webhook, settings.ini, Notifications, Webhook
    IniRead, UserID, settings.ini, Notifications, UserID
    If (!Webhook) or (!UserID) or (UserID = "ERROR") or (Webhook = "ERROR") {
        MsgBox,, Kiyoko's Macro, % i, 1
        Sleep, 100
        if WinExist("Ahk_exe RobloxPlayerBeta.exe") 
            WinActivate
        Return
    }
    If (GetUrlStatus(Webhook, 10) != 200) {
        IniDelete, settings.ini, Notifications , Webhook
        MsgBox,, Kiyoko's Macro, % i, 1
        Sleep, 100
        if WinExist("Ahk_exe RobloxPlayerBeta.exe") 
            WinActivate
        Return
    }
    static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    post=
    (
        {
            "username":"i love Kiyoko's macro",
            "content":"%UserID% %i%"
        }
    )
    whr.Open("POST", Webhook, False),whr.SetRequestHeader("Content-Type", "application/json"),whr.Send(post)
}

GetUrlStatus( URL, Timeout = -1 ) {
    ComObjError(0)
    static WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WinHttpReq.Open("HEAD", URL, True), WinHttpReq.Send(), WinHttpReq.WaitForResponse(Timeout)  
    Return, WinHttpReq.Status()
}

Eat(i, v) {
    CoordMode, Mouse, Window
    CoordMode, Pixel, Window
    Loop
    {
        Sendinput, % sw("BackSpace")
        Notify("Sending Between " i)
        Switch i {
            case "1-0" : item := "0,9,8,7,6,5,4,3,2,1"
            case "2-0" : item := "0,9,8,7,6,5,4,3,2"
            case "3-0" : item := "0,9,8,7,6,5,4,3"
            case "4-0" : item := "0,9,8,7,6,5,4"
        }
        Loop, Parse, item, `,
        {
            Sendinput, % sw(A_LoopField)
            Sleep, 150
        }
        ImageSearch,,, 65, 525, 750, 585, SugiPula\BasicUI\3x2.bmp
        If (ErrorLevel = 1) { 
            If (v = "Inventory") or (v = "Scalar+Inventory") or (v = "Protein+Inventory") {
                Sendinput, % sw("``")
                Sleep, 500
                Switch i {
                    case "1-0" : v := 95, var := 10
                    case "2-0" : v := 165, var := 9
                    case "3-0" : v := 235, var := 8
                    case "4-0" : v := 305, var := 7
                }
                Loop, %var%
                {
                    ImageSearch, x, y, 80, 190, 670, 500, SugiPula\BasicUI\x8.bmp
                    If (ErrorLevel = 0) {
                        Click, %x%, %y%, Down
                        Click, %v%, 555, Up
                        v := v + 70
                    } else if (ErrorLevel = 1) {
                        If (A_Index = 1) {
                            Sendinput, % sw("``")
                            Return "Empty"
                        }
                        Break
                    }
                }
                Sleep 100
                Sendinput, % sw("``")
                MouseMove, 100, 480 ; doesn't have return here to repeat selection again 
            } else {
                Return "Empty"
            }
        } else {
            Notify("Found Slot")
            Break
        }
    }
    EatingTask := A_TickCount
	Loop,
	{
		Click, 100, 480
        Sleep, 100
		ImageSearch,,, 65, 525, 750, 585, SugiPula\BasicUI\3x2.bmp
		If (ErrorLevel = 1) {
			Return "Success"
		}
		ImageSearch,,, 125, 135, 140, 150, *30 SugiPula\BasicUI\Hunger.bmp
		If (ErrorLevel = 1) { 
			Return "Success"
		}
	} Until (EatingTask - A_TickCount > 60000)
	Return "Timeout"
}

MOUSEOVER() {
    If (A_Gui != "2")
        Return
    WinGetPos, X, Y, W, H, Kiyoko's Status Window 
    WinGetPos,,,, _h_, ahk_class Shell_TrayWnd
    ArrayPosition := [(A_ScreenWidth)-(W),(A_ScreenHeight)-(H+_h_)]
    If ((X = ArrayPosition[1]) AND (Y = ArrayPosition[2]))
        ArrayPosition := [(W)-(W),(A_ScreenHeight)-(H+_h_)]
    WinMove, Kiyoko's Status Window,, ArrayPosition[1], ArrayPosition[2]
}

Tag(v = "", i = "") {
    ImageSearch,,, 20, 85, 170, 110, *20 SugiPula\BasicUI\combat.bmp
    if (ErrorLevel = 0) {
        SetTimer,, Off
        Notify("Found Combat Tag")
        Ping("You are attacked`, start avoiding enemies")
        if (recordingtype != "Do nothing") {
            if (GetColors(565, 90, "0xFFFFFF", 10)) {
                Sendinput, {Tab}
            }
            If (v = "Record") {
                Notify("Start Recording")
                IniRead, Key, settings.ini, Recording, KeyCombo
                If (Key = "Win+Alt+G") {
                    Send  % "#!" sw("g")
                } else {
                    Sendinput, % sw(Key)
                }
            }
            Sendinput, % sw("o","down")
            Sleep, 1500
            Sendinput, % sw("o","up")
            SoundPlay, SugiPula\Sound\broken.wav
            Mou(14, recordingtype)
            Click, 800, 120, down
            Click, 800, 248, up
            Mou(14, recordingtype)
            Click, 800, 248, down
            Click, 800, 376, up
            Mou(2, recordingtype)
            If (v = "ShadowPlay") {
                IniRead, Key, settings.ini, Recording, KeyCombo
                If (Key = "Win+Alt+G") {
                    Sendinput, % "#!" "{" sw("g")
                } else {
                    Sendinput, % sw(key)
                }
            }
        }
        Loop,
        { 
            If (GetColors(50, 130, "0x3A3A3A", 40)) {
                Loop, 5
                {
                    Evasive("Walk")
                }
            } else {
                Evasive("Sprint")
            }
            ImageSearch,,, 20, 85, 170, 110, *20 SugiPula\BasicUI\combat.bmp
            if (ErrorLevel = 1) {
                Sleep, 300
                ImageSearch,,, 20, 85, 170, 110, *20 SugiPula\BasicUI\combat.bmp
                if (ErrorLevel = 1) {
                    Break
                }
            }
        }
        Ping("Combat Tag is Gone") Exit(i)
    }
}

Evasive(Type) {
    Switch Type {
        Case "Walk" : {
            Notify("Walk")
            Button := ["up", "down", "left", "Space", "right"]
            Random, Direction, 1, 2
            Random, DirectionSide , 3, 5
            Notify(Button[Direction] "," Button[DirectionSide])
            Sendinput, % sw(Button[Direction],"down") sw(Button[DirectionSide],"down")
            Sleep, 2500
            Sendinput, % sw(Button[Direction],"up") sw(Button[DirectionSide],"up")
        }
        Case "Sprint" : {
            Notify("Sprint")
            Random, Action, 1, 2
            If (Action = 1) {
                Random, Direction, 1, 4
                Button := ["w", "a", "s", "d"]
                Notify(Button[Direction])
                Sendinput, % sw("Space","down") sw(Button[Direction],"down")
                Sleep, 50
                Sendinput, % sw("q") sw(Button[Direction],"up") sw("Space","up") 
                Sleep, 1000
            } else { 
                Button := ["Space", "left", "right"]
                Random, Direction, 1, 3
                Notify(Button[Direction])
                SendInput, % sw("w") sw("w","down") sw(Button[Direction],"down")  
                Sleep, 2500
                SendInput, % sw("w","up") sw(Button[Direction],"up")  
                Sleep, 100
            }
        }
    }
}
Mou(i, v) {
    Base = 120
    Loop, %i%
    {
        MouseMove, 575, Base
        If (v = "Screenshot") {
            SendInput, {PrintScreen}
        }
        Base := Base + 30
        Sleep, 200
    }
}
Recorder:
    Gui, 3:Submit, Hide
    Gui, 3:Destroy
    If (!KeyCombo) or (!List) {
        MsgBox,,Kiyoko's Macro, Missing Infomation, Please Enter Record Key and Record Type
        ExitApp
    } else {
        IniWrite, %KeyCombo%, settings.ini, Recording, Key
        IniWrite, %List%, settings.ini, Recording, Type
    }
Return
Saver:
    Gui, 4:Submit, Hide
    Gui, 4:Destroy
Return
Saved:
    Gui, Submit, Hide
    Gui, Destroy
Return
Exit(i) {
    CoordMode, Pixel, Window
    Sleep 1000
    global __Index__
    Switch __Index__ {
        case "Durability" : {
            Switch i {
                case "Exit Roblox" : {
                    f(LeftPID)
                    Loop,
                    {
                        ImageSearch,,, 20, 85, 170, 110, *20 SugiPula\BasicUI\combat.bmp
                    } Until (ErrorLevel = 1)
                    Process, Close, % LeftPID
                    f(RightPID)
                    Loop,
                    {
                        ImageSearch,,, 20, 85, 170, 110, *20 SugiPula\BasicUI\combat.bmp
                    } Until (ErrorLevel = 1)
                    Process, Close, % RightPID
                }
                case "Shutdown" : { 
                    Ping("Shutting Down Comuputer")
                    Shutdown, 5
                }
            }
        }
        case "Basic" : {
            Switch i {
                case "Exit Roblox": {
                    Loop,
                    {
                        ImageSearch,,, 20, 85, 170, 110, *20 SugiPulaBasicUI\combat.bmp
                    } Until (ErrorLevel = 1)
                    Process, Close, RobloxPlayerBeta.exe
                    Ping("succesfully logged")
                } 
                case "Shutdown" : { 
                    Ping("Shutting Down Comuputer")
                    Shutdown, 5
                }
            }
        }
    }
    Sleep 5000
    Ping("macro has been stopped")
    Sleep 5000
    ExitApp
}
GetLine(Text, var) {
    StringReplace, Text, Text, % var, % var, UseErrorLevel
    Return ( ( (var = "`n" || var = "`r") && (Text) ) ? ErrorLevel + 1 : ErrorLevel )
}
CheckVars(i, type) {
    for _, v in i {
        if (!v) {
            MsgBox,,Viavce's Macro, Missing infomation %v% is missing
            ExitApp
        }
        Item .= v ","
    }
    StringTrimRight, Item, Item, 1
    IniWrite, %Item%, settings.ini, Data, %type%
}

sw(key, state = "") {
    return "{" . format("sc{:x}", getKeySC(key)) " " . state . "}"
}
DurabilityFunction(i, v) {
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    Switch v {
        case "Left" : f(LeftPID)
        case "Right" : f(RightPID)
    }
    Notify("Activating Dura")
    Sendinput, 2
    Sleep 1000
    StartDuraTimer := A_TickCount
    Switch v {
        case "Left" : {
            Click, 50, 470
            Sleep 500
            Notify("Activated Left Screen Dura")
            f(RightPID) 
        }
        case "Right" : {
            Click, 850, 470
            Sleep 500
            Notify("Activated Right Screen Dura")
            f(LeftPID)
        }
    }
    Notify("Activated Durability")
    Curr := "Full", ColorsID := "0x444444, 0x3D3DA2"
    OuterLoop:
    Loop,
    {
        If (A_TickCount - StartDuraTimer > 26000) {
            Notify("Took > 26 Secconds")
            Break
        }
        Switch v {
            case "Left" : Click, 850, 470
            case "Right" : Click, 50, 470
        }
        Switch Curr {
            case "Full" : Sleep, 200
            case "Half" : Sleep, 400
            case "Low"  : Sleep, 600
        }
        Y1 := 105, Y2 := 106
        Switch v {
            case "Left" : {
                Switch Curr {
                    case "Full" : X1 := 130, X2 := 131
                    case "Half" : X1 := 70, X2 := 71
                    case "Low" : X1 := 30, X2 := 31
                }
            }
            case "Right" : {
                Switch Curr {
                    case "Full" : X1 := 930, X2 := 931
                    case "Half" : X1 := 870, X2 := 871
                    case "Low" : X1 := 830, X2 := 831          
                }
            }
        }
        If (i != "None") {
            X1 := X1 + 20
            X2 := X2 + 20
        }
        Loop, Parse, ColorsID, `,
        {
            If (GetColors(X2, Y2, A_LoopField, 30)) {
                Switch Curr {
                    case "Full" : Curr := "Half"
                    case "Half" : Curr := "Low"
                    case "Low" : Break OuterLoop
                }
                Notify("Current Phase " Curr " for" v)
                Break
            }
        }
    }
    Switch v {
        case "Left" : f(LeftPID)
        case "Right" : f(RightPID)
    }
    Sleep 500
    Switch v {
        case "Left" : {
            ImageSearch,,, 10, 90, 260, 120, *30 SugiPula\BasicUI\HPBar.bmp
            If (ErrorLevel = 0) {
                Return "Push"
            }
            Click, 50, 470, 10
        }
        case "Right" : {
            ImageSearch,,, 810, 90, 1060, 120, *30 SugiPula\BasicUI\HPBar.bmp
            If (ErrorLevel = 0) {
                Return "Push"
            }
            Click, 850, 470, 10
        }
    }
    Notify("Finished Durability")
}

Resize(i) {
    ; Make it return PID and place ui in specific position
    WinActive("Roblox")
    Switch i {
        case "Left" : WinMove, Roblox,, (0)-(10), (0)-(10), 100, 100
        case "Right" : WinMove, Roblox,, (0)-(-790), (0)-(10), 100, 100
    }
    WinGet, v, PID, Roblox
    Return v
}

f(i) {
    WinActivate, ahk_pid %i%
    Sleep 100
}
GuiClose:
    ExitApp
Return
runmacro:
    gui, Destroy
    IniRead, i, settings.ini, Data, AutoRun
    gui, add, ddl, ym vv1,run|strave|strave+knock|burnfat
    if (i != "ERROR") or (!i) {
        GuiControl, ChooseString, v1, %i% 
    }
    gui, add, button, ym gSaved, Start
    gui, show,, Kiyoko's Stam Macro 
    WinWaitClose, Kiyoko's Stam Macro
    CheckVars([v1], "AutoRun")
    WinActive("Roblox")
    MouseMove, 409, 491
    Loop
    {
        if WinExist("Ahk_exe RobloxPlayerBeta.exe") {
            WinActivate
            WinGetPos,,,W,H,A
            if ((W >= A_ScreenWidth) & (H >= A_ScreenHeight)) {
                Send, % sw("F11")
                Sleep, 1000
            }
            if ((W > 816) & ( H > 638)) {
                WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
                Notify("Resized Window")
            }
        } else {
            MsgBox,,Kiyoko's Macro,Roblox not active,3
            ExitApp
        }
        switch v1 {
            case "run" : {
                SendInput, % sw("w")sw("w", "down")
                Sleep 4000
                SendInput, % sw("w", "up")
                If (GetColors(35, 130, "0x3A3A3A", 40)) {
                    Notify("Wait, 10000")
                    Sleep 10000
                }
                ImageSearch,,, 40, 135, 50, 150, *30 SugiPula\BasicUI\Hunger.bmp
                If (ErrorLevel = 0) {
                    Switch Eat("1-0", "Inventory") {
                        Case "Empty" : Ping("Food Ranout") ExitApp
                        Case "Timeout" : Ping("Eat Timeout") ExitApp
                        Case "Success" : Sendinput, % sw("BackSpace")
                    }
                }
            }
            case "strave+knock" : {
                SendInput, % sw("down","down")sw("w")sw("w", "down")
                Sleep 4000
                SendInput, % sw("w", "up")sw("down","up")
            }
            case "strave" : {
                SendInput, % sw("down","down")sw("w")sw("w", "down")
                Sleep 4000
                SendInput, % sw("w", "up")sw("down","up")
                ImageSearch,,, 40, 135, 50, 150, *30 SugiPula\BasicUI\Hunger.bmp
                If (ErrorLevel = 0) {
                    Switch Eat("1-0", "Inventory") {
                        Case "Empty" : Ping("Food Ranout") ExitApp
                        Case "Timeout" : Ping("Eat Timeout") ExitApp
                        Case "Success" : Sendinput, % sw("BackSpace")
                    }
                }
            }
            case "burnfat" : {
                SendInput, % sw("down","down")sw("w")sw("w", "down")
                Sleep, 4000
                SendInput, % sw("w", "up")sw("down","up")
                If (GetColors(35, 130, "0x3A3A3A", 40)) {
                    Notify("Wait, 10000")
                    Sleep, 10000
                }
                ImageSearch,,, 0, 145, 70, 170, *10 SugiPula\BasicUI\DrinkStatus3.bmp
                If (ErrorLevel = 1) {
                    Notify("status not found")
                    Sendinput, {Backspace}1
                    Sleep, 150
                    ImageSearch,,, 65, 525, 750, 585, SugiPula\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        notify("fatburner has ranout from inventory")
                        Ping("fatburner Ranout, Continue Macroing")
                        v1 := "run"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop,
                        {
                            Sleep, 100
                            ImageSearch,,, 0, 145, 70, 170, *10 SugiPula\BasicUI\DrinkStatus3.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("dranked fatburner")
                        Sendinput, {BackSpace}
                    }
                }
            }
        }
    }
Return

PressR:
    Sendinput, % sw("r")
Return

GetColors(x, y, target, tolerance) {
    PixelGetColor, OutputVar, %x%, %y% , Alt RGB
    tr := format("{:d}","0x" . substr(target,3,2)),tg := format("{:d}","0x" . substr(target,5,2)), tb := format("{:d}","0x" . substr(target,7,2))
    pr := format("{:d}","0x" . substr(OutputVar,3,2)),pg := format("{:d}","0x" . substr(OutputVar,5,2)),pb := format("{:d}","0x" . substr(OutputVar,7,2))
    distance := sqrt((tr-pr)**2+(tg-pg)**2+(pb-tb)**2)
    if (distance<tolerance)
        return true
    return false
}
