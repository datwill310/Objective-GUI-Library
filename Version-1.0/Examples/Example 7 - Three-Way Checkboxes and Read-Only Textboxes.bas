'this program demonstrates the three-way checkbox, and a read-only textbox
'it also serves as a good demonstration of the manifest file

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create the MSG structure used to hold messages, and our simple window
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(300, 200, 600, 275, "Three-Way Checkboxes")
dim as TEXTBOX desc = TEXTBOX(5, 5, 400, 20, win.hwin, "The three-way checkbox is unchecked right now.", , DS.TB or ES_READONLY)
dim as CHECKBOX3WAY cb = CHECKBOX3WAY(5, 30, 300, 20, win.hwin, "Three-Way Checbox")

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent(msg)
	
	if msg.message = WM_LBUTTONUP and msg.hwnd = cb.hwin then
		if cb.state = CB3W.CHECKED then desc.caption = "The three-way checkbox is checked right now."
		if cb.state = CB3W.UNCHECKED then desc.caption = "The three-way checkbox is unchecked right now."
		if cb.state = CB3W.INDETERMINATE then desc.caption = "The three-way checkbox is in an indeterminate state."
	endif
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the window we just created
win.destructor()
desc.destructor()
cb.destructor()

'deallocates the default font object: not used in this example
SYSFONT.destructor()
