
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
		tmp := Clipboard
		Clipboard := str
		Send, ^v
		Clipboard := tmp
	} else {
		SendInput, %str%
	}
}

; Use FreeCompose instead of CapsLock to create accented chars, etc.
;





:*?:kids````::
:*?:sk````::
	;timetil =  ; Make it blank so that the below will use the current time instead.
	;envadd,timetil,1, hours
	;MsgBox, %var1%  ; The answer will be the date 31 days from now.
	;formattime,var1,,h:mm

   timetil := A_Now
	;envadd,timetil,1, hours
   ;timetil += 1, hour

	FormatTime, formattedtime, timetil, hh:mm
	SendInput /status :kids: I have my kids for an hour or two (starting at %formattedtime%)
return
:*?:lunch````::
	SendInput /status :hamburger: lunch{Enter}
	Sleep 2000
	SendInput, {CTRLDOWN}{SHIFTDOWN}Y{CTRLUP}{SHIFTUP}{Tab 3}{Down 3}{Enter 2}
return

:*?:cron````::
	FormatTime, TimeString, A_Now, ss mm HH dd MM ? yyyy,2099
	; SendInput, %TimeString% ss_mm_HH_dd_MM_dayOfWeek_yyyy__NOW
	; FormatTime, TimeString, A_Now, 00 00 05 31 2 ? yyyy,2099
	SendInput, %TimeString%  ss_mm_HH_dd_MM_dayOfWeek_yyyy__NOW{CTRLDOWN}{SHIFTDOWN}{Left 8}{CTRLUP}{SHIFTUP}
return



; 12`` inputs 12:00 AM (for the sake of jira entry on previous days)
:*?:12````::12:00 AM

:*?:dj````::
:*?:jt````::
	; dj`` inputs a journal-based timestamp like this
	;tmp := clipboard ;save clipboard state.
	;  2014-04-13 (Sunday) 7:21 PM
	FormatTime, TimeString, A_Now, yyyy-MM-dd (dddd) hh:mm tt
	SendInput, %TimeString%
return

; Orchards Ward Weekly Email
:*?:oww````:: 
	FormatTime, TimeString, A_Now, MMMM /d, yyyy
	SendInput, Orchards Ward - Sunday Bulletin + Weekly Email, %TimeString%
return

; Orchards Ward Bulletin/Program 
:*?:owb````:: 
	theDate = %a_now%
	theDate += +1, days
	FormatTime, tomorrowString, %theDate%, dddd, MMM dd, yyyy 
	SendInput, Church Bulletin & Program for %tomorrowString%
return

; zoom topic chg
:*?:zoom````:: 
:*?:zoom;;:: 
	FormatTime, TimeString, A_Now, MMMM d, yyyy
	SendInput, /topic https://chghealthcare.zoom.us/my/kimball.robinson (zoom channel for %TimeString%)
return

; dt`` inputs a date.
:*?:dt````:: 
	FormatTime, TimeString, A_Now, MMMM d, yyyy
	SendInput, %TimeString%
return

:*?:dtt````::
:*?:dt1````::
	FormatTime, TimeString, A_Now, yyyy-MM-dd
	SendInput, %TimeString%
return

:*?:dt2````::
:*?:date````::
:*?:dts````::
	FormatTime, TimeString, A_Now, yyyy/MM/dd HH:mm:ss
	SendInput, %TimeString%
return


; ts`` inputs a timestamp.
:*?:ts````:: 
	FormatTime, TimeString, A_Now, h:mm:ss tt
	SendInput, %TimeString%
return

; tiat`` shows a "testing" message.
:*?:tt````:: 
	FormatTime, TimeString, A_Now, yyyy.MM.dd HH.mm.ss
	SendInput, This is a test.  Please disregard.  %TimeString%
return
; tm;; shows a "testing - notify" message.
:*?:tm;;:: 
	FormatTime, TimeString, A_Now, yyyy.MM.dd HH.mm.ss
	SendInput, This is a test.  If you receive this message/record, we apologize.  Please contact us and let us know.
return

; kjr`` inputs my name.
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
	soundget, isMute, MICROPHONE, MUTE
	if isMute = Off
		 toMute=1
	else
		 toMute=0
	SoundSet, toMute, MICROPHONE, MUTE
 	MsgBox, , Mute/Unmute, Changing microphone to %toMute% based on %isMute%, 50
return

#+r:: ;win-shift-r
	MsgBox, , Wrong key combo, Use win-alt-R instead, 3
return
:*?c:reload````::
!#r:: ;win-alt-r
^!r:: ;ctrl-alt-r
^#r:: ;ctrl-win-r
	SendMessage, 0x1A,,,, ahk_id 0xFFFF ; 0x1A is WM_SETTINGCHANGE 
	MsgBox, , Reloading, Reloading AutoHotkey script... and sending WM_SETTINGCHANGE event, 1
	Reload
return

#NumpadSub:: ; win + numpad subtract (prevent magnifier)
#NumpadAdd:: ; win + numpad subtract (prevent magnifier)
	MsgBox, , Override, "Preventing magnifier hotkey", .8
return

; Make Windows-Tab behave a little like alt-tab:

Add(x, y)
{
    return x + y   ; "Return" expects an expression.
}

currentDesktopGuess := 1
noOpMoveCount := 1

WinVisible(Title) {
	; from online, got this function
	DetectHiddenWindows Off ; Force to not detect hidden windows
	Return WinExist(Title) ; Return 0 for hidden windows or the ahk_id
	DetectHiddenWindows On ; Return to "normal" state
}

MoveTo(targetDesktop)
{
	global currentDesktopGuess
	global noOpMoveCount

	if (!currentDesktopGuess)
	{
		currentDesktopGuess := -1
	}

	if (!noOpMoveCount)
	{
		noOpMoveCount := 100
	}

	if (WinVisible("Desktop 8"))
	{
		;MsgBox, , Move to desktop, Moving to %currentDesktopGuess% -> %targetDesktop% diff %movement%, 1
	}
	movement := currentDesktopGuess - targetDesktop
	;MsgBox, 4,, "Moving " . %movement%
	;MsgBox, , Move to desktop, Moving to %currentDesktopGuess% -> %targetDesktop% diff %movement%, 1
	;TrayTip, "Mv", "Moving " . movement

	SetKeyDelay 120  ; sometimes I get it to 50, but sometimes it's 100 when things get iffy.  100 seems slow. 50 seems good.
	if (currentDesktopGuess < 0 || movement == 0)
	{
		; selecting a desktop twice suggests we could be in the wrong place and need a reset.
		noOpMoveCount := noOpMoveCount + 1
		if (noOpMoveCount > 1)
		{
			noOpMoveCount := 1
			rightArrows := targetDesktop - 1
			leftArrows = 9
			if (targetDesktop <= 5)
			{
				leftArrows = 9
				rightArrows := targetDesktop - 1
				Send, {LWin down}{Ctrl down}{Left %leftArrows%}{Right %rightArrows%}{Ctrl up}{LWin up}
			} else {
				leftArrows := 9 - targetDesktop
				rightArrows := 9
				Send, {LWin down}{Ctrl down}{Right %rightArrows%}{Left %leftArrows%}{Ctrl up}{LWin up}
			}
		} else {
			; MsgBox, , Move to desktop, It looks like you are already on desktop %currentDesktopGuess%--but repeat the keystroke to reset things (count is %noOpMoveCount%), 3
		}
	}
	else if (movement < 0)
	{
		offset := -movement
		noOpMoveCount := 1
		Send, {LWin down}{Ctrl down}{Right %offset%}{Ctrl up}{LWin up}
	}
	else if (movement > 0)
	{
		offset := movement
		noOpMoveCount := 1
		Send, {LWin down}{Ctrl down}{Left %offset%}{Ctrl up}{LWin up}
	}
	currentDesktopGuess := targetDesktop

;    return x + y   ; "Return" expects an expression.
}

#+Up::
; realign a couple windows to upper screens (work in progress, not working properly yet)
	Send, {LWin down}{Up}{LWin up}
	Send, {LWin down}{Shift down}{Left}{Shift up}{LWin up}
	Send, {Alt down}{tab}{Alt up}
	Send, {LWin down}{Up}{LWin up}
	Send, {LWin down}{Shift down}{Right}{Shift up}{LWin up}
return

; Windows+Number pad keys = Windows 10 desktop switching.
; number pad to match a 3x3 desktop
#Numpad1::
#NumpadEnd::
	MoveTo(1)
	return
#Numpad2::
#NumpadDown::
	MoveTo(2)
	return
#Numpad3::
#NumpadPgDn::
	MoveTo(3)
	return
#Numpad4::
#NumpadLeft::
	MoveTo(4)
	return
#Numpad5::
#NumpadClear::
	MoveTo(5)
	return
#Numpad6::
#NumpadRight::
	MoveTo(6)
	return
#Numpad7::
#NumpadHome::
	MoveTo(7)
	return
#Numpad8::
#NumpadUp::
	MoveTo(8)
	return
#Numpad9::
#NumpadPgUp::
	MoveTo(9)
	return
;	Send, {LWin down}{Tab}{LWin up}
;	Sleep, 3000
;	Send, {Tab 1}{Right 2}
;	Sleep, 3000
;	Send, {Enter}
;	Sleep, 3000
;	return
;
;	Bring up the "move this window to desktop..." menu.  Since the menu is always different, don't operate on it.  Just leave it at that.
#!Numpad0::
#!NumpadIns::
#+Numpad0::
#+NumpadIns::
#Numpad0::
#NumpadIns::
	Send, {LWin down}{Tab}{LWin up}
	Sleep, 400
	Send, {AppsKey}M
return

#NumpadDel::
#NumpadDot::
	Gui, New, , Desktop %currentDesktopGuess%
	Gui, Add, Text,, Desktop %currentDesktopGuess%
	; Gui, Add, Edit, vName
	Gui, Show
return

$#^Left::
	currentDesktopGuess := currentDesktopGuess - 1
	if (currentDesktopGuess < 1)
	{
		currentDesktopGuess := 1
	}

	Send, #^{Left}
return
$#^Right::
	currentDesktopGuess := currentDesktopGuess + 1
	if (currentDesktopGuess > 9)
	{
		currentDesktopGuess := 9
	}
	Send, #^{Right}
return

; Win+Alt+Enter launches Windows Media Center in Vista/7, which I occasionally
; accidentally hit. This disables/ignores that combination:
!#Enter::return

; Volume control with the mouse wheel:
;~RButton & WheelUp:: Send, {Volume_Up 5}
;~RButton & WheelDown:: Send, {Volume_Down 5} 
#WheelUp:: Send, {Volume_Up 5}
#WheelDown:: Send, {Volume_Down 5} 
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

:*?:tryitc;;::
	clipboard = 
(
hi there
hi
)
	SendInput, ^v
	SendInput, ^a^x
	Sleep, 200
	clipboard = %clipboard% ; transforms clipboard context to plain text -- no images, etc.
	SendInput, ^v
	Sleep, 200
	;SendInput t
return

:*?:tc;;:: 
:*?:tcronin;;:: 
:*?:tomc;;:: 
:*?:ll;;:: 
	; helps forward messages
	if WinActive("ahk_class rctrl_renwnd32")
	{
		SendInput, Tom Cronin <tcronin09@yahoo.com>
		SendInput, {Tab 5}

		clipboard =
(
There are new openings at my work.  I've included parts from the most recent email about openings, below, but you can always just follow this link.
https://careers-chghealthcare.icims.com/jobs/search?ss=1&searchLocation=-12828- 
As always, thanks for all your service as ward employment specialist.  If there is any way I can improve these emails or improve how I help let me know.

Kimball Robinson


)
		SendInput, ^v

		SendInput, ^a^x
		Sleep, 200
		clipboard = %clipboard% ; transforms clipboard context to plain text -- no images, etc.
		SendInput, ^v
		;Sleep, 2000
		;SendInput, {Shift Down}{down 12}{shift up}{delete}
		SendInput, {enter}
		SendInput, {down 5}
		SendInput, {Ctrl Down}{Home}{Ctrl Up}
		SendInput, {Down}{End}{Space}
		SendInput, {Ctrl Down}{Enter}{Ctrl Up}

		; select the "froM" field quickly, since it can be wrong.
		;SendInput, !m
		
		; SendInput, {Shift Down}{down 6}{shift up}{delete}

	}
return

global whiteBackgroundIndex := 1

#!b::
#!m::
	; Win-Alt-B (or M) On migraine days, I want a quick way to choose a friendly background that works with 'negative screen', even if in a clunky way.
	Directory := "C:\Users\kirobins\Dropbox\Backgrounds-Work\Artistic\White (inverted migraines)\"
	Directory2 := "C:\Users\kirobins\Dropbox\Backgrounds-Work\Artistic\White (inverted migraines)\inverted"
	fileArray := []
	Loop %Directory%\*.*
	{
		if A_LoopFileAttrib contains H,R,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
			continue
		if (A_LoopFileSizeKB > 1)
		{
			fileArray.push(A_LoopFileFullPath)
		}
	}
	Loop %Directory2%\*.*
	{
		if A_LoopFileAttrib contains H,R,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
			continue
		if (A_LoopFileSizeKB > 1)
		{
			fileArray.push(A_LoopFileFullPath)
		}
	}
	whiteBackgroundIndex += 1
	if ( whiteBackgroundIndex > fileArray.MaxIndex())
	{
		whiteBackgroundIndex := 1
	}
	fileToChoose := fileArray[whiteBackgroundIndex]
	DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, fileToChoose, UInt, 2)
	RegWrite, REG_SZ, HKCU, Control Panel\Desktop, WallpaperStyle, 10
	RegWrite, REG_SZ, HKCU, Control Panel\Desktop, TileWallpaper, 0
	
return

#^v::
	; https://autohotkey.com/board/topic/32013-using-clipboard-and-string-split/
	MsgBox, 4,, "This hotkey (ctrl win v) adds multiple tasks to todoist from the clipboard.  Continue?"
	IfMsgBox Yes
		continueFlag = yes
	else
		return

	originalClipboard = %Clipboard%

	InputBox, when , New Task due date, enter when to do it in todoist style, , 320,240,,,,,today
	;parse on newline, ignoring carriage returns.
	originalClipboard := Trim(originalClipboard)
	Loop, Parse,originalClipboard , `n, `r 
	{ 
		newTask := Trim(A_LoopField)
		if (newTask != "" && newTask)
		{
			; hotkey for a new task...
			SendInput, q
			; give time for the interface to catch up--otherwise we get really strange results.
			Sleep 100
			;clipboard = %newTask%
			;clipwait 2
			SendRaw, %when% %newTask%
			SendInput {Enter}
			; give time for the interface to catch up--otherwise we get really strange results.
			Sleep 100
		}
	} 
	clipboard = %originalClipboard%
return


#c:: ;win-ctrl-c
	if WinActive("ahk_class rctrl_renwnd32")
	{
		MsgBox, , "Copying", "Copying Email To Clipboard", .5
		SendInput, {CTRLDOWN}r{CTRLUP}
		SendInput, {Tab 4}
		SendInput, {CTRLDOWN}f{CTRLUP}Original{Enter} ;{SHIFTDOWN}={SHIFTUP}
		SendInput, {ESC}
		SendInput, {Home}
		SendInput, {CTRLDOWN}{SHIFTDOWN}{End}{CTRLUP}{SHIFTUP}
		SendInput, {CTRLDOWN}c{CTRLUP}
		SendInput, {ESC}
	}
	if WinActive("ahk_class #32770")
	{
		SendInput, n
	}
return


!#s::
	; win-alt-s restart sharemouse
	Gui, Add, Text, ,Killing and Restarting Sharemouse.
	Gui, Add, Button, gGUIClose, Ok
	Gui, Show, Center, Msgbox
    
	Process,Close,ShareMouse.exe
	RunWait, taskkill /IM ShareMouse.exe /F, , Hide
	Run,"C:\Program Files (x86)\ShareMouse\ShareMouse.exe", "C:\Program Files (x86)\ShareMouse\",
	Gui, Destroy
return

GUIClose:
    Gui, Destroy
Return

!#z::
	; win-alt-z kills grindstone.
	Process,Close,GS3.exe
	MsgBox, , "Killing grindstone", "Shutting down grindstone", 3
	MsgBox, 1, "Restart grindstone?", "Restart grindstone (will proceed automatically in 15 seconds)", 15
	IfMsgBox, OK
		Run,"C:\Users\kirobins\AppData\Local\Grindstone 3\GS3.exe", ,
	IfMsgBox, TIMEOUT
		Run,"C:\Users\kirobins\AppData\Local\Grindstone 3\GS3.exe", ,
return

#!k::
	MouseGetPos, xpos, ypos 
	Msgbox, , , The cursor is at X%xpos% Y%ypos%. , 2
	CoordMode, Mouse, Screen

return


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

Run C:\Users\kirobins\Dropbox\AutoHotKey\GmailOutlookKeys.ahk
;Run C:\Users\kirobins\Dropbox\AutoHotKey\windows10DesktopManager\windows10.ahk
