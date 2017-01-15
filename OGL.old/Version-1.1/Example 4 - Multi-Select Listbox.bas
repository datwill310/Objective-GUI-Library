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

'this program demonstrates how to use a listbox, particularly a multi-select one
'you will also find how to assign an icon to a window in this example!

'include the header files
#include "OGL.bi"
#include "dir.bi" 'included for the constants used with dir

'bring the OGL namespace into scope
using OGL

'define directory searching macro
#macro fileupdate
	if chdir(*dirbox.caption) = 0 then
	'default parameter is -1, which clears the list
		explorer.removeitem
		
		'firstly, only accept folders
		dim as integer attrib_mask = fbDirectory
		dim as string filename = dir("*.*", attrib_mask)
		do until len(filename) = 0 'loop until dir returns empty string indicating that there are no more items in the current directory
			if filename <> "." and filename <> ".." then 'ignore current and parent directory entries
				explorer.additem("Folder - " & filename)
			endif
			filename = dir
		loop
		
		'now find files
		attrib_mask = fbNormal or fbHidden or fbSystem
		filename = dir("*.*", attrib_mask)
		do until len(filename) = 0 'loop until dir returns empty string indicating that there are no more items in the current directory
			explorer.additem("File - " & filename)
			filename = dir
		loop
	else
		win.msgbox("Directory does not exist!", "Error!", MB_ICONEXCLAMATION or MB_APPLMODAL)
		dirbox.caption = curdir
	endif
#endmacro

'load the icon for our window!
dim as HICON ico = loadico("example4icon.ico")

'create the MSG structure used to hold messages, and our controls
dim as MSG msg 
dim as APPWINDOW win = APPWINDOW(300, 200, 600, 500, "Simple File Explorer", , , , ico)
dim as LISTBOX explorer = LISTBOX(5, 40, 575, 415, win.hwin, , DS.LB or LBS_EXTENDEDSEL)
dim as TEXTBOX dirbox = TEXTBOX(5, 5, 450, 30, win.hwin, curdir)
dim as BUTTON gobtn = BUTTON(460, 5, 100, 30, win.hwin, "Go!")

'now assign the current directory's items to the listbox
fileupdate

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent(msg)
	
	'when button is clicked, update listbox with new items
	if msg.message = WM_LBUTTONUP and msg.hwnd = gobtn.hwin then
		fileupdate
	endif
	
	'when the user middle clicks the listbox, a message box appears, giving how many items were selected and what those items were
	'nb: NL is an OGL constant which basically means a new line! It is made of TWO characters: chr(13) and chr(10),
	'you should use it when you want to include a new line in your GUI programs
	if msg.message = WM_MBUTTONUP and msg.hwnd = explorer.hwin then
		dim as string boxmsg = "Total Items Selected: " & explorer.selectioncount & NL & NL & "Items selected:" & NL
		dim as ulong ptr selected = explorer.getselitemsindex(explorer.selectioncount)
		for i as ulong = 1 to explorer.selectioncount
			boxmsg &= explorer.itemtext(selected[i-1]) & NL
		next
		win.msgbox(boxmsg, "Message", MB_ICONINFORMATION or MB_APPLMODAL)
		deallocate(selected) 'male sure to deallocate the list of indexes!
	end if
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button

'destroy the window we just created
win.destructor()
explorer.destructor()
dirbox.destructor()
gobtn.destructor()
DestroyIcon(ico)

'deallocates the default font object
SYSFONT.destructor()
