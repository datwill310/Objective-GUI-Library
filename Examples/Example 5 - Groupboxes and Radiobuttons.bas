/'The following document is licensed under the 3-Clause BSD License, also called the "New
BSD License" or the "Modified BSD License". An on-line version of this license can be
found at www.opensource.org: https://opensource.org/licenses/BSD-3-Clause

"Copyright (c) 2016-2017, Daniel Atwill (datwill310).
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."'/

'this program demonstrates how to handle with radiobuttons and groupboxes

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create the MSG structure used to hold messages, our parent window, and our controls
dim as MSG msg
dim as GUIWIN win = GUIWIN(200, 150, 545, 140, "Radiobuttons Example")
dim as ulong gb1 = win.allowin(CT.BUTTON, 5, 5, 170, 90, "GroupBox 1", BS_GROUPBOX), _
	gb2 = win.allowin(CT.BUTTON, 180, 5, 170, 90, "GroupBox 2", BS_GROUPBOX), _
	gb3 = win.allowin(CT.BUTTON, 355, 5, 170, 90, "GroupBox 3", BS_GROUPBOX), _
	rb1a = win.allowin(CT.BUTTON, 10, 25, 150, 20, "RadioButton 1.a", BS_RADIOBUTTON), _
	rb1b = win.allowin(CT.BUTTON, 10, 45, 150, 20, "RadioButton 1.b", BS_RADIOBUTTON), _
	rb1c = win.allowin(CT.BUTTON, 10, 65, 150, 20, "RadioButton 1.c", BS_RADIOBUTTON), _
	rb2a = win.allowin(CT.BUTTON, 185, 25, 150, 20, "RadioButton 2.a", BS_RADIOBUTTON), _
	rb2b = win.allowin(CT.BUTTON, 185, 45, 150, 20, "RadioButton 2.b", BS_RADIOBUTTON), _
	rb2c = win.allowin(CT.BUTTON, 185, 65, 150, 20, "RadioButton 2.c", BS_RADIOBUTTON), _
	rb3a = win.allowin(CT.BUTTON, 360, 25, 150, 20, "RadioButton 3.a", BS_RADIOBUTTON), _
	rb3b = win.allowin(CT.BUTTON, 360, 45, 150, 20, "RadioButton 3.b", BS_RADIOBUTTON), _
	rb3c = win.allowin(CT.BUTTON, 360, 65, 150, 20, "RadioButton 3.c", BS_RADIOBUTTON)

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent_all(msg)
	
	'this is the code which handles with the radiobuttons.
	'usually, when using radiobuttons in groupboxes, you can select multiple radiobuttons,
	'so long as they are part of different groupboxes.
	'the OGL has not given support yet for this type of functionality,
	'therefore we are to perform this all manually:
	
	'first capture the clicking message
	if msg.message = WM_LBUTTONUP then
	
		'note that the radiobuttons we created are not automatic,
		'so we have to manually set the checked states of all our radiobuttons.
		'but in this case, it is good, because we want to allow the user the ability to select multiple radiobuttons
		select case msg.hwnd
			case win.hwin(rb1a)
				win.button_state(rb1a) = BS.CHECKED
				win.button_state(rb1b) = BS.UNCHECKED
				win.button_state(rb1c) = BS.UNCHECKED
			case win.hwin(rb1b)
				win.button_state(rb1a) = BS.UNCHECKED
				win.button_state(rb1b) = BS.CHECKED
				win.button_state(rb1c) = BS.UNCHECKED
			case win.hwin(rb1c)
				win.button_state(rb1a) = BS.UNCHECKED
				win.button_state(rb1b) = BS.UNCHECKED
				win.button_state(rb1c) = BS.CHECKED
			case win.hwin(rb2a)
				win.button_state(rb2a) = BS.CHECKED
				win.button_state(rb2b) = BS.UNCHECKED
				win.button_state(rb2c) = BS.UNCHECKED
			case win.hwin(rb2b)
				win.button_state(rb2a) = BS.UNCHECKED
				win.button_state(rb2b) = BS.CHECKED
				win.button_state(rb2c) = BS.UNCHECKED
			case win.hwin(rb2c)
				win.button_state(rb2a) = BS.UNCHECKED
				win.button_state(rb2b) = BS.UNCHECKED
				win.button_state(rb2c) = BS.CHECKED
			case win.hwin(rb3a)
				win.button_state(rb3a) = BS.CHECKED
				win.button_state(rb3b) = BS.UNCHECKED
				win.button_state(rb3c) = BS.UNCHECKED
			case win.hwin(rb3b)
				win.button_state(rb3a) = BS.UNCHECKED
				win.button_state(rb3b) = BS.CHECKED
				win.button_state(rb3c) = BS.UNCHECKED
			case win.hwin(rb3c)
				win.button_state(rb3a) = BS.UNCHECKED
				win.button_state(rb3b) = BS.UNCHECKED
				win.button_state(rb3c) = BS.CHECKED
		end select
	endif
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button
