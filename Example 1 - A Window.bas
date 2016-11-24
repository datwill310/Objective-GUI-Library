'this program demonstrates how to create a simple window

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create the MSG structure used to hold messages, and our simple window
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(300, 200, 300, 275, "My Window")

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent(msg)
	
	'if the user clicked the window with the left mouse button, open up a message box
	if msg.message = WM_LBUTTONUP then win.msgbox("You clicked me!")
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the window we just created
win.destructor()

'deallocates the default font object: not used in this example
SYSFONT.destructor()