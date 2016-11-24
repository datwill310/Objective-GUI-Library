'this program demonstrates what you can do with the STATICOBJ class

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create the MSG structure used to hold messages, and our controls
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(200, 200, 700, 400, "Static Objects in the OGL")
dim as STATICOBJ blackbox = STATICOBJ(5, 5, 200, 200, win.hwin, SO.BLACKFILL)
dim as STATICOBJ graybox = STATICOBJ(25, 25, 200, 200, win.hwin, SO.GRAYFILL)
dim as STATICOBJ whitebox = STATICOBJ(45, 45, 200, 200, win.hwin, SO.WHITEFILL, DS.STATO or WS_BORDER) 'remember that the white box has a border!
dim as STATICOBJ blackframe = STATICOBJ(325, 5, 200, 200, win.hwin, SO.BLACK)
dim as STATICOBJ grayframe = STATICOBJ(345, 25, 200, 200, win.hwin, SO.GRAY)
dim as STATICOBJ whiteframe = STATICOBJ(365, 45, 200, 200, win.hwin, SO.WHITE, DS.STATO)

'the LS enumeration simply contains the values 1 and 2,
'but they can be used to great effect with the STATICOBJ class and the dimension properties to produce lines
'(you can even choose their colour between the three demonstrated using the SO enumeration!)
dim as STATICOBJ horizontal = STATICOBJ(5, 255, 650, LS.THIN, win.hwin, , )
dim as STATICOBJ horizontalthick = STATICOBJ(5, 265, 650, LS.THICK, win.hwin)
dim as STATICOBJ vertical = STATICOBJ(280, 5, LS.THIN, 300, win.hwin)
dim as STATICOBJ verticalthick = STATICOBJ(290, 5, LS.THICK, 300, win.hwin)

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	'it even plays a part in the uponclose() method,
	'so always put this line of code at the beginning of your loop!
	waitevent(msg)
	
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the window we just created
win.destructor()
blackbox.destructor()
graybox.destructor()
whitebox.destructor()
blackframe.destructor()
grayframe.destructor()
whiteframe.destructor()
horizontal.destructor()
horizontalthick.destructor()
vertical.destructor()
verticalthick.destructor()

'deallocates the default font object: not used in this example
SYSFONT.destructor()
