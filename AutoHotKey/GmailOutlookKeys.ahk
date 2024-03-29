;*******************************************************************************
; Information
;*******************************************************************************
; AutoHotkey Version: 3.x
; Language: English
; Platform: XP/Vista/7
; Updated by: Toby Garcia
; Previously updated by: Ty Myrick
; Author: Lowell Heddings (How-To Geek)
; URL: http://lifehacker.com/5175724/.....gmail-keys
; Original script by: Jayp
; Original URL: http://www.ocellated.com/2009/.....t-outlook/
;
; Script Function: Gmail Keys adds Gmail Shortcut Keys to Outlook
; Version 3.x updated for Outlook 2013
;
;*******************************************************************************
; Version History
;*******************************************************************************
; Version 3.1 - added delete & spam functionality and enabled move/star funcs
; Version 3.0 - updated by Toby Garcia to work with Outlook 2013
; Version 2.0 - updated by Ty Myrick to work with Outlook 2010
; Version 1.0 - updated by Lowell Heddings
; Version 0.1 - initial set of hotkeys by Jayp
;*******************************************************************************
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 2 ;allow partial match to window titles
;************************
;Hotkeys for Outlook 2013
;************************
;As best I (Ty Myrick) can tell, the window text 'NUIDocumentWindow' is not present on 
;any other items except the main window. Also, I look for the phrase ' - Microsoft Outlook'
;in the title, which will not appear in the title (unless a user types this string into the
;subject of a message or task).
;#IfWinActive, - Microsoft Outlook ahk_class rctrl_renwnd32, NUIDocumentWindow	;for Outlook 2010, uncomment this line
#IfWinActive, - Outlook ahk_class rctrl_renwnd32, NUIDocumentWindow		;for Outlook 2013, uncomment this line
y::HandleOutlookKeys("^+2", "y") ;archive message using Quick Steps hotkey (ctrl+Shift+2)
e::HandleOutlookKeys("^+2", "e") ;archive message using Quick Steps hotkey (ctrl+Shift+2)
f::HandleOutlookKeys("^f", "f") ;forwards message
r::HandleOutlookKeys("^r", "r") ;replies to message
a::HandleOutlookKeys("^+r", "a") ;reply all
v::HandleOutlookKeys("^+v", "v") ;move message box
+u::HandleOutlookKeys("^u", "+u") ;marks messages as unread
+i::HandleOutlookKeys("^q", "+i") ;marks messages as read
j::HandleOutlookKeys("{Down}", "j") ;move down in list
+j::HandleOutlookKeys("+{Down}", "+j") ;move down and select next item
k::HandleOutlookKeys("{Up}", "k") ;move up
+k::HandleOutlookKeys("+{Up}", "+k") ;move up and select next item
o::HandleOutlookKeys("^o", "o") ;open message
s::HandleOutlookKeys("{Insert}", "s") ;toggle flag (star)
; s::HandleOutlookKeys("^+g", "s") ;set follow up options (star)
c::HandleOutlookKeys("^n", "c") ;new message
/::HandleOutlookKeys("^e", "/") ;focus search box
.::HandleOutlookKeys("+{F10}", ".") ;Display context menu
;l::HandleOutlookKeys("!3", "l") ;categorize message using All Categories hotkey in Quick Access Toolbar (Alt+3)
;+3::HandleOutlookKeys("{Delete}", "+3") ;delete selected message(s)
^+j::HandleOutlookKeys("!4", "+1") ;Mark message as spam using Block Sender hotkey in Quick Access Toolbar (Alt+4)
+1::HandleOutlookKeys("!4", "+1") ;Mark message as spam using Block Sender hotkey in Quick Access Toolbar (Alt+4)
#IfWinActive
;Passes Outlook a special key combination for custom keystrokes or normal key value, depending on context
HandleOutlookKeys( specialKey, normalKey )
{
;Activates key only on main outlook window, not messages, tasks, contacts, etc.
;IfWinActive, - Microsoft Outlook ahk_class rctrl_renwnd32, NUIDocumentWindow, ,	;for Outlook 2010, uncomment this line
IfWinActive, - Outlook ahk_class rctrl_renwnd32, NUIDocumentWindow, ,			;for Outlook 2013, uncomment this line
{
;Find out which control in Outlook has focus
ControlGetFocus currentCtrl, A
; MsgBox, Control with focus = %currentCtrl%
;Set list of controls that should respond to specialKey. Controls are the list of emails and the main
;(and minor) controls of the reading pane, including controls when viewing certain attachments.
;Currently I handle archiving when viewing attachments of Word, Excel, Powerpoint, Text, jpgs, pdfs
;The control 'RichEdit20WPT1' (email subject line) is used extensively for inline editing. Thus it 
;had to be removed. If an email's subject has focus, it won't archive...
ctrlList = Acrobat Preview Window1,AfxWndW5,AfxWndW6,EXCEL71,MsoCommandBar1,OlkPicturePreviewer1,paneClassDC1,OutlookGrid1,OutlookGrid2,RichEdit20WPT2,RichEdit20WPT4,RichEdit20WPT5,RICHEDIT50W1,SUPERGRID2,SUPERGRID1,_WwG1
if currentCtrl in %ctrlList%
{
; MsgBox, Control in list.
Send %specialKey%
}
;Allow typing normalKey somewhere else in the main Outlook window. (Like the search field or the folder pane.)
else
{
; MsgBox, Control not in list.
Send %normalKey%
}
}
;Allow typing normalKey in another window type within Outlook, like a mail message, task, appointment, etc.
else
{
Send %normalKey%
}
}
