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

'this program demonstrates how to work with comboboxes and checkboxes, as well as some other stuff

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create a GUIFONT object to hold bold text
dim as GUIFONT boldfont = GUIFONT("arial", , , FW_BOLD)

'create the MSG structure used to hold messages, our parent window, and our controls
dim as MSG msg
dim as GUIWIN win = GUIWIN(100, 150, 425, 425, "Message Box Creator", WS_OVERLAPPEDWINDOW or WS_SYSMENU or WS_CAPTION)
dim as ulong lbl1 = win.allowin(CT.LABEL, 5, 5, 150, 25, "Message Box Contents:"), _
	msgstr = win.allowin(CT.ML_EDIT, 5, 30, 400, 100), _
	lbl2 = win.allowin(CT.LABEL, 5, 130, 140, 25, "Message Box Caption:"), _
	capstr = win.allowin(CT.EDIT, 5, 155, 400, 20, "Attention!"), _
	icons = win.allowin(CT.COMBOBOX, 5, 185, 150, 200), _
	buttons = win.allowin(CT.COMBOBOX, 160, 185, 200, 200), _
	default = win.allowin(CT.COMBOBOX, 365, 185, 40, 200), _
	modal = win.allowin(CT.COMBOBOX, 5, 215, 150, 200), _
	style1 = win.allowin(CT.BUTTON, 160, 215, 220, 20, "MB_DEFAULT_DESKTOP_ONLY", BS_AUTOCHECKBOX), _
	style2 = win.allowin(CT.BUTTON, 160, 240, 220, 20, "MB_RIGHT", BS_AUTOCHECKBOX), _
	style3 = win.allowin(CT.BUTTON, 160, 265, 220, 20, "MB_RTLREADING", BS_AUTOCHECKBOX), _
	style4 = win.allowin(CT.BUTTON, 160, 290, 220, 20, "MB_SETFOREGROUND", BS_AUTOCHECKBOX), _
	style5 = win.allowin(CT.BUTTON, 160, 315, 220, 20, "MB_TOPMOST", BS_AUTOCHECKBOX), _
	style6 = win.allowin(CT.BUTTON, 160, 340, 220, 20, "MB_SERVICE_NOTIFICATION", BS_AUTOCHECKBOX), _
	create = win.allowin(CT.BUTTON, 5, 245, 150, 110, "Create!"), _
	sel = win.allowin(CT.LABEL, 5, 360, 300, 20, "Last button pressed: No message box created yet!")

'assign bold font to create button
win.font(create) = @boldfont

'add options into comboboxes, and select appropriate items in each
win.list_additem(icons) = "No icon"
win.list_additem(icons) = "! - Exclamation"
win.list_additem(icons) = "i - Information"
win.list_additem(icons) = "X - Error"
win.list_additem(icons) = "? - Question"
win.list_sel(icons) = 0 'select first item

win.list_additem(buttons) = "Abort, Retry, Ignore"
win.list_additem(buttons) = "Cancel, Try Again, Continue"
win.list_additem(buttons) = "OK"
win.list_additem(buttons) = "OK, Cancel"
win.list_additem(buttons) = "Retry, Cancel"
win.list_additem(buttons) = "Yes, No"
win.list_additem(buttons) = "Yes, No, Cancel"
win.list_sel(buttons) = 2 'select third item

win.list_additem(default) = "1"
win.list_additem(default) = "2"
win.list_additem(default) = "3"
win.list_additem(default) = "4"
win.list_sel(default) = 0

win.list_additem(modal) = "APPLMODAL"
win.list_additem(modal) = "SYSTEMMODAL"
win.list_additem(modal) = "TASKMODAL"
win.list_sel(modal) = 0

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	waitevent_all(msg)
	
	'when the user clicks the button, the message box will be generated
	if msg.message = WM_LBUTTONUP and msg.hwnd = win.hwin(create) then
		'assign flags based on user input
		dim as ulong flags
		select case win.list_sel(icons)
			case 1
				flags or= MB_ICONEXCLAMATION
			case 2
				flags or= MB_ICONINFORMATION
			case 3
				flags or= MB_ICONERROR
			case 4
				flags or= MB_ICONQUESTION
		end select
		select case win.list_sel(buttons)
			case 0
				flags or= MB_ABORTRETRYIGNORE
			case 1
				flags or= MB_CANCELTRYCONTINUE
			case 2
				flags or= MB_OK
			case 3
				flags or= MB_OKCANCEL
			case 4
				flags or= MB_RETRYCANCEL
			case 5
				flags or= MB_YESNO
			case 6
				flags or= MB_YESNOCANCEL
		end select
		select case win.list_sel(default)
			case 0
				flags or= MB_DEFBUTTON1
			case 1
				flags or= MB_DEFBUTTON2
			case 2
				flags or= MB_DEFBUTTON3
			case 3
				flags or= MB_DEFBUTTON4
		end select
		select case win.list_sel(modal)
			case 0
				flags or= MB_APPLMODAL
			case 1
				flags or= MB_SYSTEMMODAL
			case 2
				flags or= MB_TASKMODAL
		end select
		if win.button_state(style1) = BS.CHECKED then flags or= MB_DEFAULT_DESKTOP_ONLY
		if win.button_state(style2) = BS.CHECKED then flags or= MB_RIGHT
		if win.button_state(style3) = BS.CHECKED then flags or= MB_RTLREADING
		if win.button_state(style4) = BS.CHECKED then flags or= MB_SETFOREGROUND
		if win.button_state(style5) = BS.CHECKED then flags or= MB_TOPMOST
		if win.button_state(style6) = BS.CHECKED then flags or= MB_SERVICE_NOTIFICATION
		
		'create the message box!
		dim as long ret = win.msgbox(win.caption(msgstr), win.caption(capstr), flags)
		
		'tell the user what button they pressed
		select case ret
			case IDABORT
				win.caption(sel) = "Last button pressed: Abort"
			case IDCANCEL
				win.caption(sel) = "Last button pressed: Cancel"
			case IDCONTINUE
				win.caption(sel) = "Last button pressed: Continue"
			case IDIGNORE
				win.caption(sel) = "Last button pressed: Ignore"
			case IDNO
				win.caption(sel) = "Last button pressed: No"
			case IDOK
				win.caption(sel) = "Last button pressed: OK"
			case IDRETRY
				win.caption(sel) = "Last button pressed: Retry"
			case IDTRYAGAIN
				win.caption(sel) = "Last button pressed: Try Again"
			case IDYES
				win.caption(sel) = "Last button pressed: Yes"
		end select
	endif
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button
