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

'this program demonstrates how to use a listbox, particularly a multi-select one
'you will also find how to assign an icon to a window in this example!

'include the header files
#include "OGL.bi"
#include "dir.bi" 'included for the constants used with dir

'bring the OGL namespace into scope
using OGL

'define directory searching macro
#macro fileupdate
	if chdir(*win.caption(dirbox)) = 0 then
		win.list_clear(explorer)
		
		'firstly, only accept folders
		dim as integer attrib_mask = fbDirectory
		dim as string filename = dir("*.*", attrib_mask)
		do until len(filename) = 0 'loop until dir returns empty string indicating that there are no more items in the current directory
			if filename <> "." and filename <> ".." then 'ignore current and parent directory entries
				win.list_additem(explorer) = "Folder - " & filename
			endif
			filename = dir
		loop
		
		'now find files
		attrib_mask = fbNormal or fbHidden or fbSystem
		filename = dir("*.*", attrib_mask)
		do until len(filename) = 0 'loop until dir returns empty string indicating that there are no more items in the current directory
			win.list_additem(explorer) = "File - " & filename
			filename = dir
		loop
	else
		win.msgbox("Directory does not exist!", "Error!", MB_ICONHAND or MB_APPLMODAL)
		win.caption(dirbox) = curdir
	endif
#endmacro

'create the MSG structure used to hold messages, our parent window, and our controls
dim as MSG msg
dim as GUIWIN win = GUIWIN(300, 200, 600, 500, "Simple File Explorer")
dim as ulong explorer = win.allowin(CT.MS_LISTBOX, 5, 40, 575, 415), _
	dirbox = win.allowin(CT.EDIT, 5, 5, 450, 30, curdir), _
	gobtn = win.allowin(CT.BUTTON, 460, 5, 100, 30, "Go!")

'allocate the icon for our window, and set it
win.image(0) = win.alloimg(true, "example4icon.ico")

'now assign the current directory's items to the listbox
fileupdate

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent_all(msg)
	
	'when button is clicked, update listbox with new items
	if msg.message = WM_LBUTTONUP and msg.hwnd = win.hwin(gobtn) then
		fileupdate
	endif
	
	'when the user middle clicks the listbox, a message box appears, giving how many items were selected and what those items were
	'NB: NL is an OGL constant which basically means a new line! It is made of TWO characters: chr(13) and chr(10),
	'you should use it when you want to include a new line in your GUI programs
	if msg.message = WM_MBUTTONUP and msg.hwnd = win.hwin(explorer) then
		dim as string boxmsg = "Total Items Selected: " & win.mslist_selcount(explorer) & NL & NL & "Items selected:" & NL
		dim as ulong ptr selected = win.mslist_sel(explorer)
		if selected <> NULL then 'if items were selected, then display them:
			dim as TIINFO indexes 'create TIINFO structure to ferry multiple indexes to our properties
			indexes.istart = explorer 'the listbox we want to work with will always be the explorer, so set it outside the loop
			for i as ulong = 1 to win.mslist_selcount(explorer)
				indexes.iend = selected[i-1] 'get the indexes of the selected items
				boxmsg &= *win.list_item(indexes) & NL
			next
			win.msgbox(boxmsg, , MB_ICONINFORMATION or MB_APPLMODAL)
			deallocate(selected) 'make sure to deallocate the list of indexes!
		else 'if no items were selected
			win.msgbox("Please select a few items before middle-clicking.", , MB_ICONINFORMATION or MB_APPLMODAL)
		endif
	end if
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button
