/'The following document is licensed under the 3-Clause BSD License, also called the "New
BSD License" or the "Modified BSD License". An on-line version of this license can be
found at www.opensource.org: https://opensource.org/licenses/BSD-3-Clause

"Copyright 2016-17 Daniel Atwill (datwill310)

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of
   conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of
   conditions and the following disclaimer in the documentation and/or other materials
   provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific prior
   written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

Please read License.md'/

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
