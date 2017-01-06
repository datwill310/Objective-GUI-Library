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
