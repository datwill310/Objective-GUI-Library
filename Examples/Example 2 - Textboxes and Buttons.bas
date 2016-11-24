'this program demonstrates how to work with a textbox and a push button

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create the MSG structure used to hold messages, and our controls
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(350, 200, 300, 275, "Form")
dim as TEXTBOX edit = TEXTBOX(5, 5, 250, 20, win.hwin, , , DS.TB or WS_BORDER)
dim as BUTTON btn = BUTTON(5, 35, 175, 30, win.hwin, "Display Contents")

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent(msg)
	
	'the the user clicked the button, display the textbox' contents
	if msg.message = WM_LBUTTONUP and msg.hwnd = btn.hwin then win.msgbox(edit.caption)
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the controls we just created
win.destructor()
edit.destructor()
btn.destructor()

'deallocates the default font object
SYSFONT.destructor()