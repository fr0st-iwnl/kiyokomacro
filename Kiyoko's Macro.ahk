#NoEnv
#SingleInstance, force
SetCapsLockState, Off 
SetBatchLines -1
Version = 4.1
if (A_ScreenDPI != 96) {
    Run, ms-settings:display
    MsgBox,	16,Kiyoko's Macro, Your Scale `& layout settings need to be on 100`%
    ExitApp
}
if !FileExist(A_ScriptDir "\Icons") {
    MsgBox, the data file "Icons" folder is missing`nExtract file.
    ExitApp
}
SoundPlay, Icons\Sound\plug.mp3
Menu, Tray, Icon, %A_ScriptDir%\Icons\Menu\KM.png

; -------------------------------------------------
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://pastebin.com/raw/17UJ9SH1", False), whr.Send(), whr.WaitForResponse()
v := whr.ResponseText

if (v > Version) {
    MsgBox, 51, Update Check, A new version of Kiyoko's Macro is available.`n`Current Version: %Version%`nLatest Version: %v%`n`Visit Download Page?
    IfMsgBox, Yes
    {
        Run, https://github.com/fr0st-iwnl/kiyokomacro/releases
    }
} else if (v < Version) {
}
global __Index__ := "Basic"
Gui, 2:Font, cBlack, Consolas
Gui, 2:Font, CBlack, Consolas
Gui, 2:+AlwaysOnTop -Caption
Gui, 2:Add, Text,xm-8 ym,Kiyoko's Macro J to Exit K to Pause
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
                MsgBox,,Kiyoko's Macro, Failed to connect to the server`, Please make sure the link is correct and try again.
                Msgbox, 4, Kiyoko's Macro, Do you want to disable webhook and Continue the macro?
                IfMsgBox, Yes
                {
                    IniDelete, settings.ini, Notifications , Webhook
                    IniDelete, settings.ini, Notifications , UserID
                } else {
                    ExitApp
                }
            } else {
                whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
                post={"username":"KM | Kiyoko's Macro","avatar_url":"https://raw.githubusercontent.com/fr0st-iwnl/assets/main/thumbnails/kiyokowebhooklogo.png", "content":"%UserID% helo"}
                whr.Open("POST", Webhook, False),whr.SetRequestHeader("Content-Type", "application/json"),whr.Send(post)
                Notify("Posted")
                MsgBox,4, Kiyoko's Macro, Have you got the ping? / Is that ur name?
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
Gui, Font, cBlack, Consolas
; Gui, Color, 800000, Font, cBlack, ,Consolas
Gui, Add, Text,x15 y10 w650 h50 +BackgroundTrans Center gMove, Version: %Version%  AHK Version: %A_AhkVersion%
Gui, Add, Text,ym xm,Kiyoko's Macro
Gui, Add, GroupBox, xm ym+20 w40 h260
Gui, Add, GroupBox, xm+50 ym+20 w411 h260 vTitle, % Chr(0x1F3E1) " Home"
Gui, Add, Picture, w27 h27 xm+6 ym+40 gTabDura, Icons\Menu\dura.png
Gui, Add, Picture,w27 h31 xm+6 ym+80          gTabSP, Icons\Menu\sp.png
Gui, Add, Picture,w27 h27 xm+6 ym+120         gTabSS, Icons\Menu\ss.png
Gui, Add, Picture,w27 h27 xm+6 ym+160         gTabTreadmill, Icons\Menu\treadmill.png
Gui, Add, Picture,w27 h27 xm+6 ym+200         gTabWeight, Icons\Menu\bench.png
Gui, Add, Picture,w24 h24 xm+8 ym+240        gTaball41, Icons\Menu\misc.png
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vT1            ,Focused Stat 
Gui, Add, DDL, w150 ym+20 xm     vT2            ,Stamina|Running Speed
Gui, Add, Text,ym+45 xm          vT3            ,Focused Level  
Gui, Add, DDL, w150 ym+65 xm     vT4            ,5|4|3|2|1|All
Gui, Add, Text,ym+90 xm          vT5            ,Eating Method 
Gui, Add, DDL, w150 ym+110 xm    vT6            ,1-0|Starve
Gui, Add, Text, ym+135 xm        vT7            ,Duration Settings      
Gui, Add, DDL, ym+155 xm w150    vT8            ,Macro Indefinitely|Fatigue Estimate
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vT9            ,Stamina Amount  
Gui, Add, DDL, ym+20 xm w150     vT10           ,High 1k+|Medium 600-1k|Low >600|Do Nothing
Gui, Add, Text,ym+45 xm          vT11           ,Leave Settings
Gui, Add, DDL, ym+65 xm w150     vT12           ,Exit Roblox|Shutdown|Do Nothing
Gui, Add, Text, ym+90 xm         vT13           ,Clip Username
Gui, Add, DDL, ym+110 xm w150    vT14           ,Video|Screenshot|Do Nothing
Gui, Add, Text, ym+135 xm        vT15           ,Extra Gain
Gui, Add, DDL, ym+155 xm w150    vT16           ,SetStartDelay|SetWaitDelay|Both|Do Nothing
Gui, Add, Text,ym+180 xm-220     vT17          ,Image Send
Gui, Add, DDL, ym+200 xm-220 w150   vT18          ,Yes|No
; Gui, Add, Text, ym+200 xm-210    vT19         ,- Put card on 0
Gui, Add, Button, w100 x356 y250      vT20 gTreadmill,Done
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vW1            ,Focused Level
Gui, Add, DDL, w150 ym+20 xm     vW2            ,6|5|4|3|2|1|All
Gui, Add, Text,ym+45 xm          vW3            ,Eating Method 
Gui, Add, DDL, w150 ym+65 xm     vW4            ,2-0|Protein+Inventory|Starve
Gui, Add, Text,ym+90 xm          vW5            ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vW6            ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text, ym+135 xm        vW7            ,Stamina Amount  
Gui, Add, DDL, ym+155 xm w150    vW8            ,High 1k+|Medium 600-1k|Low >600|Do Nothing
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vW9            ,Leave Settings
Gui, Add, DDL, ym+20 xm w150     vW10           ,Exit Roblox|Shutdown|Do Nothing
Gui, Add, Text,ym+45 xm          vW11           ,Clip Username
Gui, Add, DDL, ym+65 xm w150     vW12           ,Video|Screenshot|Do Nothing
Gui, Add, Text, ym+200 xm-210    vW13        ,- Put card on 0
Gui, Add, Button, w100 x356 y250 vW14  gWeight  ,Done
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vSP1           ,Rhythm
Gui, Add, DDL, w150 ym+20 xm     vSP2           ,Do Nothing|Rhythm|Flow
Gui, Add, Text,ym+45 xm          vSP3           ,Eating Method
Gui, Add, DDL, w150 ym+65 xm     vSP4           ,2-0|Inventory|Scalar+Inventory|Starve
Gui, Add, Text,ym+90 xm          vSP5           ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vSP6           ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text, ym+135 xm        vSP7           ,Stamina Regen Method  
Gui, Add, DDL, ym+155 xm w150    vSP8           ,Super Fast|Fast|Medium|Slow
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vSP9           ,Leave Settings
Gui, Add, DDL, ym+20 xm w150     vSP10          ,Exit Roblox|Shutdown|Do Nothing
Gui, Add, Text,ym+45 xm          vSP11          ,Clip Username
Gui, Add, DDL, ym+65 xm w150     vSP12          ,Video|Screenshot|Do Nothing
Gui, Add, Text,ym+90 xm          vSP13          ,Eating Preferences
Gui, Add, DDL, ym+110 xm w150     vSP14          ,20|50
Gui, Add, Text,ym+135 xm          vSP15          ,Image Send
Gui, Add, DDL, ym+155 xm w150     vSP16          ,Yes|No
Gui, Add, Button, w100 x356 y250      vSP17   gSP    ,Done
Gui, Add, Text,ym+190 xm-230             vSP18      ,- Equip combat when u start the macro !
; Gui, Add, Text,ym+182 xm-230             vSP17      ,- If ur stamina freezes pick a better stamina regen that fits urs.
; Gui, Add, Text,ym+200 xm-230             vSP18      ,- If not disable stamina freeze from settings.ini
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vSS1           ,Training Gym
Gui, Add, DDL, w150 ym+20 xm     vSS2           ,Kung Fu|Kure Style|Taekwondo|Karate|Capoeira|Muay Thai|Advanced Brawl|Boxing
Gui, Add, Text,ym+45 xm          vSS3           ,Walking Path  
Gui, Add, DDL, w150 ym+65 xm     vSS4           ,Default|Custom
Gui, Add, Text,ym+90 xm          vSS5           ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vSS6           ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text, ym+135 xm        vSS7           ,Eating Method
Gui, Add, DDL, ym+155 xm w150    vSS8           ,Inventory|3-0|Scalar+Inventory|Starve
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vSS9           ,Leave Settings
Gui, Add, DDL, ym+20 xm w150     vSS10          ,Exit Roblox|Shutdown|Do Nothing
Gui, Add, Text,ym+45 xm          vSS11          ,Clip Username
Gui, Add, DDL, ym+65 xm w150     vSS12          ,Video|Screenshot|Do Nothing
Gui, Add, Button, w100 x356 y250      vSS14   gSS    ,Done
Gui, Margin, 80, 50
Gui, Add, Text,ym xm             vd1            ,Dura Side
Gui, Add, DDL, w150 ym+20 xm     vd2            ,Left|Both
Gui, Add, Text,ym+45 xm          vd3            ,Left Side Options
Gui, Add, DDL, w150 ym+65 xm     vd4            ,Rhythm|Do Nothing
Gui, Add, Text,ym+90 xm          vd5            ,Duration Settings  
Gui, Add, DDL, w150 ym+110 xm    vd6            ,Macro Indefinitely|Fatigue Estimate
Gui, Add, Text,ym+135 xm         vd7            ,Leave Settings 
Gui, Add, DDL, w150 ym+155 xm    vd8            ,Exit Roblox|Shutdown|Do Nothing
Gui, Margin, 300, 50
Gui, Add, Text,ym xm             vd9            ,Slow HP Detection
Gui, Add, DDL, ym+20 xm w150     vd10           ,Left|Both|Right|None
Gui, Add, Text,ym+45 xm          vd11           ,Right Side Options
Gui, Add, DDL, w150 ym+65 xm     vd12           ,Rhythm|Do Nothing
Gui, Add, Text,ym+110 xm-20             vd13     ,- Buy the durability first.
Gui, Add, Button, w100 x356 y250      vd15  gDura    ,Done
Gui, Margin, 80, 50
Gui, Add, Text, ym xm vm1 , Push up - Squat Macro
Gui, Add, Button, ym+20 xm vm2 w70 gmuscle, Start 
Gui, Add, Text, ym+55 xm vm3 , Basic Run Macro
Gui, Add, Button, ym+75 xm vm4 w70 grunmacro, Start
Gui, Add, Text, ym+115 xm vm5 , SS M1 Delay
Gui, Add, Button, ym+135 xm vm6 w70 gSSM1DelayChange, Change
Gui, Add, Text, ym xm+250 vm7 , Webhook
Gui, Add, Button, ym+20 xm+248 vm8 w70 gChangeWebhook, Change
Gui, Add, Text, ym+55 xm+250 vm9 , UserID
Gui, Add, Button, ym+75 xm+248 vm10 w70 gChangeUserID, Change
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
~j::ExitApp
Move:
    PostMessage, 0xA1, 2
Return
Back:
    GuiControl,, title, % Chr(0x1F3E0) " Home"
    Notify("Displaying Home Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabTreadmill:
    GuiControl,, title, % Chr(0x1F3C3) " Treadmill Tab"
    ShowTab("Treadmill")
    Notify("Displaying Treadmill Tab")
    HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabWeight:
    GuiControl,, title, % Chr(0x1F3CB) . Chr(0x200D) " Weight Tab"
    ShowTab("Weight")
    Notify("Displaying Weight Tab")
    HideTab("Treadmill") HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabSP:
    GuiControl,, title, % Chr(0x1F44A) " Strike Power Tab"
    ShowTab("StrikePower")
    Notify("Displaying StrikePower Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikeSpeed")HideTab("Durability")HideTab("Misc")
Return
TabSS:
    GuiControl,, title, % Chr(0x1F94A) " Strike Speed Tab"
    ShowTab("StrikeSpeed")
    Notify("Displaying StrikeSpeed Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("Durability")HideTab("Misc")
Return
TabDura:
    GuiControl,, title, % Chr(0x1F6E1) " Durability Tab"
    ShowTab("Durability")
    Notify("Displaying Durability Tab")
    HideTab("Treadmill")HideTab("Weight")HideTab("StrikePower")HideTab("StrikeSpeed")HideTab("Misc")
Return
Taball41:
    GuiControl,, title, % Chr(0x1F9F0) " Miscellaneous Tab"
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
    CheckVars([T2, T4, T6, T8, T10, T12, T14, T16, T18], "Treadmill")
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
            ImageSearch,,, 20, 120, 260, 140, *20 Icons\BasicUI\Stamina.bmp
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
                Ping("Waited 10 seconds. Unable to locate the hand icon. Macro stopped.")Exit(T12)
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
                ImageSearch,,, 250, 240, 600, 300, *50 Icons\TrainingIcon\%A_LoopField%.bmp
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
        Notify("Finished Tread #" Round)
        If (T6 != "Starve") {
            ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Sleep, 2000 ; treadmill leave
                Click, 410, 345
                Sleep, 1000 ; treadmill sleep after leave
                Switch Eat("1-0", T6) {
                    Case "Empty" : Ping("Food Ran Out") Exit(T12)
                    Case "Timeout" : Ping("Eat Timeout") Exit(T12)
                    Case "Success" :
                    If (T18 = "Yes") {
                    IniRead, Webhook, settings.ini, Notifications, Webhook
                    If (Webhook = "")
                    {
                        MsgBox, Error: You need to set your webhook or the image send will not work.
                        Return
                    }
                    Else
                    {
                        sendinput, {PrintScreen}
                        Sleep, 1000
                        gosub,ImageSend
                    }
                }
                    If (T18 = "No"){
                    ; do something else
                    }

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
            If (T8 = "Fatigue Estimate") {
                Message("Treadmill - ***Round # ***" Round)
                }
            If (Round >= MaxRound) {
                Ping("Max round has reached") Exit(T12)
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
    If (W6 = "Fatigue Estimate") {
        InputBox, MaxRound, Enter Round,,, 300 , 100
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
            ImageSearch,,, 20, 120, 260, 140, *20 Icons\BasicUI\Stamina.bmp
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
            If (A_TickCount - Wait > 30000) {
                Ping("Waited 30 seconds. Unable to locate the hand icon. Macro stopped.")Exit(W10)
            }
        }
        Click, 410, 355, 20
        MouseMove, 409, 491
        Timer := A_TickCount
        Loop,
        {
            SetControlDelay -1
            ImageSearch,x, y, 250, 220, 570, 470, *25 Icons\TrainingIcon\WeightButton.bmp
            If (ErrorLevel = 0) {
                MouseMove, x, y, 0
                MouseMove, x+1, y+1, 0
                Click, %x%, %y%
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
        If (W4 = "Inventory") or (W4 = "2-0") or (W4 = "Protein+Inventory") {
            If (W4 = "Protein+Inventory") {
                i := "2-0"
                Notify("Searching for status")
                ImageSearch,,, 0, 145, 70, 170, *10 Icons\BasicUI\DrinkStatus1.bmp
                If (ErrorLevel = 1) {
                    Sleep, 2000
                    Click, 410, 460
                    Sleep, 1000
                    Sendinput, {1}1
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, Icons\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) {
                        Ping("Protein ran out. Switching to 2-0")
                        Notify("Switching to 2-0") 
                        W4 := "2-0"
                        Loop,
                        {			
                            Click , 409, 490
                            Click , 409, 491
                        } Until A_TickCount - UpWeight > 1500
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *10 Icons\BasicUI\DrinkStatus1.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("Drank protein")
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
            ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Sleep, 2000
                Click, 410, 460
                Sleep, 1000
                Switch Eat("2-0", W4) {
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
            If (W6 = "Fatigue Estimate") {
                Message("Weight - ***Round # ***" Round)
                }
            If (Round >= MaxRound) {
                Ping("Max round has reached") Exit(W10)
            }
        }
    }
Return

SP:
    Gui, Submit, Hide
    Gui, Destroy
    global Shiftlock = "on"
    CheckVars([SP2, SP4, SP6, SP8, SP10, SP12, SP14, SP16], "StrikePower")
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
    notify("And have SHIFT LOCK On.")
    notify("Press on K to continue")
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
    global recordingtype := SP12
    Tagfunc := Func("Tag").Bind(List, SP10)
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
        ImageSearch,,, 20, 120, 260, 140, *20 Icons\BasicUI\Stamina.bmp
        If (ErrorLevel = 0) {
            Sleep, 1000
            SendInput, % sw("w")
            Sleep, 85
            SendInput, % sw("s", "down")sw("w", "down")
            Sleep, 7000
            Loop,
            {
                Switch SP8 {
                    case "Super Fast"     : ErrLevel := GetColors(125, 130, "0x3A3A3A", 40)
                    case "Fast"     : ErrLevel := GetColors(145, 130, "0x3A3A3A", 40)
                    case "Medium"   : ErrLevel := GetColors(165, 130, "0x3A3A3A", 40)
                    case "Slow"     : ErrLevel := GetColors(185, 130, "0x3A3A3A", 40)
                }
                If (ErrLevel) {
                    SendInput, % sw("w", "up")sw("s", "up")sw("1")sw("1")
                    If (SP2 = "Rhythm") or (SP2 = "Flow") {
                        SetTimer, PressR, -400
                        Message("*Macro is gaining Rhythm.*")
                    }
                    Timer := A_TickCount, CheckTimer := A_TickCount
                    Break
                }
                ImageSearch,,, 20, 120, 260, 140, *20 Icons\BasicUI\Stamina.bmp
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
                Ping("Your Stamina Is Freezing / Been Hitting for over 5 Minute Straight Without Reset Stamina / Choose a better stamina regen that works for ur stamina") Exit(SP10)
            }
                Click, 160
                Click, Right
                Round++
            PixelSearch, x, y, 50, 132, 51, 134, 0x3A3A3A, 40, Fast 
            If (ErrorLevel = 0) { 
                Sleep, 8000
            }
            
            Switch SP8 {
                case "Super Fast"     : ErrLevel := GetColors(125, 130, "0x3A3A3A", 40)
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
                case "Super Fast"     : Sleep, 5000
                case "Fast"     : Sleep, 6000
                case "Medium"   : Sleep, 7000
                case "Slow"     : Sleep, 8000
            }
        }

        If (SP6 = "Fatigue Estimate") {
            Notify("Auto Leave " Round "/" MaxRound)
            If (SP6 = "Fatigue Estimate") {
                Message("SP - ***Round # ***" Round)
                }
            If (Round >= MaxRound) {
                Ping("Max round has reached.") Exit(SP10)
            }
        }
        If (SP4 != "Starve") {
            If (SP4 = "Scalar+Inventory") {
                i := "3-0"
                Notify("Searching for status...")
                ImageSearch,,, 0, 145, 70, 170, *20 Icons\BasicUI\DrinkStatus2.bmp
                If (ErrorLevel = 1) {
                    Notify("Status not found.")
                    Sleep 150
                    Sendinput, {2}2
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, Icons\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        notify("Scalar has ran out from inventory")Ping("Scalar Ran Out, Continue Macroing")
                        SS4 := "Inventory"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop,
                        {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *20 Icons\BasicUI\DrinkStatus2.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("Drank scalar")
                        Sendinput, {1}1
                        If (SP4 != "Inventory"){
                            i := "2-0"
                        }
                        If (SP2 = "Rhythm") or (SP2 = "Flow") {
                            SetTimer, PressR, -400
                        }
                    }
                }
            }
            If (SP14 = "50") {
            ImageSearch,,, 80, 135, 90, 150, *30 Icons\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                SendInput, % sw("Shift")
                Switch Eat("2-0", SP4) {
                    Case "Empty" : Ping("Food Ran Out") Exit(SP10)
                    Case "Timeout" : Ping("Eat Timeout") Exit(SP10)
                    Case "Success" : Sendinput, % sw("1")sw("1")
                }
                If (SP16 = "Yes") {
                    IniRead, Webhook, settings.ini, Notifications, Webhook
                    If (Webhook = "")
                    {
                        MsgBox, Error: You need to set your webhook or the image send will not work.
                        Return
                    }
                    Else
                    {
                        sendinput, {PrintScreen}
                        Sleep, 1000
                        gosub,ImageSend
                    }
                }
                If (SP16 = "No"){
                ; do something else
                }
                If (SP2 = "Rhythm") or (SP2 = "Flow") {
                    SetTimer, PressR, -400
                }
                SendInput, % sw("Shift")
                Timer := A_TickCount, CheckTimer := A_TickCount
            }
        }
    }
    If (SP14 = "20") {
            ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                SendInput, % sw("Shift")
                Switch Eat("2-0", SP4) {
                    Case "Empty" : Ping("Food Ran Out") Exit(SP10)
                    Case "Timeout" : Ping("Eat Timeout") Exit(SP10)
                    Case "Success" : Sendinput, % sw("1")sw("1")
                }
                If (SP16 = "Yes") {
                sendinput, {PrintScreen}
                gosub,ImageSend
                }
                If (SP16 = "No"){
                ; do something else
                }
                If (SP2 = "Rhythm") or (SP2 = "Flow") {
                    SetTimer, PressR, -400
                }
                SendInput, % sw("Shift")
                Timer := A_TickCount, CheckTimer := A_TickCount
            }
        }
    
    
        If (SP2 = "Flow") {
            PixelSearch, x, y, 409, 151, 411, 153, 0x242424,, Fast
            If (ErrorLevel = 0) {
                Sendinput, % sw("t")
                Sleep 200
                notify("Popped Flow.")
                Message("*Macro Popped Flow.*")
            }
        }
}
Return
muscle:
    Gui, Destroy
    Gui, Add, GroupBox, xm ym w311 h270 , Muscle Macro
    Gui, Margin, 20, 40
    Gui, Add, Text, ym xm,Click Interval : Miliseconds
    Gui, Add, Edit, ym+20 xm w150 vv1,
    Gui, Add, Text, ym+45 xm,Eating Method
    Gui, Add, DDL, w150 ym+65 xm vv2,Protein+Inventory|2-0
    Gui, Add, Text, ym+90 xm ,Duration Settings      
    Gui, Add, DDL, ym+110 xm w150 vv3,Macro Indefinitely
    Gui, Add, Text,ym+135 xm ,Leave Settings
    Gui, Add, DDL, ym+155 xm w150 vv4,Exit Roblox|Shutdown|Do Nothing
    Gui, Add, Text,ym+180 xm ,Clip Method
    Gui, Add, DDL, ym+195 xm w150 vv5,Video|Screenshot|Do Nothing
    Gui, Add, Button, ym+195 xm+200 w80 gSaved, Start
    ; Gui, Add, Text,ym+1 xm+160 vv6 ,- Max Milliseconds (1-900)
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
    notify("Pushup & Squat on SLOT 1")
    notify("For Protein put it on SLOT 2.")
    WinWaitClose, Kiyoko's Muscle Macro
    CheckVars([v1,v2,v3,v4,v5], "Muscle")
    if (v5 = "Video") {
        Gui, 3:Add, Text, y10,Record Key:
        Gui, 3:Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
        Gui, 3:Add, Button, ym gRecorder, Done
        Gui, 3:Add, Text, xm,Record Type:
        Gui, 3:Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
        Gui, 3:Show,, Kiyoko's Recording
        WinWaitClose, Kiyoko's Recording
    }
    if (v3 = "Fatigue Estimate") {
        Inputbox, MaxRound, Enter Round,,, 300, 100
    }
        Timer := A_TickCount
    WinActivate, Ahk_exe RobloxPlayerBeta.exe
    Sendinput, % sw("1")
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
        global recordingtype := v5
    Tagfunc := Func("Tag").Bind(List, v5)
    SetTimer, %Tagfunc% , 1000
    Loop {
    Click, 65, 470
    Notify("Milliseconds - " v1 " Clicks - " A_Index)
    Sleep % v1

    PixelSearch, x, y, 40, 133, 45, 135, 0x3A3A3A, 40, Fast RGB

    if (!ErrorLevel) {
        lllll := A_TickCount
        Notify("Low Stam...")

        Loop {
            ImageSearch, ix, iy, 20, 120, 260, 140, *20 Icons\BasicUI\Stamina.bmp
            

            if (!ErrorLevel) {
                Break
            }

            Sleep 1000
        } Until (A_TickCount - lllll > 20000) 
    }

    
        If (v2 = "Protein+Inventory") {
                i := "3-0"
                Notify("Searching for status")
                ImageSearch,,, 0, 145, 70, 170, *10 Icons\BasicUI\DrinkStatus1.bmp
                If (ErrorLevel = 1) {
                    Sleep, 2000
                    Click, 410, 460
                    Sleep, 1000
                    Sendinput, {2}2
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, Icons\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        v2 := "Inventory"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *10 Icons\BasicUI\DrinkStatus1.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("Drank protein")
                        Sendinput, {1}
                    }
                }
            } else {
                i := "2-0"
            }
            
        ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
        If (ErrorLevel = 0) {
            Sendinput, % sw("BackSpace")
            Switch Eat("2-0", v2) {
                Case "Empty" : Ping("Food Ran Out") Exit(v4)
                Case "Timeout" : Ping("Eat Timeout") Exit(v4)
                Case "Success" : {
                    Sendinput, % sw("BackSpace")sw("1")
                }
            }
        }
    }
}
Return

SS:
    Gui, Submit, Hide
    Gui, Destroy
    CheckVars([SS2, SS4, SS6, SS8, SS10, SS12], "StrikeSpeed")
    if (SS12 = "Video") {
        Gui, 3:Add, Text, y10,Record Key:
        Gui, 3:Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
        Gui, 3:Add, Button, ym gRecorder, Done
        Gui, 3:Add, Text, xm,Record Type:
        Gui, 3:Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
        Gui, 3:Show,, Kiyoko's Recording
        WinWaitClose, Kiyoko's Recording
    }
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
        if (path3) {
            InputBox, path2, Kiyoko's Macro,%SS2% 2nd Custom Walk Distance (Default: %path3%ms),, 400, 130
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
        ImageSearch,,, 60, 525, 750, 590, *40 Icons\BasicUI\Speed.bmp
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
                ImageSearch,,, 65, 525, 750, 585, *40 Icons\BasicUI\Speed.bmp
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
                if (SS6 = "Fatigue Estimate") {
                Message("SS - ***Round # ***" Round)
                }
                If (Round >= MaxRound) {
                    Ping("Max round has reached") Exit(SS10)
                }
            } else {
                Notify("Finished Session #"Round)
            }
        } else {
            Sendinput % sw("Backspace")
            Click, %mousex%, %mousey%, 30
            Sleep 100
        }
        If (SS8 = "Scalar+Inventory") or (SS8 = "Inventory") or (SS8 = "3-0") {
            If (SS8 = "Scalar+Inventory") {
                i := "4-0"
                Notify("Searching for status")
                ImageSearch,,, 0, 145, 70, 170, *20 Icons\BasicUI\DrinkStatus2.bmp
                If (ErrorLevel = 1) {
                    Notify("Status not found")
                    Sendinput, {3}3
                    Sleep 150
                    ImageSearch,,, 65, 525, 750, 585, Icons\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        notify("Scalar has ran out from inventory")Ping("Scalar Ran Out, Continue Macroing")
                        SS8 := "Inventory"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop,
                        {
                            Sleep 100
                            ImageSearch,,, 0, 145, 70, 170, *20 Icons\BasicUI\DrinkStatus2.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("Drank scalar")
                        Sendinput, {BackSpace}
                    }
                }
            } else {
                i := "3-0"
            }
            ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Sendinput, {BackSpace}
                Switch Eat(i, SS8) {
                    Case "Empty" : Ping("Food Ran Out") Exit(SS10)
                    Case "Timeout" : Ping("Eat Timeout") Exit(SS10)
                    Case "Success" : 
                    Send, 0
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                    Send, 0
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
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
    ; Display GUI with instructions for the user
Gui, Add, Text, , Place your mouse on the Durability BuyPad for LEFT SIDE.
Gui, Add, Text, , Then press K to continue.
Gui, Show


Hotkey, K, ContinueScript
return

ContinueScript:
Gui, Destroy  


CoordMode, Mouse, Screen
MouseGetPos, MouseX, MouseY
MsgBox, Mouse X: %MouseX%, Mouse Y: %MouseY%

Gui, Add, Text, , Place your mouse on the Durability BuyPad FOR RIGHT SIDE.
Gui, Add, Text, , Then press K to continue.
Gui, Show


Hotkey, K, ContinueScript2
return

ContinueScript2:
Gui, Destroy  


CoordMode, Mouse, Screen
MouseGetPos, MouseXX, MouseYY
MsgBox, Mouse X: %MouseXX%, Mouse Y: %MouseYY%
; Add code to continue with your script here
    MsgBox, 4,Kiyoko Auto Dura,both side are set correctly?
    IfMsgBox, No
    {
        Reload
    }
    If (d4 == "Rhythm") {
    f(LeftPID)
    SendInput, {Backspace}1 
    Sleep 400
    Send, r
    Notify("Pressing R for LEFT SCREEN")
} 
if (d4 == "Do Nothing") {
    f(LeftPID)
    SendInput, {Backspace}1
    Sleep 400 
}
If (d12 == "Rhythm") {
    f(RightPID)
    SendInput, {Backspace}1 
    Sleep 400
    Send, r
    Notify("Pressing R for RIGHT SCREEN")
} 
if (d12 == "Do Nothing") {
    f(RightPID)
    SendInput, {Backspace}1
    Sleep 400 
}

    Loop
    {
        CoordMode, Mouse, Screen
        CoordMode, Pixel, Screen
        ImageSearch,,, 10, 90, 260, 120, *30 Icons\BasicUI\HPBar.bmp
        If (ErrorLevel = 0) {
            f(LeftPID)
            Sleep 3000
            ImageSearch,,, 50, 515, 735, 580, *30 *Trans0x00FF00 Icons\BasicUI\Dura.bmp
            If (ErrorLevel = 1) {
                Timer := A_TickCount
                Loop
                {
                    Sendinput, {Backspace}
                    Click, 50, 470, 20
                    ImageSearch,,, 50, 515, 735, 580, *30 *Trans0x00FF00 Icons\BasicUI\Dura.bmp
                    If (A_TickCount - Timer > 10000) {
                        Ping("Can not buy durability") Exit(d8)
                    }
                } Until (ErrorLevel = 0)
                Sleep 1000
            }
            Switch DurabilityFunction(d10, "Left") {
                ; for catch errors
                case "Push" : Ping("You got pushed") Exit(d8)
            }
            Round++
            If (d6 = "Fatigue Estimate") {
                Notify("Auto Leave " Round "/" MaxRound)
                If (Round >= MaxRound) {
                    Ping("Max round has reached") Exit(d8)
                }
            }
            f(LeftPID)
            Sleep 400
            Click, %MouseX% %MouseY%
            Sleep 400
            Send, 1
            Sleep 1000
            If (d4 == "Rhythm") {
                Sendinput, % sw("r")
            }
            If (d4 == "Do Nothing") {
                Notify("No Rhythm for Left Side.")
                }
        }
        CoordMode, Pixel, Window
        f(LeftPID)
        ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
        If (ErrorLevel = 0) {
            Switch Eat("3-0", "Inventory") {
                Case "Empty" : Ping("Food Ran Out") Exit(d8)
                Case "Timeout" : Ping("Eat Timeout") Exit(d8)
                Case "Success" : {
                Send, 1
                Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                Send, 1
                Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                    If (d4 == "Rhythm") {
                        Sendinput, % sw("BackSpace")sw("1")
                        Sleep, 100
                        Sendinput, % sw("r")
                    }
                    If (d4 == "Do Nothing") {
                    Sendinput, % sw("BackSpace")sw("1")
                    Notify("No Rhythm for Right Side. 2")
                    } 
                }
                
            }
        }
        if (d2 = "Both") {
            CoordMode, Pixel, Screen
            ImageSearch,,, 810, 90, 1060, 120, *30 Icons\BasicUI\HPBar.bmp
            If (ErrorLevel = 0) {
                f(RightPID)
                Sleep 3000
                ImageSearch,,, 850, 515, 1535, 580, *30 *Trans0x00FF00 Icons\BasicUI\Dura.bmp
                If (ErrorLevel = 1) {
                    Timer := A_TickCount
                    Loop
                    {
                        Sendinput, % sw("1")
                        Click, 850, 470, 20
                        ImageSearch,,, 850, 515, 1535, 580, *30 *Trans0x00FF00 Icons\BasicUI\Dura.bmp
                        If (A_TickCount - Timer > 10000) {
                            Ping("Cannot buy durability") Exit(d8)
                        }
                    } Until (ErrorLevel = 0)
                    Sleep 1000
                }
                Switch DurabilityFunction(d10, "Right") {
                    ; for catch errors
                    case "Push" : Ping("You got pushed") Exit(d8)
                }
                Round++
                If (d6 = "Fatigue Estimate") {
                    Notify("Auto Leave " Round "/" MaxRound)
                    If (Round >= MaxRound) {
                        Ping("Max round has reached") Exit(d8)
                    }
                }
                f(RightPID)
                Sleep 400
                Click, %MouseXX% %MouseYY%
                Sleep 400
                Send, 1
                Sleep 1000
                If (d12 == "Rhythm") {
                    Sendinput, % sw("r")
                }
                If (d12 == "Do Nothing") {
                    Notify("No Rhythm for Right Side.")
                }
            }
            CoordMode, Pixel, Window
            f(RightPID)
            ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
            If (ErrorLevel = 0) {
                Switch Eat("3-0", "Inventory") {
                    Case "Empty" : Ping("Food Ran Out") Exit(d8)
                    Case "Timeout" : Ping("Eat Timeout") Exit(d8)
                    Case "Success" : {
                    Send, 1
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                    Send, 1
                    Sleep, 1000 ; delay for 1 second (adjust the value as needed)
                        If (d12 == "Rhythm") {
                        Sendinput, % sw("BackSpace")sw("1")
                        Sleep, 100
                        Sendinput, % sw("r")
                        }
                    If (d12 == "Do Nothing") {
                    Sendinput, % sw("BackSpace")sw("1")
                    Notify("No Rhythm for Right Side. 2")
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
            "username":"KM | Kiyoko's Macro", "avatar_url":"https://raw.githubusercontent.com/fr0st-iwnl/assets/main/thumbnails/kiyokowebhooklogo.png" ,
            "content":"%UserID% %i%"
        }
    )
    whr.Open("POST", Webhook, False),whr.SetRequestHeader("Content-Type", "application/json"),whr.Send(post)
}

Message(i) {
    IniRead, Webhook, settings.ini, Notifications, Webhook
    IniRead, UserID, settings.ini, Notifications, UserID
    If (!Webhook) or (!UserID) or (UserID = "ERROR") or (Webhook = "ERROR") {
        Sleep, 100
        if WinExist("Ahk_exe RobloxPlayerBeta.exe") 
            WinActivate
        Return
    }
    If (GetUrlStatus(Webhook, 10) != 200) {
        IniDelete, settings.ini, Notifications , Webhook
        Sleep, 100
        if WinExist("Ahk_exe RobloxPlayerBeta.exe") 
            WinActivate
        Return
    }
    static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    post=
    (
        {
            "username":"KM | Kiyoko's Macro", "avatar_url":"https://raw.githubusercontent.com/fr0st-iwnl/assets/main/thumbnails/kiyokowebhooklogo.png" ,
            "content":"%i%"
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
        Sendinput, % sw("1")
        Notify("Sending Between " i)
        Message("*Macro is eating.*")
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
        ImageSearch,,, 65, 525, 750, 585, Icons\BasicUI\3x2.bmp
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
                    ImageSearch, x, y, 80, 190, 670, 500, *20 Icons\BasicUI\x8.bmp
                    If (ErrorLevel = 0) {
                        Click, %x%, %y%, Down
                        Click, %v%, 555, Up
                        v := v + 70
                        Continue
                    }
                    ImageSearch, t, r, 80, 190, 670, 500, *20 Icons\BasicUI\x12.bmp
                    If (ErrorLevel = 0) {
                        Click, %t%, %r%, Down
                        Click, %v%, 555, Up
                        v := v + 70
                        Continue
                    } 
                     else if (ErrorLevel = 1) {
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
		ImageSearch,,, 65, 525, 750, 585, Icons\BasicUI\3x2.bmp
		If (ErrorLevel = 1) {
			Return "Success"
		}
		ImageSearch,,, 125, 135, 140, 150, *30 Icons\BasicUI\Hunger.bmp
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
    ImageSearch,,, 20, 85, 170, 110, *20 Icons\BasicUI\combat.bmp
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
            SoundPlay, Icons\Sound\broken.wav
            MouseMove, 575, 120
            Loop, 20
            {
               Send {WheelUp 10}
            }
            Mou(14, recordingtype)
            Click, 788, 120, down
            Click, 788, 248, up
            Mou(14, recordingtype)
            Click, 788, 248, down
            Click, 788, 376, up
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
            ImageSearch,,, 20, 85, 170, 110, *20 Icons\BasicUI\combat.bmp
            if (ErrorLevel = 1) {
                Sleep, 300
                ImageSearch,,, 20, 85, 170, 110, *20 Icons\BasicUI\combat.bmp
                if (ErrorLevel = 1) {
                    Break
                }
            }
        }
        Ping("Combat Tag is Gone.") Exit(i)
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
                SendInput, % sw("w")
                Sleep, 85
                SendInput, % sw("w","down") sw(Button[Direction],"down")  
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
                        ImageSearch,,, 20, 85, 170, 110, *20 Icons\BasicUI\combat.bmp
                    } Until (ErrorLevel = 1)
                    Process, Close, % LeftPID
                    f(RightPID)
                    Loop,
                    {
                        ImageSearch,,, 20, 85, 170, 110, *20 Icons\BasicUI\combat.bmp
                    } Until (ErrorLevel = 1)
                    Process, Close, % RightPID
                }
                case "Shutdown" : { 
                    Ping("Shutting Down Computer...")
                    Shutdown, 5
                }
            }
        }
        case "Basic" : {
            Switch i {
                case "Exit Roblox": {
                    Loop,
                    {
                        ImageSearch,,, 20, 85, 170, 110, *20 Icons\BasicUI\combat.bmp
                    } Until (ErrorLevel = 1)
                    Process, Close, RobloxPlayerBeta.exe
                    Ping("Succesfully Logged!")
                } 
                case "Shutdown" : { 
                    Ping("Shutting Down Computer...")
                    Shutdown, 5
                }
            }
        }
    }
    Sleep 5000
    Ping("Macro has been stopped.")
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
                    case "Low" : X1 := 80, X2 := 81
                }
            }
            case "Right" : {
                Switch Curr {
                    case "Full" : X1 := 930, X2 := 931
                    case "Half" : X1 := 890, X2 := 891
                    case "Low" : X1 := 880, X2 := 881          
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
            ImageSearch,,, 10, 90, 260, 120, *30 Icons\BasicUI\HPBar.bmp
            If (ErrorLevel = 0) {
                Return "Push"
            }
            Click, 50, 470, 10
        }
        case "Right" : {
            ImageSearch,,, 810, 90, 1060, 120, *30 Icons\BasicUI\HPBar.bmp
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
    gui, add, ddl, ym vv1,Run+Eat|Starve+Knock|BurnFat
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
            case "Run+Eat" : {
                SendInput, % sw("w")
                Sleep, 85
                SendInput, % sw("s", "down")sw("w", "down")
                Sleep 4000
                SendInput, % sw("w", "up")sw("s","up")
                If (GetColors(35, 130, "0x3A3A3A", 40)) {
                    Notify("Wait, 10000")
                    Sleep 10000
                }
                ImageSearch,,, 40, 135, 50, 150, *30 Icons\BasicUI\Hunger.bmp
                If (ErrorLevel = 0) {
                    Switch Eat("1-0", "Inventory") {
                        Case "Empty" : Ping("Food Ran Out") ExitApp
                        Case "Timeout" : Ping("Eat Timeout") ExitApp
                        Case "Success" : Sendinput, % sw("BackSpace")
                    }
                }
            }
            case "Starve+Knock" : {
                SendInput, % sw("w")
                Sleep, 85
                SendInput, % sw("s", "down")sw("w", "down")
                Sleep 4000
                SendInput, % sw("w", "up")sw("s","up")
            }
            case "BurnFat" : {
                SendInput, % sw("w")
                Sleep, 85
                SendInput, % sw("s", "down")sw("w", "down")
                Sleep, 4000
                SendInput, % sw("w", "up")sw("s","up")
                PixelSearch, x, y, 40, 133, 45, 135, 0x3A3A3A, 40, Fast RGB
                if (!ErrorLevel) {
                    Notify("Waiting for 10 seconds.")
                    Sleep, 10000 ; Pause execution for 10 seconds
                }
                ImageSearch,,, 0, 145, 70, 170, *10 Icons\BasicUI\DrinkStatus3.bmp
                If (ErrorLevel = 1) {
                    Notify("Status not found")
                    Sendinput, 1
                    Sleep, 150
                    ImageSearch,,, 65, 525, 750, 585, Icons\BasicUI\3x2.bmp
                    If (ErrorLevel = 1) { 
                        notify("Fatburner has ran out from inventory")
                        Ping("Fatburner Ran Out, Continue Macroing")
                        v1 := "Starve+Knock"
                    } else {
                        Click
                        waittime := A_TickCount
                        Loop,
                        {
                            Sleep, 100
                            ImageSearch,,, 0, 145, 70, 170, *10 Icons\BasicUI\DrinkStatus3.bmp
                        } Until (ErrorLevel = 0) or (A_TickCount - waittime > 12000)
                        notify("Drank fatburner")
                        Sendinput, {1}
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


ImageSend:
    Path := "C:\Users\" . A_UserName . "\Pictures\Roblox"
    IniRead, Webhook, settings.ini, Notifications, Webhook

    ; Check if the path exists
    If (!FileExist(Path))
    {
        Ping("Image directory path does not exist: " . Path . ". Macro stopped.")
        MsgBox, Image directory path does not exist: %Path%.
        ExitApp
    }

    ; Find the latest image
    latestImage := FindLatestImage(Path)
    If (latestImage = "")
    {
        Ping("No image was found in the directory path. Macro stopped.")
        MsgBox, No image found in %Path%.
        ExitApp
    }

    ; curl command
    curlCommand := "curl -X POST " . Webhook . " -F file=@" . latestImage

    Run, %curlCommand%, , Hide

    Sleep, 2000 ; Adjust the sleep time if needed

    ; delete the image
    FileDelete, %latestImage%

    Notify("Image sent + deleted!")
return

FindLatestImage(directory)
{
    latestFile := ""
    latestModTime := 0
    
    ; jpg
    Loop, %directory%\*.jpg, 0, 1
    {
        thisFile := A_LoopFileFullPath
        thisModTime := A_LoopFileTimeModified
        
        ; Check if this file is newer than the current latest
        if (thisModTime > latestModTime)
        {
            latestFile := thisFile
            latestModTime := thisModTime
        }
    }
    
    ; jpeg
    Loop, %directory%\*.jpeg, 0, 1
    {
        thisFile := A_LoopFileFullPath
        thisModTime := A_LoopFileTimeModified
        
        ; Check if this file is newer than the current latest
        if (thisModTime > latestModTime)
        {
            latestFile := thisFile
            latestModTime := thisModTime
        }
    }
    
    ; png
    Loop, %directory%\*.png, 0, 1
    {
        thisFile := A_LoopFileFullPath
        thisModTime := A_LoopFileTimeModified
        
        ; Check if this file is newer than the current latest
        if (thisModTime > latestModTime)
        {
            latestFile := thisFile
            latestModTime := thisModTime
        }
    }
    
    Return latestFile
}


;------------------------------- MOSTLY MISC HERE -------------------------------


ChangeWebhook:
{
    InputBox, NewWebhook, Change Webhook, Enter the new Webhook URL, AlwaysOnTop, On, 100, 100
    if (ErrorLevel) {
        Return
    }
    IniWrite, %NewWebhook%, settings.ini, Notifications, Webhook
    Notify("Webhook updated successfully.")
    Return
}

ChangeUserID:
{
    InputBox, NewUserID, Change User ID, Enter the new User ID, AlwaysOnTop, On, 100, 100
    if (ErrorLevel) {
        Return
    }
    IniWrite, <@%NewUserID%>, settings.ini, Notifications, UserID
    Notify("UserID updated successfully.")
    Return
}


SSM1DelayChange:
{
    InputBox, NewSSM1Delay, Change SS M1 Delay (Default: 960), , AlwaysOnTop, On, 100, 100
    if (!NewSSM1Delay) {
        MsgBox, 262144, Warning, SS M1 Delay was not changed.
        Return
    }
    if !RegExMatch(NewSSM1Delay, "^\d+$") {
        MsgBox, 262144, Error, Please enter a valid number.
        Return
    }

    IniWrite, %NewSSM1Delay%, settings.ini, Additional_Settings, SSM1DELAY
    Notify("SS M1 Delay updated successfully.")
    Return
}


; TESTING OPTIONS :
; TESTING HUNGER FASTER ImageSearch,,, 110, 135, 120, 150, *30 Icons\BasicUI\Hunger.bmp