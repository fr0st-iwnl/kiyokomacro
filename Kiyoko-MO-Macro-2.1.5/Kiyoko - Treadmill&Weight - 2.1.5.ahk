#NoEnv
#SingleInstance, force
SetCapsLockState, Off 
SetBatchLines -1
SoundPlay, Weight&Treadmill\Sound\on.wav
Version = 2.1.5 Updated
if (A_ScreenDPI != 96) {
    Run, ms-settings:display
    MsgBox,	16,Kiyoko's Macro, Your Scale `& layout settings need to be on 100`%
    ExitApp
}
If !FileExist("Weight&Treadmill") {
    MsgBox, the data file "Weight&Treadmill" folder is missing`nExtract file.
    ExitApp
}
global __Index__ := "Basic"
Gui, Color, 404040, Font, cBlack
Gui, 2:Font, c665200,
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
                MsgBox,,Kiyoko's Macro, Failed to connect to server`, Please make sure the link is correct and try again.
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
                post={"username":"i love kiyoko's macro","content":"%UserID% helo"}
                whr.Open("POST", Webhook, False),whr.SetRequestHeader("Content-Type", "application/json"),whr.Send(post)
                Notify("Posted")
                MsgBox,4, Kiyoko's Macro, Do you get Ping? / Is it Correctly Ping Your Name
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
    case "Error" : MsgBox,,Kiyoko's Macro, Failed to connect to server`, Please make sure the link is correct and try again.
    case "timedout" : MsgBox,,Kiyoko's Macro, this site can't be reached, took too long to respond.
}
Gui,+AlwaysOnTop -DPIScale -Caption +LastFound
Gui, Font, cBlack ,Consolas
Gui, Font, ce6b800
Gui, Color, 404040, Font, cBlack, ,Consolas
Gui, Add, Text,x35 y10 w600 h50 +BackgroundTrans Center gMove, Version: %Version%  Version: %A_AhkVersion%
Gui, Add, Text,ym xm,Kiyoko's Macro
Gui, Add, GroupBox, xm ym+20 w30 h260
Gui, Add, GroupBox, xm+50 ym+20 w411 h260 vTitle, Home
Gui, Add, Text, xm+10 ym+40 gBack, K
Gui, Add, Picture,w27 h30 xm+2 ym+65          gTabTreadmill, Weight&Treadmill\Icon&Menu\treadmill.png
Gui, Add, Picture,w27 h30 xm+2 ym+98          gTabWeight, Weight&Treadmill\Icon&Menu\weight.png
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vT1            ,Pick a stat to focus. 
Gui, Add, DDL, w150 ym+20 xm     vT2            ,Stamina|Running Speed
Gui, Add, Text,ym+45 xm          vT3            ,Choose level to focus.  
Gui, Add, DDL, w150 ym+65 xm     vT4            ,5|4|3|2|1|All
Gui, Add, Text,ym+90 xm          vT5            ,Choose method for eating 
Gui, Add, DDL, w150 ym+110 xm    vT6            ,1-0|Strave
Gui, Add, Text, ym+135 xm        vT7            ,Duration Settings      
Gui, Add, DDL, ym+155 xm w150    vT8            ,Macro Indefinitely|Fatigue Estimate
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vT9            ,Pick Stamina Amount  
Gui, Add, DDL, ym+20 xm w150     vT10           ,High 1k+|Medium 600-1k|Low >600|Do nothing
Gui, Add, Text,ym+45 xm          vT11           ,Leave Settings
Gui, Add, DDL, ym+65 xm w150     vT12           ,Exit Roblox|Shutdown|Do nothing
Gui, Add, Text, ym+90 xm         vT13           ,Clip Username
Gui, Add, DDL, ym+110 xm w150    vT14           ,Video|Screenshot|Do nothing
Gui, Add, Text, ym+135 xm        vT15           ,Extra Gain
Gui, Add, DDL, ym+155 xm w150    vT16           ,SetStartDelay|SetWaitDelay|Both|Do nothing
Gui, Add, Button, x356 y250      vT18 gTreadmill,Done
Gui, Add, Text, ym+200 xm-200      vT19         ,- Put card on 0
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vW1            ,Choose level to focus. 
Gui, Add, DDL, w150 ym+20 xm     vW2            ,6|5|4|3|2|1|All
Gui, Add, Text,ym+45 xm          vW3            ,Choose method for eating 
Gui, Add, DDL, w150 ym+65 xm     vW4            ,1-0|Protein+Inventory|Strave 
Gui, Add, Text,ym+90 xm          vW5            ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vW6            ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text, ym+135 xm        vW7            ,Pick Stamina Amount  
Gui, Add, DDL, ym+155 xm w150    vW8            ,High 1k+|Medium 600-1k|Low >600|Do nothing
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vW9            ,Leave Setting
Gui, Add, DDL, ym+20 xm w150     vW10           ,Exit Roblox|Shutdown|Do nothing
Gui, Add, Text,ym+45 xm          vW11           ,Clip Username
Gui, Add, DDL, ym+65 xm w150     vW12           ,Video|Screenshot|Do nothing
Gui, Add, Button, x356 y250      vW13  gWeight  ,Done
Gui, Add, Text, ym+200 xm-230      vW14         ,- Put card on 0
Gui, Add, Text, ym+185 xm-230      vW15         ,- For Protein+Inventory center ur camera.
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
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vSS1           ,Training Gym
Gui, Add, DDL, w150 ym+20 xm     vSS2           ,Kung fu|Kure|Taekwondo|Karate|Capoeira|Muay Thai|Advance Brawl|Boxing
Gui, Add, Text,ym+45 xm          vSS3           ,Walking Path  
Gui, Add, DDL, w150 ym+65 xm     vSS4           ,Default|Custom
Gui, Add, Text,ym+90 xm          vSS5           ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vSS6           ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text, ym+135 xm        vSS7           ,Choose method for eating 
Gui, Add, DDL, ym+155 xm w150    vSS8           ,Inventory|3-0|Scalar+Inventory|Strave
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vSS9           ,Leave Setting
Gui, Add, DDL, ym+20 xm w150     vSS10          ,Exit Roblox|Shutdown|Do nothing
Gui, Add, Text,ym+45 xm          vSS11          ,Clip Username
Gui, Add, DDL, ym+65 xm w150     vSS12          ,Video|Screenshot|Do nothing
Gui, Add, Button, x356 y250      vSS14   gSS    ,Done
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vd1            ,which side to dura
Gui, Add, DDL, w150 ym+20 xm     vd2            ,Left|Both
Gui, Add, Text,ym+45 xm          vd3            ,Left side options
Gui, Add, DDL, w150 ym+65 xm     vd4            ,Rhythm|Do nothing
Gui, Add, Text,ym+90 xm          vd5            ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vd6            ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text,ym+135 xm         vd7            ,Leave Setting 
Gui, Add, DDL, w150 ym+155 xm    vd8            ,Exit Roblox|Shutdown|Do nothing
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vd9            ,Slow hp detection
Gui, Add, DDL, ym+20 xm w150     vd10           ,Left|Both|Right|None
Gui, Add, Text,ym+45 xm          vd11           ,Right side options
Gui, Add, DDL, w150 ym+65 xm     vd12           ,Rhythm|Do nothing
Gui, Add, Button, x356 y250      vd15  gDura    ,Done
Gui, Margin, 80, 50
Gui, Add, Text, ym xm vm1 , Push up, Squat Macro
Gui, Add, Button, ym+20 xm vm2 w70 gmuscle, Start 
Gui, Add, Text, ym+45 xm vm3 , Basic Run Macro
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
    CheckVars([T2, T4, T6, T8, T10, T12, T14, T16], "Treadmill")
    If (T14 = "Video") {
        Gui, 3:Add, Text, y10,Record Key:
        Gui, 3:Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
        Gui, 3:Add, Button, ym gRecorder, Done
        Gui, 3:Add, Text, xm,Record Type:
        Gui, 3:Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
        Gui, 3:Show,, Kiyoko's Recording
        WinWaitClose, Kiyoko's Recording
    }
    If (T8 = "Fatigue Estimate") {
        InputBox, MaxRound, Enter Round,,, 300 , 100
    }
    If (T16 = "SetStartDelay") or (T16 = "Both") or (T16 = "SetWaitDelay") {
        If (T16 = "SetStartDelay") {
            Gui, 4:Add, Text, y10,Start Delay:
            Gui, 4:Add, Edit, Number ym w120 vStartDelay, 0
        }
        If (T16 = "SetWaitDelay") {
            Gui, 4:Add, Text, xm  ,Wait Delay:
            Gui, 4:Add, Edit, Number ym w120 vDelay1, 9000
        } else If (T16 = "Both") {
            Gui, 4:Add, Text, y10,Start Delay:
            Gui, 4:Add, Edit, Number ym w120 vStartDelay, 0
            Gui, 4:Add, Text, xm,Wait Delay:
            Gui, 4:Add, Edit, Number  x75 y30 w120 vDelay1, 9000
        }
        Gui, 4:Add, Button, ym gSaver, Done
        Gui, 4:Show,, Kiyoko's ExtraGain
        WinWaitClose, Kiyoko's ExtraGain
    } else {
        Delay1 := 9000
    }
    if (!Delay1) {
        Delay1 := 9000
    }
    global recordingtype := T14
    Tagfunc := Func("Tag").Bind(List, T12)
    SetTimer, %Tagfunc% , 1000
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
        Notify("Searching Stamina Bar")
        Loop
        {
            ImageSearch,,, 20, 120, 260, 140, *20 Weight&Treadmill\BasicUI\Stamina.bmp
        } Until (ErrorLevel = 0)
        Notify("Found Stamina Bar")
        Switch T2 {
            case "Stamina": Click, 290, 310, 20
            case "Running Speed":  Click, 520, 310, 20
        }
        Notify("Clicked, " T2)
        Wait := A_TickCount
        Loop 
        {
            If (GetColors(350, 250, "0x5A5A5A", 30)) {
                Break
            }
        } Until (A_TickCount - Wait > 1000)
        Wait := A_TickCount
        Loop,
        {
            If (GetColors(410, 355, "0x98FF79", 10)) {
                Loop,
                {
                    Sleep 200
                    Click, 412, 355, 20
                    If (!GetColors(410, 355, "0x98FF79", 10)) {
                        Break
                    }
                }
                Notify("Found Hand")
                Break
            }
            Switch T4 {
                Case "All": {
                    x := 370
                    Loop, 5
                    {
                        Click, 460, %x%, 20
                        x:=x-30
                        Sleep, 200
                    }
                }
                Case "5": Click, 460, 370, 20
                Case "4": Click, 460, 340, 20
                Case "3": Click, 460, 310, 20
                Case "2": Click, 460, 280, 20
                Case "1": Click, 460, 250, 20
            }
            If (A_TickCount - Wait > 10000) {
                Ping("not able to locate the hand icon")Exit(T12)
            } 
        }
        Click, 410, 355, 20
        Notify("Clicked, " T4)
        Sleep, 2000
        Button := "w,a,s,d", TreadmillTask := A_TickCount
        If (T16 = "SetStartDelay") or (T16 = "Both") {
            Notify("Wait, " StartDelay)
            Sleep, % StartDelay
        }
        i=0
        Loop,
        {
            Loop, Parse, Button, `,
            {
                ImageSearch,,, 200, 240, 600, 300, *50 Weight&Treadmill\TrainingIcon\%A_LoopField%.bmp
                If (ErrorLevel = 0) {
                    Sendinput, % sw(A_LoopField)
                    i++
                    Notify("Send, " A_LoopField " , " i)
                    Break
                }
            }
            Switch T10 {
                case "High 1k+": ErrLevel := GetColors(30, 130, "0x3A3A3A", 40)
                case "Medium 600-1k": ErrLevel := GetColors(40, 130, "0x3A3A3A", 40) 
                case "Low >600": ErrLevel := GetColors(50, 130, "0x3A3A3A", 40)
            }
            If (ErrLevel) {
                If (T10 != "Do nothing") {
                    Notify("Wait, " Delay1)
                    Now := A_TickCount
                    Loop,
                    {
                        If (A_TickCount - TreadmillTask > 55000)
                            Click, 400, 390
                    } Until (A_TickCount - Now > Delay1)
                }
            }
            If (A_TickCount - TreadmillTask > 55000)
                Click, 400, 290
        } Until (A_TickCount - TreadmillTask > 65000)
        Round++
        Notify("Fisnished Tread #" Round)
        If (T6 != "Strave") {
            ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Sleep, 2000
                Click, 410, 345
                Sleep, 1000
                Switch Eat("1-0", T6) {
                    Case "Empty" : Ping("Food Ranout") Exit(T12)
                    Case "Timeout" : Ping("Eat Timeout") Exit(T12)
                    Case "Success" : 
                    Send, 0
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                    Send, 0
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                }
                UpTreadmill := A_TickCount
                Loop,
                {			
                    Click , 409, 296
                    Click , 409, 295
                } Until (A_TickCount - UpTreadmill > 1500)
            }
        }
        If (T8 = "Fatigue Estimate") {
            Notify("Auto Leave " Round "/" MaxRound)
            If (Round >= MaxRound) {
                Ping("max round has reached") Exit(T12)
            }
        }
    }
Return

Weight:
    Gui, Submit, Hide
    Gui, Destroy
    CheckVars([W2, W4, W6, W8, W10, W12], "Weight")
    If (W12 = "Video") {
        Gui, 3:Add, Text, y10,Record Key:
        Gui, 3:Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
        Gui, 3:Add, Button, ym gRecorder, Done
        Gui, 3:Add, Text, xm,Record Type:
        Gui, 3:Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
        Gui, 3:Show,, Kiyoko's Recording
        WinWaitClose, Kiyoko's Recording
    }
    global recordingtype := W12
    Tagfunc := Func("Tag").Bind(List, W10)
    SetTimer, %Tagfunc%, 1000
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
        Loop
        {
            ImageSearch,,, 20, 120, 260, 140, *20 Weight&Treadmill\BasicUI\Stamina.bmp
        } Until (ErrorLevel = 0)
        Wait := A_TickCount
        Loop,
        {
            PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30
            If (ErrorLevel = 0) {
                Break
            }
            Switch W2 {
                Case "All": {
                    x := 400
                    Loop, 6
                    {
                        Click, 460, %x%, 20
                        x:=x-30
                        Sleep, 200
                    }
                }
                Case "6": Click, 460, 400, 20
                Case "5": Click, 460, 370, 20
                Case "4": Click, 460, 340, 20
                Case "3": Click, 460, 310, 20
                Case "2": Click, 460, 280, 20
                Case "1": Click, 460, 250, 20
            }
            If (A_TickCount - Wait > 10000) {
                Ping("not able to locate the hand icon")Exit(W10)
            }
        }
        Click, 410, 355, 20
        MouseMove, 409, 491
        Timer := A_TickCount
        Loop,
        {
            ImageSearch,x, y, 250, 220, 570, 470, *20 Weight&Treadmill\TrainingIcon\WeightButton.bmp
            If (ErrorLevel = 0) {
                MouseMove, x, y, 0
                MouseMove, x+1, y+1, 0
                Click, 10
                MouseMove, 409, 491
            }
            Switch W8 {
                case "High 1k+": PixelSearch ,,, 30, 130, 36, 133, 0x3A3A3A, 40
                case "Medium 600-1k": PixelSearch ,,, 30, 130, 46, 133, 0x3A3A3A, 40  
                case "Low >600": PixelSearch ,,, 30, 130, 56, 133, 0x3A3A3A, 40
            }
            If (ErrorLevel = 0) {
                If (W8 != "Do nothing") {
                    Notify("Wait, 7000")
                    Now := A_TickCount
                    Loop,
                    {
                        If (A_TickCount - Timer > 55000)
                            Click , 409, 491
                    } Until (A_TickCount - Now > 7000)
                }
            }
            If (A_TickCount - Timer > 55000) {
                Click , 409, 490
                Click , 409, 491
            }
        } Until (A_TickCount - Timer > 65000)
        Round++
        If (W4 = "Inventory") or (W4 = "1-0") or (W4 = "Protein+Inventory") {
            If (W4 = "Protein+Inventory") {
                i := "2-0"
                Notify("Searching for status")
                ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus1.bmp
                If (ErrorLevel = 1) {
                    Notify("status not found")
                    Sleep, 2000
                    Click, 410, 460
                    Sleep, 1000
                    Sendinput, {1}1
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, Weight&Treadmill\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        W4 := "Inventory"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus1.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("dranked protein")
                        Sendinput, {1}
                        UpWeight := A_TickCount
                        Loop,
                        {			
                            Click , 409, 490
                            Click , 409, 491
                        } Until A_TickCount - UpWeight > 1500
                    }
                }
            } else {
                i := "2-0"
            }
            ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Sleep, 2000
                Click, 410, 460
                Sleep, 1000
                Switch Eat(i, W4) {
                    Case "Empty" : Ping("Food Ranout") Exit(W10)
                    Case "Timeout" : Ping("Eat Timeout") Exit(W10)
                    Case "Success" : 
                    Send, 0
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                    Send, 0
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                }
                UpWeight := A_TickCount
                Loop,
                {			
                    Click , 409, 490
                    Click , 409, 491
                } Until A_TickCount - UpWeight > 1500
            }
        }
        If (W6 = "Fatigue Estimate") {
            If (Round >= MaxRound) {
                Ping("max round has reached") Exit(W10)
            }
        }
    }
Return

SP:
    Gui, Submit, Hide
    Gui, Destroy
    global Shiftlock = "on"
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
        ImageSearch,,, 20, 120, 260, 140, *20 Weight&Treadmill\BasicUI\Stamina.bmp
        If (ErrorLevel = 0) {
            Sleep, 1000
            SendInput, % sw("Space", "down")sw("Space", "up")sw("s", "down")sw("w")sw("w", "down")
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
                ImageSearch,,, 20, 120, 260, 140, *20 Weight&Treadmill\BasicUI\Stamina.bmp
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
                    ImageSearch,,, 20, 120, 260, 140, *20 Weight&Treadmill\BasicUI\Stamina.bmp
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
                ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus2.bmp
                If (ErrorLevel = 1) {
                    Notify("status not found")
                    Sendinput, {BackSpace}2
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, Weight&Treadmill\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        notify("scalar has ranout from inventory")Ping("scalar Ranout, Continue Macroing")
                        SS4 := "Inventory"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop,
                        {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus2.bmp
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
            ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
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
            ImageSearch,,, 390, 115, 430, 180, *10 Weight&Treadmill\BasicUI\flowstate.bmp
            If (ErrorLevel = 0) {
                Sendinput, % sw("t")
                Sleep 200
            }
        }
    }
Return
muscle:
    Gui, Destroy
    Gui, Add, GroupBox, xm ym w211 h260 , Muscle Macro
    Gui, Margin, 20, 30
    Gui, Add, Text, ym xm,Click Interval : Miliseconds
    Gui, Add, Edit, ym+20 xm w150 vv1, 
    Gui, Add, Text, ym+45 xm,Choose method for eating 
    Gui, Add, DDL, w150 ym+65 xm vv2,Inventory|2-0|Strave
    Gui, Add, Text, ym+90 xm ,Duration Settings      
    Gui, Add, DDL, ym+110 xm w150 vv3,Macro Indefinitely|Fatigue Estimate
    Gui, Add, Text,ym+135 xm ,Leave Settings
    Gui, Add, DDL, ym+155 xm w150 vv4,Exit Roblox|Shutdown|Do nothing
    Gui, Add, Button, ym+180 xm w70 gSaved, Start
    IniRead, Muscle, settings.ini, Data, Muscle
    for Item, Value in {"v": Muscle} {
        If (Value != "ERROR") {
            Loop, Parse, Value, `,
            {
                v := Item A_Index
                If (A_Index = 1) {
                    GuiControl,, %v%, %A_LoopField%
                } else {
                    GuiControl, ChooseString, %v%, %A_LoopField%
                }
            }
        }
    }
    Gui, Show, ,Kiyoko's Muscle Macro
    WinWaitClose, Kiyoko's Muscle Macro
    CheckVars([v1,v2,v3,v4], "Muscle")
    If (v3 = "Fatigue Estimate") {
        InputBox, EndTime, Enter Time
        If (ErrorLevel = 1) {
            Msgbox, Missing infomation
            ExitApp
        }
        Timer := A_TickCount
    }
    WinActivate, Ahk_exe RobloxPlayerBeta.exe
    Sendinput, % sw("BackSpace")sw("1")
    CoordMode, Pixel, Window
    CoordMode, Mouse, Window
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
        If (v3 = "Fatigue Estimate") {
            If (A_TickCount - Timer > EndTime) {
                Ping("Sucessfully Macro") Exit(v4)
            }
        }
        Click, 65, 470
        Notify("Wait " v1 " " A_Index)
        Sleep % v1
        If (GetColors(65, 130, "0x3A3A3A", 40)) {
            lllll := A_TickCount
            Notify("Low Stam")
            Loop,
            {
                ImageSearch,,, 20, 120, 260, 140, *20 Weight&Treadmill\BasicUI\Stamina.bmp
                If (ErrorLevel = 0) {
                    Break
                }
                Sleep 1000
            } Until (A_TickCount - lllll > 20000)
        }
        ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
        If (ErrorLevel = 0) {
            Sendinput, % sw("BackSpace")
            Switch Eat("2-0", v2) {
                Case "Empty" : Ping("Food Ranout") Exit(v4)
                Case "Timeout" : Ping("Eat Timeout") Exit(v4)
                Case "Success" : {
                    Sendinput, % sw("BackSpace")sw("1")
                }
            }
        }
    }
Return
SS:
    Gui, Submit, Hide
    Gui, Destroy
    CheckVars([SS2, SS4, SS6, SS8, SS10, SS12], "StrikeSpeed")
    Switch SS2 {
        case "Karate" : path1 := 960, path2 := 660
        case "Boxing" : path1 := 820, path2 := 580
        case "Capoeira" : path1 := 1300, path2 := 80
        case "Muay Thai" : path1 := 1100
        case "Advance Brawl" : path1 := 1800
    }
    If (SS4 = "Custom") {
        if (path1) {
            InputBox, path1, Kiyoko's Macro,%SS2% 1st Custom Walk Distance (Default: %path1%ms),, 400, 130
            if (ErrorLevel = 1) {
                MsgBox,,Kiyoko's Macro, Missing infomation 
                ExitApp
            }
        }
        if (path2) {
            InputBox, path2, Kiyoko's Macro,%SS2% 2nd Custom Walk Distance (Default: %path2%ms),, 400, 130
            If (ErrorLevel = 1) {
                MsgBox,,Kiyoko's Macro, Missing infomation 
                ExitApp
            }
        }
    }
    If (SS6 = "Fatigue Estimate") {
        InputBox, MaxRound, Enter Round,,, 300 , 100
    }
    Notify("Place your mouse at Strike Speed")
    Notify("then press K")
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
    Pause
    MouseGetPos, mousex, mousey
    global recordingtype := SS12
    Tagfunc := Func("Tag").Bind(List, SS10)
    SetTimer, %Tagfunc% , 1000
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
        ImageSearch,,, 60, 525, 750, 590, *40 Weight&Treadmill\BasicUI\Speed.bmp
        If (ErrorLevel = 0) {
            Timer := A_TickCount, Error := 0
            Switch SS2 {
                case "Karate" : Sendinput, % sw("Shift")sw("d", "down")
                case "Boxing" : Sendinput, % sw("Shift")sw("d", "down")
                case "Muay Thai" : Sendinput, % sw("Shift")sw("w", "down")
                case "Advance Brawl" : Sendinput, % sw("Shift")sw("d", "down")
                case "Capoeira" : Sendinput, % sw("s", "down")
            }
            Sleep, % path1
            Switch SS2 {
                case "Karate" : Sendinput, % sw("d", "up")sw("w", "down")
                case "Boxing" : Sendinput, % sw("d", "up")sw("w", "down")
                case "Muay Thai" : Sendinput, % sw("w", "up")sw("Shift")
                case "Advance Brawl" : Sendinput, % sw("d", "up")sw("Shift")
                case "Capoeira" : Sendinput, % sw("s", "up")sw("d", "down")
            }
            Sleep, % path2
            Switch SS2 {
                case "Karate" : Sendinput, % sw("w", "up")sw("Shift")
                case "Boxing" : Sendinput, % sw("w", "up")sw("Shift")
                case "Capoeira" : Sendinput, % sw("d", "up")
            }
            if (SS2 = "Karate") or (SS2 = "Boxing") or (SS2 = "Muay Thai") or (SS2 = "Advance Brawl") {
                global Shiftlock = "on"
            }
            Sendinput, % sw("Backspace")sw("2")
            Sleep 100
            Click
            Sleep 3000
            Sendinput, % sw("1")
            TimerN := A_TickCount
            Loop,
            {
                Loop, 4
                {
                    Click, %mousex%, %mousey%
                    IniRead, Tick, settings.ini, Additional_Settings, SSM1DELAY
                    If (Tick = "ERROR") or (!Tick) {
                        Tick = 960
                        IniWrite, 960, settings.ini, Additional_Settings, SSM1DELAY
                    }
                    Sleep, % Tick
                }
                Sleep 100
                Click, %mousex%, %mousey%, Right
                Sleep 1000
                ImageSearch,,, 65, 525, 750, 585, *40 Weight&Treadmill\BasicUI\Speed.bmp
                If (A_TickCount- TimerN > 60000) {
                    Ping("you got pushed / taking longer time than usual") Exit(SS10)
                }
            } Until (ErrorLevel = 1) 
            Sendinput, % sw("1")
            Switch SS2 {
                case "Karate" : Sendinput, % sw("Shift")sw("s", "down")
                case "Boxing" : Sendinput, % sw("Shift")sw("s", "down")
                case "Capoeira" : Sendinput, % sw("a", "down")
            }
            Sleep, % path2
            Switch SS2 {
                case "Karate" : Sendinput, % sw("s", "up")sw("a", "down")
                case "Boxing" : Sendinput, % sw("s", "up")sw("a", "down")
                case "Advance Brawl" : Sendinput, % sw("Shift")sw("a", "down")
                case "Capoeira" : Sendinput, % sw("a", "up")sw("w", "down")
                case "Muay Thai" : Sendinput, % sw("Shift")sw("s", "down")
            }
            Sleep, % path1
            Switch SS2 {
                case "Muay Thai" : Sendinput, % sw("s", "up")sw("Shift")
                case "Advance Brawl" : Sendinput, % sw("a", "up")sw("Shift")
                case "Karate" : Sendinput, % sw("a", "up")sw("Shift")
                case "Boxing" : Sendinput, % sw("a", "up")sw("Shift")
                case "Capoeira" : Sendinput, % sw("w", "up")
            }
            if (SS2 = "Karate") or (SS2 = "Boxing") or (SS2 = "Muay Thai") or (SS2 = "Advance Brawl") {
                global Shiftlock = "off"
            }
            TimeTotal := A_TickCount - Timer
            Round++
            If (SS6 = "Fatigue Estimate") {
                Notify("Auto Leave " Round "/" MaxRound)
                If (Round >= MaxRound) {
                    Ping("max round has reached") Exit(SS10)
                }
            } else {
                Notify("Fisnished Session #"Round)
            }
        } else {
            Sendinput % sw("Backspace")
            Click, %mousex%, %mousey%, 30
            Sleep 100
            Error++
            If (Error > 10) {
                Ping("you got pushed / ss not found") Exit(SS10)
            }
        }
        If (SS8 = "Scalar+Inventory") or (SS8 = "Inventory") or (SS8 = "3-0") {
            If (SS8 = "Scalar+Inventory") {
                i := "4-0"
                Notify("Searching for status")
                ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus2.bmp
                If (ErrorLevel = 1) {
                    Notify("status not found")
                    Sendinput, {BackSpace}3
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, Weight&Treadmill\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        notify("scalar has ranout from inventory")Ping("scalar Ranout, Continue Macroing")
                        SS8 := "Inventory"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop,
                        {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus2.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("dranked scalar")
                        Sendinput, {BackSpace}
                    }
                }
            } else {
                i := "3-0"
            }
            ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Sendinput, {BackSpace}
                Switch Eat(i, SS8) {
                    Case "Empty" : Ping("Food Ranout") Exit(SS10)
                    Case "Timeout" : Ping("Eat Timeout") Exit(SS10)
                    Case "Success" : Sendinput, % sw("BackSpace")
                }
            }
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
        ImageSearch,,, 10, 90, 260, 120, *30 Weight&Treadmill\BasicUI\HPBar.bmp
        If (ErrorLevel = 0) {
            f(LeftPID)
            Sleep 3000
            ImageSearch,,, 50, 515, 735, 580, *30 *Trans0x00FF00 Weight&Treadmill\BasicUI\Dura.bmp
            If (ErrorLevel = 1) {
                Timer := A_TickCount
                Loop
                {
                    Sendinput, {Backspace}
                    Click, 50, 470, 20
                    ImageSearch,,, 50, 515, 735, 580, *30 *Trans0x00FF00 Weight&Treadmill\BasicUI\Dura.bmp
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
        ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
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
            ImageSearch,,, 860, 90, 1060, 120, *30 Weight&Treadmill\BasicUI\HPBar.bmp
            If (ErrorLevel = 0) {
                f(RightPID)
                Sleep 3000
                ImageSearch,,, 850, 515, 1200, 544, *30 *Trans0x00FF00 Weight&Treadmill\BasicUI\Dura.bmp
                If (ErrorLevel = 1) {
                    Timer := A_TickCount
                    Loop
                    {
                        Sendinput, % sw("BackSpace")
                        Click, 850, 470, 20
                        ImageSearch,,, 850, 515, 1200, 544, *30 *Trans0x00FF00 Weight&Treadmill\BasicUI\Dura.bmp
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
            ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
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
            "username":"i love kiyoko's macro",
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
        ImageSearch,,, 65, 525, 750, 585, Weight&Treadmill\BasicUI\3x2.bmp
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
                    ImageSearch, x, y, 80, 190, 670, 500, Weight&Treadmill\BasicUI\x8.bmp
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
		ImageSearch,,, 65, 525, 750, 585, Weight&Treadmill\BasicUI\3x2.bmp
		If (ErrorLevel = 1) {
			Return "Success"
		}
		ImageSearch,,, 125, 135, 140, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
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
    global Shiftlock
    ImageSearch,,, 20, 85, 170, 110, *20 Weight&Treadmill\BasicUI\combat.bmp
    if (ErrorLevel = 0) {
        SetTimer,, Off
        Notify("Found Combat Tag")
        Ping("You are attacked`, start avoiding enemies")
        if (Shiftlock = "on") {
            Sleep 300
            Sendinput, % sw("Shift")
            Notify("Shiftlock was on")
            Sleep 300
        }
        if (recordingtype != "Do nothing") {
            if (!GetColors(565, 90, "0xFFFFFF", 10)) {
                Sendinput, % sw("tab")
            }
            If (v = "Record") {
                Notify("Start Recording")
                IniRead, Key, settings.ini, Recording, Key
                If (Key = "Win+Alt+G") {
                    Send, % "#!" sw("g")
                } else {
                    Send, % sw(key)
                }
            }
            Sendinput, % sw("o","down")
            Sleep, 1500
            Sendinput, % sw("o","up")
            SoundPlay, Weight&Treadmill\Sound\broken.wav
            MouseMove, 575, 120
            Loop, 20
            {
               Send {WheelUp 10}
            }
            Mou(14, recordingtype)
            Click, 800, 120, down
            Click, 800, 248, up
            Mou(14, recordingtype)
            Click, 800, 248, down
            Click, 800, 376, up
            Mou(2, recordingtype)
            If (v = "ShadowPlay") {
                Notify("Start Shadow Play")
                IniRead, Key, settings.ini, Recording, Key
                If (Key = "Win+Alt+G") {
                    Send, % "#!" "{" sw("g")
                } else {
                    Send, % sw(key)
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
            ImageSearch,,, 20, 85, 170, 110, *20 Weight&Treadmill\BasicUI\combat.bmp
            if (ErrorLevel = 1) {
                Sleep, 300
                ImageSearch,,, 20, 85, 170, 110, *20 Weight&Treadmill\BasicUI\combat.bmp
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
                        ImageSearch,,, 20, 85, 170, 110, *20 Weight&Treadmill\BasicUI\combat.bmp
                    } Until (ErrorLevel = 1)
                    Process, Close, % LeftPID
                    f(RightPID)
                    Loop,
                    {
                        ImageSearch,,, 20, 85, 170, 110, *20 Weight&Treadmill\BasicUI\combat.bmp
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
                        ImageSearch,,, 20, 85, 170, 110, *20 Weight&Treadmill\BasicUI\combat.bmp
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
            MsgBox,,Kiyoko's Macro, Missing infomation %v% is missing
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
                    case "Half" : X1 := 90, X2 := 91
                    case "Low" : X1 := 70, X2 := 71
                }
            }
            case "Right" : {
                Switch Curr {
                    case "Full" : X1 := 930, X2 := 931
                    case "Half" : X1 := 870, X2 := 871
                    case "Low" : X1 := 860, X2 := 861          
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
            ImageSearch,,, 10, 90, 260, 120, *30 Weight&Treadmill\BasicUI\HPBar.bmp
            If (ErrorLevel = 0) {
                Return "Push"
            }
            Click, 50, 470, 10
        }
        case "Right" : {
            ImageSearch,,, 810, 90, 1060, 120, *30 Weight&Treadmill\BasicUI\HPBar.bmp
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
                ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
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
                ImageSearch,,, 40, 135, 50, 150, *30 Weight&Treadmill\BasicUI\Hunger.bmp
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
                ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus3.bmp
                If (ErrorLevel = 1) {
                    Notify("status not found")
                    Sendinput, {Backspace}1
                    Sleep, 150
                    ImageSearch,,, 65, 525, 750, 585, Weight&Treadmill\BasicUI\3x2.bmp
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
                            ImageSearch,,, 0, 145, 70, 170, *10 Weight&Treadmill\BasicUI\DrinkStatus3.bmp
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
    PixelGetColor, OutputVar, x, y
    tr := format("{:d}","0x" . substr(target,3,2)),tg := format("{:d}","0x" . substr(target,5,2)), tb := format("{:d}","0x" . substr(target,7,2))
    pr := format("{:d}","0x" . substr(OutputVar,3,2)),pg := format("{:d}","0x" . substr(OutputVar,5,2)),pb := format("{:d}","0x" . substr(OutputVar,7,2))
    distance := sqrt((tr-pr)**2+(tg-pg)**2+(pb-tb)**2)
    if (distance<tolerance)
        return true
    return false
}








