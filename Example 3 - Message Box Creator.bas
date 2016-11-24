'this program demonstrates how to work with comboboxes and checkboxes, as well as some other stuff

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create a GUIFONT object to hold bold text
dim as GUIFONT boldfont = GUIFONT(, , , FW_BOLD)

'create the MSG structure used to hold messages, and our controls
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(100, 150, 415, 415, "Message Box Creator", WS_VISIBLE or WS_SYSMENU or WS_CAPTION)
dim as LABEL lbl1 = LABEL(5, 5, 150, 25, win.hwin, "Message Box Contents:")
dim as TEXTBOX msgstr = TEXTBOX(5, 30, 400, 100, win.hwin, , , TB_FULLMULTILINE)
dim as LABEL lbl2 = LABEL(5, 130, 140, 25, win.hwin, "Message Box Caption:")
dim as TEXTBOX capstr = TEXTBOX(5, 155, 400, 20, win.hwin, "Attention!", , DS.TB)
dim as COMBOBOX icons = COMBOBOX(5, 185, 150, 200, win.hwin, , , WS_VISIBLE or CBS_DROPDOWNLIST)
dim as COMBOBOX buttons = COMBOBOX(160, 185, 200, 200, win.hwin, , , WS_VISIBLE or CBS_DROPDOWNLIST)
dim as COMBOBOX default = COMBOBOX(365, 185, 40, 200, win.hwin, , , WS_VISIBLE or CBS_DROPDOWNLIST)
dim as COMBOBOX modal = COMBOBOX(5, 215, 150, 200, win.hwin, , , WS_VISIBLE or CBS_DROPDOWNLIST)
dim as CHECKBOX style1 = CHECKBOX(160, 215, 220, 20, win.hwin, "MB_DEFAULT_DESKTOP_ONLY")
dim as CHECKBOX style2 = CHECKBOX(160, 240, 220, 20, win.hwin, "MB_RIGHT")
dim as CHECKBOX style3 = CHECKBOX(160, 265, 220, 20, win.hwin, "MB_RTLREADING")
dim as CHECKBOX style4 = CHECKBOX(160, 290, 220, 20, win.hwin, "MB_SETFOREGROUND")
dim as CHECKBOX style5 = CHECKBOX(160, 315, 220, 20, win.hwin, "MB_TOPMOST")
dim as CHECKBOX style6 = CHECKBOX(160, 340, 220, 20, win.hwin, "MB_SERVICE_NOTIFICATION")
dim as BUTTON create = BUTTON(5, 245, 150, 110, win.hwin, "Create!", boldfont.fonth)
dim as LABEL sel = LABEL(5, 360, 300, 20, win.hwin, "Last button pressed: No message box created yet!")

'add options into comboboxes, and select appropriate items in each
icons.additem("No icon")
icons.additem("! - Exclamation")
icons.additem("i - Information")
icons.additem("X - Error")
icons.additem("? - Question")
icons.selection = 0 'select first item

buttons.additem("Abort, Retry, Ignore")
buttons.additem("Cancel, Try Again, Continue")
buttons.additem("OK")
buttons.additem("OK, Cancel")
buttons.additem("Retry, Cancel")
buttons.additem("Yes, No")
buttons.additem("Yes, No, Cancel")
buttons.selection = 2 'select third item

default.additem("1")
default.additem("2")
default.additem("3")
default.additem("4")
default.selection = 0

modal.additem("APPLMODAL")
modal.additem("SYSTEMMODAL")
modal.additem("TASKMODAL")
modal.selection = 0

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent(msg)
	
	'when the user clicks the button, the message box will be generated
	if msg.message = WM_LBUTTONUP and msg.hwnd = create.hwin then
		'assign flags based on user input
		dim as ulong flags
		select case icons.selection
			case 1
				flags or= MB_ICONEXCLAMATION
			case 2
				flags or= MB_ICONINFORMATION
			case 3
				flags or= MB_ICONERROR
			case 4
				flags or= MB_ICONQUESTION
		end select
		select case buttons.selection
			case 0
				flags or= MB_ABORTRETRYIGNORE
			case 1
				flags or= MB_CANCELTRYCONTINUE
			case 2
				flags or= MB_OK
			case 3
				flags or= MB_OKCANCEL
			case 4
				flags or= MB_RETRYCANCEL
			case 5
				flags or= MB_YESNO
			case 6
				flags or= MB_YESNOCANCEL
		end select
		select case default.selection
			case 0
				flags or= MB_DEFBUTTON1
			case 1
				flags or= MB_DEFBUTTON2
			case 2
				flags or= MB_DEFBUTTON3
			case 3
				flags or= MB_DEFBUTTON4
		end select
		select case modal.selection
			case 0
				flags or= MB_APPLMODAL
			case 1
				flags or= MB_SYSTEMMODAL
			case 2
				flags or= MB_TASKMODAL
		end select
		if style1.state = true then flags or= MB_DEFAULT_DESKTOP_ONLY
		if style2.state = true then flags or= MB_RIGHT
		if style3.state = true then flags or= MB_RTLREADING
		if style4.state = true then flags or= MB_SETFOREGROUND
		if style5.state = true then flags or= MB_TOPMOST
		if style6.state = true then flags or= MB_SERVICE_NOTIFICATION
		
		'create the message box!
		dim as long ret = win.msgbox(msgstr.caption, capstr.caption, flags)
		
		'tell the user what button they pressed
		select case ret
			case IDABORT
				sel.caption = "Last button pressed: Abort"
			case IDCANCEL
				sel.caption = "Last button pressed: Cancel"
			case IDCONTINUE
				sel.caption = "Last button pressed: Continue"
			case IDIGNORE
				sel.caption = "Last button pressed: Ignore"
			case IDNO
				sel.caption = "Last button pressed: No"
			case IDOK
				sel.caption = "Last button pressed: OK"
			case IDRETRY
				sel.caption = "Last button pressed: Retry"
			case IDTRYAGAIN
				sel.caption = "Last button pressed: Try Again"
			case IDYES
				sel.caption = "Last button pressed: Yes"
		end select
	endif
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the controls we just created
win.destructor()
lbl1.destructor()
msgstr.destructor()
lbl2.destructor()
capstr.destructor()
icons.destructor()
buttons.destructor()
default.destructor()
modal.destructor()
style1.destructor()
style2.destructor()
style3.destructor()
style4.destructor()
style5.destructor()
style6.destructor()
sel.destructor()
create.destructor()
boldfont.destructor()

'deallocates the default font object
SYSFONT.destructor()