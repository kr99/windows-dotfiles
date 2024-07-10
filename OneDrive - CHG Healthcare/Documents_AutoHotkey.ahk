

; Key quick-reference:
;
; # - Windows
; ! - Alt
; ^ - Control
; + - Shift
; ~ - Don't block native function when hotkey fires


; A combo function to send input to all applications, but handle GTK apps
; differently, due to quirks with sending non-ASCII characters as input to GTK
; apps (this assumes that the GTK application will use control-v to paste the
; contents of the clipboard):
SendGTK(str)
{
	if WinActive("ahk_class gdkWindowToplevel")
	{
		tmp := A_Clipboard
		A_Clipboard := str
		Send("^v")
		A_Clipboard := tmp
	} else {
		SendInput(str)
	}
}

; Use FreeCompose instead of CapsLock to create accented chars, etc.

generatePattern(pattern, characterAndRandomReplacements) {
    ; extract the pattern character and possible random characters from characterAndRandomReplacements1 by the space.
    characterToReplace := SubStr(characterAndRandomReplacements, 1, 1)
    randomCharacters := SubStr(characterAndRandomReplacements, 3)
    randomCharsLength := StrLen(randomCharacters)

    ; loop while the "#" or characterToReplace is in the pattern
    while (InStr(pattern, characterToReplace)) {
        randomChar := SubStr(randomCharacters, Random(1, randomCharsLength), 1)
	limit := "1"

	positionOfCharacterToReplace := InStr(pattern, characterToReplace)
        pattern := SubStr(pattern, 1, positionOfCharacterToReplace - 1) . randomChar . SubStr(pattern, positionOfCharacterToReplace + 1)

    }
    return pattern
}

:*?:guid````::
{
    ; GUID v4 follows this pattern...
    uuid4Pattern := "########-####-4###-####-############"

    ; generate a uuid using the function above
    uuid := generatePattern(uuid4Pattern, "# 0123456789abcdef")
    ; type it out (ahk v2)
    SendInput(uuid)
    return
}
; 33333333-3333-4333-3333-333333333333

:*?:uuid````::
{
	; ai-assisted code here
	validUUIDChars := "0123456789abcdef"
	uuid := ""
	Loop 32
	{
		uuid .= SubStr(validUUIDChars, Random(1, 16), 1)
		if (A_Index = 8 || A_Index = 12 || A_Index = 16 || A_Index = 20)
		{
			uuid .= "-"
		}
	}
	uuid := SubStr(uuid, 1, 14) . "4" . SubStr(uuid, 16) ; make it a valid v4 uuid by replacing the correct character.
	Clipboard := uuid
	SendInput(uuid)
	return
}


:*?:kids````::
:*?:sk````::
	;timetil =  ; Make it blank so that the below will use the current time instead.
	;envadd,timetil,1, hours
	;MsgBox, %var1%  ; The answer will be the date 31 days from now.
	;formattime,var1,,h:mm

{ ; V1toV2: Added bracket
   timetil := A_Now
	;envadd,timetil,1, hours
   ;timetil += 1, hour

	formattedtime := FormatTime("timetil", "hh:mm")
	SendInput("/status :kids: I have my kids for an hour or two (starting at " formattedtime ")")
	return
} ; V1toV2: Added Bracket before hotkey or Hotstring



:*?:lunch````::
{ 	; V1toV2: Added bracket
	SendInput("/status :hamburger: lunch{Enter}")
	Sleep(2000)
	SendInput("{CTRLDOWN}{SHIFTDOWN}Y{CTRLUP}{SHIFTUP}{Tab 3}{Down 3}{Enter 2}")
	return
} ; V1toV2: Added Bracket before hotkey or Hotstring

:*?:cron````::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "ss mm HH dd MM ? yyyy,2099")
	; SendInput, %TimeString% ss_mm_HH_dd_MM_dayOfWeek_yyyy__NOW
	; FormatTime, TimeString, A_Now, 00 00 05 31 2 ? yyyy,2099
	SendInput(TimeString "  ss_mm_HH_dd_MM_dayOfWeek_yyyy__NOW{CTRLDOWN}{SHIFTDOWN}{Left 8}{CTRLUP}{SHIFTUP}")
	return
	; 12`` inputs 12:00 AM (for the sake of jira entry on previous days)
} ; V1toV2: Added Bracket before hotkey or Hotstring


:*?:12````::12:00 AM

:*?:dj````::
:*?:jt````::
	; dj`` inputs a journal-based timestamp like this
	;tmp := clipboard ;save clipboard state.
	;  2014-04-13 (Sunday) 7:21 PM
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "yyyy-MM-dd (dddd) hh:mm tt")
	SendInput(TimeString)
return

; Orchards Ward Weekly Email
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*?:oww````::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "MMMM /d, yyyy")
	SendInput("Orchards Ward - Sunday Bulletin + Weekly Email, " TimeString)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

; Orchards Ward Bulletin/Program
:*?:owb````::
{ ; V1toV2: Added bracket
	theDate := a_now
	day_of_Week := FormatTime(theDate, "WDay") ; sunday is 1, 1-7
	if (day_of_Week != 1) {
		theDate := DateAdd(theDate, 8 - day_of_Week, 'days') ; wont work if I am sending late...but that's just how it is...
	}
	bulletinDateStr := FormatTime(theDate, "dddd, MMM d, yyyy")
	SendInput("Church Bulletin & Program for " bulletinDateStr)
	return
} ; V1toV2: Added Bracket before hotkey or Hotstring

; zoom topic chg
:*?:zoom````::
:*?:zoom;;::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "MMMM d, yyyy")
	SendInput("/topic https://chghealthcare.zoom.us/my/kimball.robinson (zoom channel for " TimeString ")")
return
;
; dt`` inputs a date.
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*?:dt````::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "MMMM d, yyyy")
	SendInput(TimeString)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
;
:*?:dtt````::
:*?:dt1````::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "yyyy-MM-dd")
	SendInput(TimeString)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

:*?:dt2````::
:*?:date````::
:*?:dts````::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "yyyy/MM/dd HH:mm:ss")
	SendInput(TimeString)
return


; ts`` inputs a timestamp.
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*?:ts````::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "h:mm:ss tt")
	SendInput(TimeString)
return

; tiat`` shows a "testing" message.
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*?:tt````::
{ ; V1toV2: Added bracket
	TimeString := FormatTime("A_Now", "yyyy.MM.dd HH.mm.ss")
	SendInput("This is a test.  Please disregard.  " TimeString)
return
}
; tm;; shows a "testing - notify" message.
:*?:tm;;::
{
	TimeString := FormatTime("A_Now", "yyyy.MM.dd HH.mm.ss")
	SendInput("This is a test.  If you receive this message/record, we apologize.  Please contact us and let us know.")
return

; kjr`` inputs my name.
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*?c:kjr````::Kimball J. Robinson

; ph`` inputs my phone number.
:*?c:ph````::208-419-8490

; url`` inputs my url.
:*?c:url````::http://kimballrobinson.name/

; @`` inputs my email.
:*?c:confidence````::/poll "what is your confidence level" "1" "2" "3" "4" "5"
:*?c:email````::type.one.of@gm-or-chg.as.macros
:*?c:gmail````::kimball.robinson@gmail.com
:*?c:spam````::krobinson8nospam@gmail.com
:*?c:gm````::kimball.robinson@gmail.com
:*?c:wmail````::kimball.robinson@chghealthcare.com
:*?c:wm````::kimball.robinson@chghealthcare.com
:*?c:wem````::kimball.robinson@chghealthcare.com
:*?c:chg````::kimball.robinson@chghealthcare.com
:*?c:@````::kimball.robinson@gmail.com
:*?c:z````::zwokkqxpozgcc@gmail.com
:*?c:zwok````::zwokkqxpozgcc@gmail.com

; add`` inputs my address.
:*?c:add````::
(
Kimball J. Robinson
712 W 1275 N
Farmington, UT 84025
)

; #l::
; ^!Del:: ;detect locking of screen by hotkeys Ctrl-Alt-Del and Win-L, and remind to log it in ManicTime
; 	MsgBox, , Log time, Remember to log your away time in ManicTime!, 50
; return
;

#z::
{

	if (SoundGetMute( , "Microphone") = 0) {

		MsgBox "The microphone (recording) is not muted."
		SoundSetMute 1, , "Microphone"
	} else {
		MsgBox "The microphone (recording) IS muted."
		SoundSetMute 0, , "Microphone"
	}

return
}

#+r:: ;win-shift-r
{ ; V1toV2: Added bracket
	MsgBox("Use win-alt-R instead", "Wrong key combo", "T3")
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*?c:reload````::
!#r:: ;win-alt-r
^!r:: ;ctrl-alt-r
^#r:: ;ctrl-win-r
{ ; V1toV2: Added bracket
	ErrorLevel := SendMessage(0x1A, , , , "ahk_id 0xFFFF") ; 0x1A is WM_SETTINGCHANGE
	MsgBox("Reloading AutoHotkey script... and sending WM_SETTINGCHANGE event", "Reloading", "T1")
	Reload()
return
} ; V1toV2: Added Bracket before hotkey or Hotstring

#NumpadSub:: ; win + numpad subtract (prevent magnifier)
#NumpadAdd:: ; win + numpad subtract (prevent magnifier)
{ ; V1toV2: Added bracket
	MsgBox("`"Preventing magnifier hotkey`"", "Override", "T.8")
return

}

; Make Windows-Tab behave a little like alt-tab:
;Add(x, y)
;{
    ;return x + y   ; "Return" expects an expression.
;}

;currentDesktopGuess := 1
;noOpMoveCount := 1

;WinVisible(Title) {
;	; from online, got this function
;	DetectHiddenWindows(false) ; Force to not detect hidden windows
;	Return WinExist(Title) ; Return 0 for hidden windows or the ahk_id
;	DetectHiddenWindows(true) ; Return to "normal" state
;}
;
;MoveTo(targetDesktop)
;{
;	global currentDesktopGuess
;	global noOpMoveCount
;
;	if (!currentDesktopGuess)
;	{
;		currentDesktopGuess := -1
;	}
;
;	if (!noOpMoveCount)
;	{
;		noOpMoveCount := 100
;	}
;
;	if (WinVisible("Desktop 8"))
;	{
;		;MsgBox, , Move to desktop, Moving to %currentDesktopGuess% -> %targetDesktop% diff %movement%, 1
;	}
;	movement := currentDesktopGuess - targetDesktop
;	;MsgBox, 4,, "Moving " . %movement%
;	;MsgBox, , Move to desktop, Moving to %currentDesktopGuess% -> %targetDesktop% diff %movement%, 1
;	;TrayTip, "Mv", "Moving " . movement
;
;	SetKeyDelay(120)  ; sometimes I get it to 50, but sometimes it's 100 when things get iffy.  100 seems slow. 50 seems good.
;	if (currentDesktopGuess < 0 || movement == 0)
;	{
;		; selecting a desktop twice suggests we could be in the wrong place and need a reset.
;		noOpMoveCount := noOpMoveCount + 1
;		if (noOpMoveCount > 1)
;		{
;			noOpMoveCount := 1
;			rightArrows := targetDesktop - 1
;			leftArrows := "9"
;			if (targetDesktop <= 5)
;			{
;				leftArrows := "9"
;				rightArrows := targetDesktop - 1
;				Send("{LWin down}{Ctrl down}{Left " leftArrows "}{Right " rightArrows "}{Ctrl up}{LWin up}")
;			} else {
;				leftArrows := 9 - targetDesktop
;				rightArrows := 9
;				Send("{LWin down}{Ctrl down}{Right " rightArrows "}{Left " leftArrows "}{Ctrl up}{LWin up}")
;			}
;		} else {
;			; MsgBox, , Move to desktop, It looks like you are already on desktop %currentDesktopGuess%--but repeat the keystroke to reset things (count is %noOpMoveCount%), 3
;		}
;	}
;	else if (movement < 0)
;	{
;		offset := -movement
;		noOpMoveCount := 1
;		Send("{LWin down}{Ctrl down}{Right " offset "}{Ctrl up}{LWin up}")
;	}
;	else if (movement > 0)
;	{
;		offset := movement
;		noOpMoveCount := 1
;		Send("{LWin down}{Ctrl down}{Left " offset "}{Ctrl up}{LWin up}")
;	}
;	currentDesktopGuess := targetDesktop
;
;;    return x + y   ; "Return" expects an expression.
;}

;#+Up::
;; realign a couple windows to upper screens (work in progress, not working properly yet)
;{ ; V1toV2: Added bracket
	;Send("{LWin down}{Up}{LWin up}")
	;Send("{LWin down}{Shift down}{Left}{Shift up}{LWin up}")
	;Send("{Alt down}{tab}{Alt up}")
	;Send("{LWin down}{Up}{LWin up}")
	;Send("{LWin down}{Shift down}{Right}{Shift up}{LWin up}")
;return

;; Windows+Number pad keys = Windows 10 desktop switching.
;; number pad to match a 3x3 desktop
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad1::
;#NumpadEnd::
;{ ; V1toV2: Added bracket
;	MoveTo(1)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad2::
;#NumpadDown::
;{ ; V1toV2: Added bracket
;	MoveTo(2)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad3::
;#NumpadPgDn::
;{ ; V1toV2: Added bracket
;	MoveTo(3)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad4::
;#NumpadLeft::
;{ ; V1toV2: Added bracket
;	MoveTo(4)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad5::
;#NumpadClear::
;{ ; V1toV2: Added bracket
;	MoveTo(5)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad6::
;#NumpadRight::
;{ ; V1toV2: Added bracket
;	MoveTo(6)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad7::
;#NumpadHome::
;{ ; V1toV2: Added bracket
;	MoveTo(7)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad8::
;#NumpadUp::
;{ ; V1toV2: Added bracket
;	MoveTo(8)
;	return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#Numpad9::
;#NumpadPgUp::
;{ ; V1toV2: Added bracket
;	MoveTo(9)
;	return
;;	Send, {LWin down}{Tab}{LWin up}
;;	Sleep, 3000
;;	Send, {Tab 1}{Right 2}
;;	Sleep, 3000
;;	Send, {Enter}
;;	Sleep, 3000
;;	return
;;
;;	Bring up the "move this window to desktop..." menu.  Since the menu is always different, don't operate on it.  Just leave it at that.
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;#!Numpad0::
;#!NumpadIns::
;#+Numpad0::
;#+NumpadIns::
;#Numpad0::
;#NumpadIns::
;{ ; V1toV2: Added bracket
;	Send("{LWin down}{Tab}{LWin up}")
;	Sleep(400)
;	Send("{AppsKey}M")
;return
;} ; V1toV2: Added Bracket before hotkey or Hotstring

;#NumpadDel::
;#NumpadDot::
;{ ; V1toV2: Added bracket
	;myGui := Gui()
	;myGui.New(, "Desktop " . currentDesktopGuess)
	;myGui.Add("Text", , "Desktop " . currentDesktopGuess)
	;; Gui, Add, Edit, vName
	;myGui.Show()
;return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;
;$#^Left::
;{ ; V1toV2: Added bracket
	;currentDesktopGuess := currentDesktopGuess - 1
	;if (currentDesktopGuess < 1)
	;{
		;currentDesktopGuess := 1
	;}
;
	;Send("#^{Left}")
;return
;} ; V1toV2: Added Bracket before hotkey or Hotstring
;$#^Right::
;;{ ; V1toV2: Added bracket
	;currentDesktopGuess := currentDesktopGuess + 1
	;if (currentDesktopGuess > 9)
	;{
		;currentDesktopGuess := 9
	;}
	;Send("#^{Right}")
;return

; Win+Alt+Enter launches Windows Media Center in Vista/7, which I occasionally
; accidentally hit. This disables/ignores that combination:
;} ; V1toV2: Added Bracket before hotkey or Hotstring
!#Enter::return

; Volume control with the mouse wheel:
;~RButton & WheelUp:: Send, {Volume_Up 5}
;~RButton & WheelDown:: Send, {Volume_Down 5}
#WheelUp::Send("{Volume_Up 5}")
#WheelDown::Send("{Volume_Down 5}")
;
;; Windows+1: Switch to page 9 and start Firefox, or focus it if it's already running:
;#1: :
;	Run, C:\Users\Heptite\Software\VirtuaWin_portable_unicode_4.2\vwrun.exe 9
;	;wait for change
;	Sleep 500
;	SetTitleMatchMode, 2
;	IfWinExist, Mozilla Firefox
;	{
;		WinActivate
;	} else {
;		Run, Firefox, , Max
;		WinWait, Mozilla Firefox
;		WinActivate
;	}
;	return
;
;; Windows+2: Switch to page 5 and start Alpine, or focus it if it's already running:
;#2: :
;	Run, C:\Users\Heptite\Software\VirtuaWin_portable_unicode_4.2\vwrun.exe 5
;	;wait for change
;	Sleep 500
;	SetTitleMatchMode, 2
;	IfWinExist, Alpine
;	{
;		WinActivate
;	} else {
;		Run, "C:\Program Files (x86)\Alpine\alpine.exe", , Max
;		WinWait, Alpine
;		WinActivate
;	}
;	return


;  #IfWinActive ahk_class rctrl_renwnd32
;  ; win-e or right-alt e
;  #e::
;  >!e::
;  	; helps to quickly archive messages in Outlook.
;  		SendInput, {ALTDOWN}H{ALTUP}
;  		SendInput, mv
;  		SendInput, o
;  		SendInput, {Home}
;  		SendInput, inbox
;  		SendInput, {Right}
;  		SendInput, {Right}
;  		SendInput, archiv
;  		SendInput, {ALTUP}
;  		; since this is a dynamic menu, I won't hit the final enter key--let the user do that.
;  		;SendInput, {Enter}
;
;  return
;  #IfWinActive


;global whiteBackgroundIndex := 1

#!b::
#!m::
	; Win-Alt-B (or M) On migraine days, I want a quick way to choose a friendly background that works with 'negative screen', even if in a clunky way.
{ ; V1toV2: Added bracket
	Directory := "C:\Users\kirobins\Dropbox\Backgrounds-Work\Artistic\White (inverted migraines)\"
	Directory2 := "C:\Users\kirobins\Dropbox\Backgrounds-Work\Artistic\White (inverted migraines)\inverted"
	fileArray := []
	Loop Files, Directory "\*.*"
	{
		if (A_LoopFileAttrib ~= "i)(H|R|S)")  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
			continue
		if (A_LoopFileSizeKB > 1)
		{
			fileArray.push(A_LoopFilePath)
		}
	}
	Loop Files, Directory2 "\*.*"
	{
		if (A_LoopFileAttrib ~= "i)(H|R|S)")  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
			continue
		if (A_LoopFileSizeKB > 1)
		{
			fileArray.push(A_LoopFilePath)
		}
	}
	whiteBackgroundIndex += 1
	if ( whiteBackgroundIndex > fileArray.MaxIndex())
	{
		whiteBackgroundIndex := 1
	}
	fileToChoose := fileArray[whiteBackgroundIndex]
	DllCall("SystemParametersInfo", "UInt", 0x14, "UInt", 0, "Str", fileToChoose, "UInt", 2)
	RegWrite(10, "REG_SZ", "HKCU\Control Panel\Desktop", "WallpaperStyle")
	RegWrite(0, "REG_SZ", "HKCU\Control Panel\Desktop", "TileWallpaper")

return
} ; V1toV2: Added Bracket before hotkey or Hotstring

;#^v::
;	; https://autohotkey.com/board/topic/32013-using-clipboard-and-string-split/
;{ ; V1toV2: Added bracket
;	msgResult := MsgBox("`"This hotkey (ctrl win v) adds multiple tasks to todoist from the A_Clipboard.  Continue?`"", "", 4)
;	if (msgResult = "Yes")
;		continueFlag := "yes"
;	else
;		return
;
;	originalClipboard := A_Clipboard
;
;	IB := InputBox("enter when to do it in todoist style", "New Task due date", "w320 h240", "today"), when := IB.Value
;	;parse on newline, ignoring carriage returns.
;	originalClipboard := Trim(originalClipboard)
;	Loop Parse, originalClipboard, "`n", "`r"
;	{
;		newTask := Trim(A_LoopField)
;		if (newTask != "" && newTask)
;		{
;			; hotkey for a new task...
;			SendInput("q")
;			; give time for the interface to catch up--otherwise we get really strange results.
;			Sleep(100)
;			;clipboard = %newTask%
;			;clipwait 2
;			Send("{Raw}" when " " newTask)
;			SendInput("{Enter}")
;			; give time for the interface to catch up--otherwise we get really strange results.
;			Sleep(100)
;		}
;	}
;	A_Clipboard := originalClipboard
;return
;} ; V1toV2: Added Bracket before hotkey or Hotstring


;#c:: ;win-ctrl-c
;{
;	if WinActive("ahk_class rctrl_renwnd32")
;	{
;		MsgBox("`"Copying Email To A_Clipboard`"", "`"Copying`"", "T.5")
;		SendInput("{CTRLDOWN}r{CTRLUP}")
;		SendInput("{Tab 4}")
;} ; Added bracket before function
;		SendInput("{CTRLDOWN}f{CTRLUP}Original{Enter}") ;{SHIFTDOWN}={SHIFTUP}
;		SendInput("{ESC}")
;		SendInput("{Home}")
;		SendInput("{CTRLDOWN}{SHIFTDOWN}{End}{CTRLUP}{SHIFTUP}")
;		SendInput("{CTRLDOWN}c{CTRLUP}")
;		SendInput("{ESC}")
;	}
;	if WinActive("ahk_class #32770")
;	{
;		SendInput("n")
;	}
;return


;!#s::
;	; win-alt-s restart sharemouse
;{ ; V1toV2: Added bracket
;	myGui.Add("Text", , "Killing and Restarting Sharemouse.")
;	ogcButtonOk := myGui.Add("Button", , "Ok")
;	ogcButtonOk.OnEvent("Click", GUIClose.Bind("Normal"))
;	myGui.Title := "Msgbox"
;	myGui.Show("Center")
;
;	ProcessClose("ShareMouse.exe")
;	RunWait("taskkill /IM ShareMouse.exe /F", , "Hide")
;	Run("`"C:\Program Files (x86)\ShareMouse\ShareMouse.exe`"", "`"C:\Program Files (x86)\ShareMouse\`"")
;	myGui.Destroy()
;return
;} ; Added bracket before function

;GUIClose(A_GuiEvent, GuiCtrlObj, Info, *)
;{ ; V1toV2: Added bracket
    ;myGui.Destroy()
;Return
;} ; V1toV2: Added Bracket before hotkey or Hotstring

;!#z::
;	; win-alt-z kills grindstone.
;{ ; V1toV2: Added bracket
;	ProcessClose("GS3.exe")
;	MsgBox("`"Shutting down grindstone`"", "`"Killing grindstone`"", "T3")
;	msgResult := MsgBox("`"Restart grindstone (will proceed automatically in 15 seconds)`"", "`"Restart grindstone?`"", "1 T15")
;	if (msgResult = "OK")
;		Run("`"C:\Users\kirobins\AppData\Local\Grindstone 3\GS3.exe`"")
;	if (msgResult = "TIMEOUT")
;		Run("`"C:\Users\kirobins\AppData\Local\Grindstone 3\GS3.exe`"")
;return
;} ; V1toV2: Added Bracket before hotkey or Hotstring

;#!k::
;{ ; V1toV2: Added bracket
;	MouseGetPos(&xpos, &ypos)
;	MsgBox("The cursor is at X" xpos " Y" ypos ".", "", "T2")
;	CoordMode("Mouse", "Screen")
;
;return


; Microsoft outlook keybindings...
;#IfWinActive, Inbox
;+1::
;^1::
;	Send, {AppsKey}jb
;return
;^j::
;	Send, {Down}
;return
;^k::
;	Send, {Up}
;return
;#IfWinActive
; END OF Microsoft outlook keybindings...



; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

; #z::Run www.autohotkey.com
;
; ^!n::
; IfWinExist Untitled - Notepad
; 	WinActivate
; else
; 	Run Notepad
; return

; vim: set ts=3 sw=3 nu si com=s1\:/*,mb\:*,ex\:*/,b\:; fo=tcroq:

;Run("C:\Users\kirobins\Dropbox\AutoHotKey\GmailOutlookKeys.ahk")
;Run C:\Users\kirobins\Dropbox\AutoHotKey\windows10DesktopManager\windows10.ahk


;} ; V1toV2: Added bracket in the end

; Hotkeys only for MS-teams using the window class for that application.
; ahk 2.0 syntax for ifwinactive
#HotIf WinActive("ahk_class TeamsMainClass")
{

!/:: ; not working at all.
{
        ; shift-tab to go up.
        SendInput("{Shift Down}{Tab}{Shift Up}")

        SendInput("{Enter}")
        MsgBox("Emoji added to last message")
}
}


