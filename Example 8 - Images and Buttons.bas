'this program demonstrates how to work with push buttons and images

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'load our images
dim as HICON happy = loadico("example4icon.ico"), sad = loadico("example8icon.ico")
dim as HBITMAP blue = loadbmp("blueexample8.bmp", 48, 48), red = loadbmp("redexample8.bmp", 48, 48)

'create the MSG structure used to hold messages, and our controls
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(300, 200, 300, 275, "My Window")
dim as BUTTON iconbtn = BUTTON(5, 5, 40, 40, win.hwin, , , sad, DS.BTN or BS_ICON)
dim as BUTTON bitmapbtn = BUTTON(60, 5, 50, 50, win.hwin, , , blue, DS.BTN or BS_BITMAP)

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent(msg)
	
	if msg.message = WM_LBUTTONDOWN then
		if msg.hwnd = iconbtn.hwin then iconbtn.image = happy
		if msg.hwnd = bitmapbtn.hwin then bitmapbtn.image = red
	elseif msg.message = WM_LBUTTONUP then
		if msg.hwnd = iconbtn.hwin then iconbtn.image = sad
		if msg.hwnd = bitmapbtn.hwin then bitmapbtn.image = blue
	endif
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the window we just created
win.destructor()
iconbtn.destructor()
bitmapbtn.destructor()

'destroy images
DestroyIcon(happy)
DestroyIcon(sad)
DeleteObject(blue)
DeleteObject(red)

'deallocates the default font object: not used in this example
SYSFONT.destructor()