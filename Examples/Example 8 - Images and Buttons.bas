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

'this program demonstrates how to work with push buttons and images

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'load our images
dim as HICON happy = loadico("example4icon.ico"), sad = loadico("example8icon.ico")
dim as HBITMAP blue = loadbmp("blueexample8.bmp", 48, 48), red = loadbmp("redexample8.bmp", 48, 48)

'create the MSG structure used to hold messages, out parent window, and its controls
dim as MSG msg 
dim as GUIWIN win = GUIWIN(300, 200, 300, 275, "My Window")
dim as ulong iconbtn = win.allowin(CT.BUTTON, 5, 5, 40, 40, , BS_ICON), _
	bitmapbtn = win.allowin(CT.BUTTON, 60, 5, 50, 50, , BS_BITMAP)

'allocate our images, and assign them
dim as ulong icohappy = win.alloimg(true, "example4icon.ico"), _
	icosad = win.alloimg(true, "example8icon.ico"), _
	bmpblue = win.alloimg(false, "blueexample8.bmp", 48, 48), _
	bmpred = win.alloimg(false, "redexample8.bmp", 48, 48)
win.image(iconbtn) = icosad
win.image(bitmapbtn) = bmpblue

'we can use the same image twice!
win.image(0) = icosad

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent_all(msg)
	
	if msg.message = WM_LBUTTONDOWN then
		if msg.hwnd = win.hwin(iconbtn) then win.image(iconbtn) = icohappy
		if msg.hwnd = win.hwin(bitmapbtn) then win.image(bitmapbtn) = bmpred
	elseif msg.message = WM_LBUTTONUP then
		if msg.hwnd = win.hwin(iconbtn) then win.image(iconbtn) = icosad
		if msg.hwnd = win.hwin(bitmapbtn) then win.image(bitmapbtn) = bmpblue
	endif
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button
