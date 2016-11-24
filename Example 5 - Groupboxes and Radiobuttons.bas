'this program demonstrates how to handle with radiobuttons and groupboxes

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create the MSG structure used to hold messages, and our controls
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(200, 150, 545, 140, "Radiobuttons Example")
dim as GROUPBOX gb1 = GROUPBOX(5, 5, 170, 90, win.hwin, "GroupBox 1")
dim as GROUPBOX gb2 = GROUPBOX(180, 5, 170, 90, win.hwin, "GroupBox 2")
dim as GROUPBOX gb3 = GROUPBOX(355, 5, 170, 90, win.hwin, "GroupBox 3")
dim as RADIOBUTTON rb1a = RADIOBUTTON(10, 25, 150, 20, win.hwin, "RadioButton 1.a", , , , , , false)
dim as RADIOBUTTON rb1b = RADIOBUTTON(10, 45, 150, 20, win.hwin, "RadioButton 1.b", , , , , , false)
dim as RADIOBUTTON rb1c = RADIOBUTTON(10, 65, 150, 20, win.hwin, "RadioButton 1.c", , , , , , false)
dim as RADIOBUTTON rb2a = RADIOBUTTON(185, 25, 150, 20, win.hwin, "RadioButton 2.a", , , , , , false)
dim as RADIOBUTTON rb2b = RADIOBUTTON(185, 45, 150, 20, win.hwin, "RadioButton 2.b", , , , , , false)
dim as RADIOBUTTON rb2c = RADIOBUTTON(185, 65, 150, 20, win.hwin, "RadioButton 2.c", , , , , , false)
dim as RADIOBUTTON rb3a = RADIOBUTTON(360, 25, 150, 20, win.hwin, "RadioButton 3.a", , , , , , false)
dim as RADIOBUTTON rb3b = RADIOBUTTON(360, 45, 150, 20, win.hwin, "RadioButton 3.b", , , , , , false)
dim as RADIOBUTTON rb3c = RADIOBUTTON(360, 65, 150, 20, win.hwin, "RadioButton 3.c", , , , , , false)

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent(msg)
	
	'this is the code which handles with the radiobuttons.
	'usually, when using radiobuttons in groupboxes, you can select multiple radiobuttons,
	'so long as they are part of different groupboxes.
	'the Windows API, nor the OGL, handles with this automatically, you will have to program this yourself.
	
	'first capture the clicking message
	if msg.message = WM_LBUTTONUP then
	
		'note that the radiobuttons we created are not automatic,
		'so we have to manually set the checked states of all our radiobuttons.
		'but in this case, it is good, because we want to allow the user the ability to select multiple radiobuttons
		select case msg.hwnd
			case rb1a.hwin
				rb1a.state = true
				rb1b.state = false
				rb1c.state = false
			case rb1b.hwin
				rb1a.state = false
				rb1b.state = true
				rb1c.state = false
			case rb1c.hwin
				rb1a.state = false
				rb1b.state = false
				rb1c.state = true
			case rb2a.hwin
				rb2a.state = true
				rb2b.state = false
				rb2c.state = false
			case rb2b.hwin
				rb2a.state = false
				rb2b.state = true
				rb2c.state = false
			case rb2c.hwin
				rb2a.state = false
				rb2b.state = false
				rb2c.state = true
			case rb3a.hwin
				rb3a.state = true
				rb3b.state = false
				rb3c.state = false
			case rb3b.hwin
				rb3a.state = false
				rb3b.state = true
				rb3c.state = false
			case rb3c.hwin
				rb3a.state = false
				rb3b.state = false
				rb3c.state = true
		end select
	endif
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the window we just created
win.destructor()
gb1.destructor()
gb2.destructor()
gb3.destructor()
rb1a.destructor()
rb1b.destructor()
rb1c.destructor()
rb2a.destructor()
rb2b.destructor()
rb2c.destructor()
rb3a.destructor()
rb3b.destructor()
rb3c.destructor()

'deallocates the default font object
SYSFONT.destructor()