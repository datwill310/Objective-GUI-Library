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

#include once "windows.bi"

namespace OGL
	const NL = chr(13, 10) 'see doc file for remark concerning unicode compatibility
	
	enum BS
		CHECKED = BST_CHECKED
		UNCHECKED = BST_UNCHECKED
		INDETERMINATE = BST_INDETERMINATE
		NOT_A_BUTTON = 3
	end enum
	enum CT
		NO_CTRL = 0
		WIN = 1
		LABEL = 2
		_STATIC = 2
		BUTTON = 3
		TEXTBOX = 4
		EDIT = 4
		ML_TEXTBOX = 5
		ML_EDIT = 5
		COMBOBOX = 6
		LISTBOX = 7
		MS_LISTBOX = 8
	end enum
	
	'if both members of this object equate to 0,
	'it can mean either an error has occurred,
	'or that a selection hasn't been made, for example
	type TIINFO 'Two Index INFO, said TEE-IY-INFO
		as ulong istart = 0
		as ulong iend = 0
	end type
	
	function controltypeclass(byval ctrl as OGL.CT) as string
		select case ctrl
			case CT.NO_CTRL
				return ""
			case CT.WIN
				return "#32770"
			case CT.LABEL, CT._STATIC
				return "STATIC"
			case CT.BUTTON
				return "BUTTON"
			case CT.TEXTBOX, CT.EDIT, CT.ML_TEXTBOX, CT.ML_EDIT
				return "EDIT"
			case CT.COMBOBOX
				return "COMBOBOX"
			case CT.LISTBOX, CT.MS_LISTBOX
				return "LISTBOX"
		end select
	end function
	function waitevent_all(byref msg as MSG, byval win as HWND = NULL) as boolean
		dim as long ret = GetMessage(@msg, win, 0, 0)
		if ret then TranslateMessage(@msg): DispatchMessage(@msg)
		return cbool(ret)
	end function
	function uponclose_any(byref msg as MSG, byval win as HWND = NULL) as boolean
		if win <> NULL and msg.hwnd <> win then return false
		if msg.message = 161 and msg.wParam = 20 then return true else return false
	end function
	function msgbox_null(byval msg as LPTSTR, byval caption as LPTSTR = NULL, byval flags as ulong = MB_ICONEXCLAMATION or MB_APPLMODAL, byval owner as HWND = NULL) as long
		dim as LPTSTR temp = caption
		if temp = NULL then
			temp = callocate(15)
			*temp = "Message"
		endif
		dim as long ret = MessageBox(owner, msg, temp, flags)
		if caption = NULL then deallocate(temp)
		return ret
	end function
	function loadico(byval iconpath as LPTSTR, byval w as long = 32, byval h as long = 32, byval additionalflags as ulong = 0) as HICON
		return LoadImage(0, iconpath, IMAGE_ICON, w, h, LR_LOADFROMFILE or additionalflags)
	end function
	function loadbmp(byval bmppath as LPTSTR, byval w as long, byval h as long, byval additionalflags as ulong = 0) as HBITMAP
		return LoadImage(0, bmppath, IMAGE_BITMAP, w, h, LR_LOADFROMFILE or additionalflags)
	end function
	function maketii(byval istartval as ulong, byval iendval as ulong) as TIINFO
		dim as TIINFO ret
		ret.istart = istartval
		ret.iend = iendval
		return ret
	end function
	
	type GUIFONT
		declare constructor()
		declare constructor(byval fval as string, byval ahval as long = 16, byval awval as long = 6, byval wval as long = 0, byval ival as boolean = false, _
			byval uval as boolean = false, byval sval as boolean = false)
		declare destructor()
		declare property update() as HFONT
		declare property destroy() as boolean
		declare property handle() as HFONT
		
		as long h
		as long w
		as long weight
		as boolean italic
		as boolean underline
		as boolean strikeout
		as string typeface
		protected:
			as HFONT fonth
	end type
	
	type GUIWIN
		'the constructor only contains information which is required for the CreateWindowEx() function
		declare constructor(byval xval as long, _
			byval yval as long, _
			byval wval as long, _
			byval hval as long, _
			byval cval as LPTSTR = NULL, _
			byval sval as ulong = WS_OVERLAPPEDWINDOW, _
			byval eval as boolean = true, _
			byval vval as boolean = true, _
			byval exts as ulong = 0, _
			byval mval as HMENU = NULL, _
			byval pval as HWND = NULL) 'this last parameter is primarily for the creation of the main window's child windows
		declare destructor()
		
		declare function waitevent(byval ci as ulong, byref msg as MSG) as boolean
		declare property hwin(byval ci as ulong) as HWND
		declare property x(byval ci as ulong, byval newx as long)
		declare property x(byval ci as ulong) as long
		declare property x_global(byval ci as ulong) as long
		declare property y(byval ci as ulong, byval newy as long)
		declare property y(byval ci as ulong) as long
		declare property y_global(byval ci as ulong) as long
		declare property w(byval ci as ulong, byval neww as long)
		declare property w(byval ci as ulong) as long
		declare property h(byval ci as ulong, byval newh as long)
		declare property h(byval ci as ulong) as long
		declare property caption(byval ci as ulong, byval newcaption as LPTSTR)
		declare property caption(byval ci as ulong) as LPTSTR
		declare property cptlen(byval ci as ulong) as ulong 'saves having to do this: len(*guiwin_obj.caption(ci)), REMEMBER THAT NL=2CHARS!
		declare property styles(byval ci as ulong, byval newstyles as ulong)
		declare property styles(byval ci as ulong) as ulong
		declare property exstyles(byval ci as ulong, byval newexstyles as ulong)
		declare property exstyles(byval ci as ulong) as ulong
		declare property visibility(byval ci as ulong, byval newvflag as boolean)
		declare property visibility(byval ci as ulong) as boolean
		declare property enabled(byval ci as ulong, byval neweflag as boolean)
		declare property enabled(byval ci as ulong) as boolean
		declare property focus(byval ci as ulong, byval newfocus as boolean)
		declare property focus(byval ci as ulong) as boolean
		declare property z(byval ci as ulong, byval newhwin as HWND) 'specify the window which is to be one place ABOVE this window in the Z Order (or a flag)
		declare property z_prev(byval ci as ulong) as HWND
		declare property z_next(byval ci as ulong) as HWND
		declare property cbec(byval ci as ulong) as boolean 'combo box edit compatible
		
		'image management methods: used for the image property set in the next section
		'the functions in the OGL namespace can be used to load images independently
		'imgtype = TRUE = icon
		'imgtype = FALSE = bitmap
		declare function alloimg(byval imgtype as boolean, _
			byval imgpath as LPTSTR, _
			byval iw as long = 32, _
			byval ih as long = 32, _
			byval additionalflags as ulong = 0) as ulong 'returns image index
		declare function dealloimg(byval ii as ulong) as boolean
		declare property getimg(byval ii as ulong) as HANDLE
		declare property getimgtype(byval ii as ulong) as boolean
		
		'general methods: some controls do not work with these methods
		declare property image(byval ci as ulong, byval newimg as ulong)
		declare property image(byval ci as ulong) as HANDLE
		declare property font(byval ci as ulong, byval newfont as GUIFONT ptr)
		declare property font(byval ci as ulong) as GUIFONT ptr
		
		'window specific methods
		declare function uponclose(byref msg as MSG) as boolean
		declare function msgbox(byval msg as LPTSTR, byval caption as LPTSTR = NULL, byval flags as ulong = MB_ICONEXCLAMATION or MB_APPLMODAL) as long
		declare property window_state(byval newstate as ulong)
		declare property window_state() as ulong
		declare property window_menu(byval newmenu as HMENU)
		declare property window_menu() as HMENU
		
		'button specific methods
		declare property button_state(byval ci as ulong, byval newstate as OGL.BS)
		declare property button_state(byval ci as ulong) as OGL.BS
		
		'textbox specific methods - these can be used with both single- and multi-line edit controls
		declare property edit_sel(byval ci as ulong, byval newsel as OGL.TIINFO)
		declare property edit_sel(byval ci as ulong) as OGL.TIINFO
		declare property edit_seltext(byval ci as ulong, byval newsel as LPTSTR)
		declare property edit_seltext(byval ci as ulong) as LPTSTR
		declare property edit_chrlimit(byval ci as ulong, byval newlimit as ulong)
		declare property edit_chrlimit(byval ci as ulong) as ulong
		declare property edit_lmargin(byval ci as ulong, byval neww as ushort)
		declare property edit_lmargin(byval ci as ulong) as ushort
		declare property edit_rmargin(byval ci as ulong, byval neww as ushort)
		declare property edit_rmargin(byval ci as ulong) as ushort
		declare function edit_margins(byval ci as ulong, byval newl as ushort, byval newr as ushort) as boolean
		declare property edit_modified(byval ci as ulong, byval newstate as boolean)
		declare property edit_modified(byval ci as ulong) as boolean
		declare property edit_password(byval ci as ulong, byval newchar as ulong)
		declare property edit_password(byval ci as ulong) as ulong
		declare property edit_readonly(byval ci as ulong, byval newro as boolean)
		declare property edit_readonly(byval ci as ulong) as boolean
		declare property edit_undo(byval ci as ulong) as boolean
		declare property edit_canundo(byval ci as ulong) as boolean
		declare property edit_emptyundo(byval ci as ulong) as boolean
		declare property edit_selstate(byval ci as ulong, byval selstate as boolean)
		declare property edit_lines(byval ci as ulong) as ulong
		declare property edit_copy(byval ci as ulong) as boolean
		declare property edit_cut(byval ci as ulong) as boolean
		declare property edit_paste(byval ci as ulong) as boolean
		declare property edit_delsel(byval ci as ulong) as boolean
		declare property edit_get(byval ci as ulong) as HWND
		/'a note: these methods work on ANY control with an edit box as part of them,
		including the combobox (should only be used with the CBS_DROPDOWN style). there
		is also an edit control handle retrieval method to retrieve the handle to the
		edit control of a control so you can amend the edit control with pure winapi,
		though not an index as the OGL does not allocate a separate textbox internal
		object for the edit control of another control'/
		
		'multi-line textbox specific methods
		'note: wordbreakproc properties need to be tested by one who knows about these things
		declare property edit_wordbreakproc(byval ci as ulong, byval proc as EDITWORDBREAKPROC)
		declare property edit_wordbreakproc(byval ci as ulong) as EDITWORDBREAKPROC
		declare property edit_topmostline(byval ci as ulong) as ulong
		declare property edit_linelen(byval mi as OGL.TIINFO) as ulong
		declare property edit_line(byval mi as OGL.TIINFO) as LPTSTR
		declare function edit_linescroll(byval ci as ulong, byval chars as long, byval lines as long) as boolean
		declare property edit_linefromchar(byval mi as OGL.TIINFO) as ulong
		declare property edit_charofline(byval mi as OGL.TIINFO) as ulong
		declare property edit_charofcurline(byval ci as ulong) as ulong
		declare property edit_scrollcaret(byval ci as ulong) as boolean
		
		'combobox and listbox specific methods
		declare property list_additem(byval ci as ulong, byval icpt as LPTSTR)
		declare property list_insitem(byval mi as TIINFO, byval icpt as LPTSTR)
		declare property list_delitem(byval mi as TIINFO) as boolean
		declare property list_clear(byval ci as ulong) as boolean
		declare property list_item(byval mi as TIINFO, byval newcpt as LPTSTR)
		declare property list_item(byval mi as TIINFO) as LPTSTR
		declare property list_sel(byval ci as ulong, byval newsel as ulong)
		declare property list_sel(byval ci as ulong) as ulong 'single-select listbox only!
		declare property list_itemh(byval mi as TIINFO, byval newh as ulong)
		declare property list_itemh(byval mi as TIINFO) as ulong
		declare property list_topitem(byval ci as ulong, byval newitem as ulong)
		declare property list_topitem(byval ci as ulong) as ulong
		declare property list_itemlen(byval mi as TIINFO) as ulong
		declare property list_items(byval ci as ulong) as ulong
		declare property list_clssel(byval ci as ulong) as boolean 'single-select listbox only!
		
		'combobox specific methods
		declare property combo_dropdown(byval ci as ulong, byval newstate as boolean)
		declare property combo_dropdown(byval ci as ulong) as boolean
		declare property combo_dropdownw(byval ci as ulong, byval neww as ulong)
		declare property combo_dropdownw(byval ci as ulong) as ulong
		
		'multi-select listbox specified methods
		declare property mslist_caret(byval ci as ulong, byval newindex as ulong)
		declare property mslist_caret(byval ci as ulong) as ulong
		declare property mslist_selcount(byval ci as ulong) as ulong
		declare property mslist_allsel(byval ci as ulong, byval newstate as boolean) 'either selects all or deselects everything
		declare property mslist_sel(byval ci as ulong, newitems() as TIINFO)
		declare property mslist_selrange(byval ci as ulong, byval range as TIINFO)
		declare property mslist_deselrange(byval ci as ulong, byval range as TIINFO)
		declare property mslist_sel(byval ci as ulong) as ulong ptr
		
		'control management methods
		declare function allowin(byval ctrlt as OGL.CT, _
			byval xval as long, _
			byval yval as long, _
			byval wval as long, _
			byval hval as long, _
			byval cval as LPTSTR = NULL, _
			byval sval as ulong = 0, _
			byval eval as boolean = true, _
			byval vval as boolean = true, _
			byval exts as ulong = 0) as ulong 'returns index of new control
		declare function deallowin(byval ci as ulong) as boolean
		declare function allochild(byval xval as long, _
			byval yval as long, _
			byval wval as long, _
			byval hval as long, _
			byval cval as LPTSTR = NULL, _
			byval sval as ulong = WS_OVERLAPPEDWINDOW, _
			byval eval as boolean = true, _
			byval vval as boolean = true, _
			byval exts as ulong = 0, _
			byval mval as HMENU = NULL) as ulong 'returns index of new control
		declare sub deallochild(byval ci as ulong)
		declare property child(byval ci as ulong) as GUIWIN ptr 'used to amend the child window in exactly the same way as you would with the main
		
		as boolean debugmode = false 'useful to apply WS_BORDER styles to every control if TRUE
		as boolean defstyles = true  'if set to TRUE, assign default styling to particular controls.
									 'setting to FALSE is useful to prevent default styling from being set, i.e.
									 'you can take away the WS_BORDER style from created textboxes if set to FALSE
		as boolean mslistsel = false 'if set to TRUE and the list_sel property is used with a multi-sel listbox,
									 'the property deselects everything else before selecting the new item
									 'if set to FALSE, the item provided simply is selected, and no de-selection occurs
		protected:
			as HWND wins(any) 'the control handles
			as OGL.CT types(any) 'the control types
			as OGL.GUIFONT fonts(any) 'the fonts for each control;
			'font(0) holds the default font used to on all controls when they are created,
			'font(x) holds the font for control number x.
			'changing the default font will reassign all controls which use the default font the new default font,
			'thus bringing back dynamic font amendment
			as OGL.GUIWIN ptr childs(any) 'the child windows which are to be assigned to the main window
			as HANDLE imgs(any) 'the list of icons and bitmaps registered for use with this window and its controls
			as boolean imgtypes(any) 'TRUE = icon, FALSE = bitmap: used to record the types of images registered
			'NOTE: child windows do NOT inherit the main window's items!
	end type
end namespace

constructor OGL.GUIFONT()
	this.fonth = NULL
end constructor
constructor OGL.GUIFONT(byval fval as string, byval ahval as long = 16, byval awval as long = 6, byval wval as long = 0, byval ival as boolean = false, _
		byval uval as boolean = false, byval sval as boolean = false)
	this.h = ahval
	this.w = awval
	this.weight = wval
	this.italic = ival
	this.underline = uval
	this.strikeout = sval
	this.typeface = fval
	this.fonth = CreateFont(this.h, this.w, 0, 0, this.weight, this.italic, this.underline, this.strikeout, DEFAULT_CHARSET, false, false, DEFAULT_QUALITY, _
		DEFAULT_PITCH or FF_ROMAN, this.typeface)
end constructor
destructor OGL.GUIFONT()
	this.destroy
end destructor
property OGL.GUIFONT.update() as HFONT
	this.destroy
	this.fonth = CreateFont(this.h, this.w, 0, 0, this.weight, this.italic, this.underline, this.strikeout, DEFAULT_CHARSET, false, false, DEFAULT_QUALITY, _
		DEFAULT_PITCH or FF_ROMAN, this.typeface)
	return this.fonth
end property
property OGL.GUIFONT.destroy() as boolean
	dim as boolean ret = DeleteObject(this.fonth)
	this.fonth = NULL
	return ret
end property
property OGL.GUIFONT.handle() as HFONT
	return this.fonth
end property

constructor OGL.GUIWIN(byval xval as long, byval yval as long, byval wval as long, byval hval as long, _
		byval cval as LPTSTR = NULL, byval sval as ulong = WS_OVERLAPPEDWINDOW, byval eval as boolean = true, byval vval as boolean = true, byval exts as ulong = 0, _
			byval mval as HMENU = NULL, byval pval as HWND = NULL)
	redim this.wins(0)
	redim this.types(0)
	redim this.fonts(0)
	redim this.childs(0)
	redim this.imgs(0)
	redim this.imgtypes(0)
	this.wins(0) = CreateWindowEx(exts, "#32770", cval, WS_CLIPSIBLINGS or sval or iif(eval, 0, WS_DISABLED) or iif(vval, WS_VISIBLE, 0), xval, yval, wval, hval, pval, _
		mval, GetModuleHandle(0), NULL)
	this.types(0) = CT.WIN
	this.fonts(0).h = 16
	this.fonts(0).w = 6
	this.fonts(0).weight = 0
	this.fonts(0).italic = false
	this.fonts(0).underline = false
	this.fonts(0).strikeout = false
	this.fonts(0).typeface = "arial"
	this.fonts(0).update 'ensure that the default font is constructed
end constructor
destructor OGL.GUIWIN()
	for i as ulong = lbound(this.childs) to ubound(this.childs) 'destroy any child windows first
		this.deallochild(i)
	next
	if ubound(this.wins) > 0 then 'then destroy any child controls
		for i as ulong = lbound(this.wins)+1 to ubound(this.wins)
			this.deallowin(i)
		next
	endif
	for i as ulong = lbound(this.imgs) to ubound(this.imgs) 'finally, destroy all registered images
		this.dealloimg(i)
	next
	DestroyWindow(this.wins(0)) 'before destroying the main window
end destructor

function OGL.GUIWIN.waitevent(byval ci as ulong, byref msg as MSG) as boolean
	return waitevent_all(msg, this.wins(ci))
end function
property OGL.GUIWIN.hwin(byval ci as ulong) as HWND
	return this.wins(ci)
end property
property OGL.GUIWIN.x(byval ci as ulong, byval newx as long)
	SetWindowPos(this.wins(ci), NULL, newx, this.y(ci), NULL, NULL, SWP_NOSIZE or SWP_NOZORDER)
end property
property OGL.GUIWIN.x(byval ci as ulong) as long
	if ci > 0 then
		dim as RECT rect
		GetWindowRect(this.wins(ci), @rect)
		MapWindowPoints(NULL, this.wins(0), cast(POINT ptr, @rect), 2)
		return rect.left
	else
		if GetParent(this.wins(0)) <> NULL then 'if the main window of GUIWIN has been assigned a parent externally, then get its co-ord relative to its parent
			dim as RECT rect
			GetWindowRect(this.wins(0), @rect)
			MapWindowPoints(NULL, GetParent(this.wins(0)), cast(POINT ptr, @rect), 2)
			return rect.left
		else
			return this.x_global(0)
		endif
	endif
end property
property OGL.GUIWIN.x_global(byval ci as ulong) as long
	dim as RECT rect
	GetWindowRect(this.wins(ci), @rect)
	return rect.left
end property
property OGL.GUIWIN.y(byval ci as ulong, byval newy as long)
	SetWindowPos(this.wins(ci), NULL, this.x(ci), newy, NULL, NULL, SWP_NOSIZE or SWP_NOZORDER)
end property
property OGL.GUIWIN.y(byval ci as ulong) as long
	if ci > 0 then
		dim as RECT rect
		GetWindowRect(this.wins(ci), @rect)
		MapWindowPoints(NULL, this.wins(0), cast(POINT ptr, @rect), 2)
		return rect.top
	else
		if GetParent(this.wins(0)) <> NULL then 'if the main window of GUIWIN has been assigned a parent externally, then get its co-ord relative to its parent
			dim as RECT rect
			GetWindowRect(this.wins(0), @rect)
			MapWindowPoints(NULL, GetParent(this.wins(0)), cast(POINT ptr, @rect), 2)
			return rect.top
		else
			return this.y_global(0)
		endif
	endif
end property
property OGL.GUIWIN.y_global(byval ci as ulong) as long
	dim as RECT rect
	GetWindowRect(this.wins(ci), @rect)
	return rect.top
end property
property OGL.GUIWIN.w(byval ci as ulong, byval neww as long)
	SetWindowPos(this.wins(ci), NULL, NULL, NULL, neww, this.h(ci), SWP_NOMOVE or SWP_NOZORDER)
end property
property OGL.GUIWIN.w(byval ci as ulong) as long
	dim as RECT rect
	GetWindowRect(this.wins(ci), @rect)
	return rect.right-rect.left
end property
property OGL.GUIWIN.h(byval ci as ulong, byval newh as long)
	SetWindowPos(this.wins(ci), NULL, NULL, NULL, this.w(ci), newh, SWP_NOMOVE or SWP_NOZORDER)
end property
property OGL.GUIWIN.h(byval ci as ulong) as long
	dim as RECT rect
	GetWindowRect(this.wins(ci), @rect)
	return rect.bottom-rect.top
end property
property OGL.GUIWIN.caption(byval ci as ulong, byval newcaption as LPTSTR)
	SetWindowText(this.wins(ci), newcaption)
end property
property OGL.GUIWIN.caption(byval ci as ulong) as LPTSTR
	dim as ulong bufflen = this.cptlen(ci)*2+1
	dim as LPTSTR buff = callocate(bufflen)
	GetWindowText(this.wins(ci), buff, bufflen)
	return buff
end property
property OGL.GUIWIN.cptlen(byval ci as ulong) as ulong
	return GetWindowTextLength(this.wins(ci))
end property
property OGL.GUIWIN.styles(byval ci as ulong, byval newstyles as ulong)
	SetWindowLong(this.wins(ci), GWL_STYLE, newstyles)
end property
property OGL.GUIWIN.styles(byval ci as ulong) as ulong
	return GetWindowLong(this.wins(ci), GWL_STYLE)
end property
property OGL.GUIWIN.exstyles(byval ci as ulong, byval newexstyles as ulong)
	SetWindowLong(this.wins(ci), GWL_EXSTYLE, newexstyles)
end property
property OGL.GUIWIN.exstyles(byval ci as ulong) as ulong
	return GetWindowLong(this.wins(ci), GWL_EXSTYLE)
end property
property OGL.GUIWIN.visibility(byval ci as ulong, byval newvflag as boolean)
	ShowWindow(this.wins(ci), iif(newvflag, SW_SHOW, SW_HIDE))
end property
property OGL.GUIWIN.visibility(byval ci as ulong) as boolean
	return IsWindowVisible(this.wins(ci))
end property
property OGL.GUIWIN.enabled(byval ci as ulong, byval neweflag as boolean)
	EnableWindow(this.wins(ci), neweflag)
end property
property OGL.GUIWIN.enabled(byval ci as ulong) as boolean
	return IsWindowEnabled(this.wins(ci))
end property
property OGL.GUIWIN.focus(byval ci as ulong, byval newfocus as boolean)
	SendMessage(this.wins(ci), iif(newfocus, WM_SETFOCUS, WM_KILLFOCUS), 0, 0)
end property
property OGL.GUIWIN.focus(byval ci as ulong) as boolean
	if GetFocus = this.wins(ci) then return true else return false
end property
property OGL.GUIWIN.z(byval ci as ulong, byval newhwin as HWND)
	SetWindowPos(this.wins(ci), newhwin, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
end property
property OGL.GUIWIN.z_prev(byval ci as ulong) as HWND
	return GetNextWindow(this.wins(ci), GW_HWNDPREV)
end property
property OGL.GUIWIN.z_next(byval ci as ulong) as HWND
	return GetNextWindow(this.wins(ci), GW_HWNDNEXT)
end property
property OGL.GUIWIN.cbec(byval ci as ulong) as boolean 'combo box edit compatible
	if this.types(ci) = CT.COMBOBOX then
		if (this.styles(ci) and CBS_SIMPLE) or (this.styles(ci) and CBS_DROPDOWN) then
			return true
		else
			return false
		endif
	else
		return false
	endif
end property

'image management methods: used for the image property set in the next section
'the functions in the OGL namespace can be used to load images independently
'imgtype = TRUE = icon
'imgtype = FALSE = bitmap
function OGL.GUIWIN.alloimg(byval imgtype as boolean, byval imgpath as LPTSTR, _
		byval iw as long = 32, byval ih as long = 32, byval additionalflags as ulong = 0) as ulong 'returns image index
	'steps 1 and 3
	dim as ulong index = ubound(this.imgs)+1
	dim as boolean onefound = false
	for i as ulong = lbound(this.imgs) to ubound(this.imgs)
		if this.imgs(i) = NULL then onefound = true: index = i: exit for
	next
	'step 2
	if onefound = false then
		redim preserve this.imgs(ubound(this.imgs)+1)
		redim preserve this.imgtypes(ubound(this.imgtypes)+1)
	endif
	'step 4
	if imgtype then
		this.imgs(index) = loadico(imgpath, iw, ih, additionalflags)
	else
		this.imgs(index) = loadbmp(imgpath, iw, ih, additionalflags)
	endif
	this.imgtypes(index) = imgtype
	'step 5
	if this.imgs(index) = NULL then return 0 else return index
end function
function OGL.GUIWIN.dealloimg(byval ii as ulong) as boolean
	dim as boolean ret = false
	if this.imgs(ii) <> NULL then
		if this.imgtypes(ii) then ret = DestroyIcon(this.imgs(ii)) else ret = DeleteObject(this.imgs(ii))
		this.imgs(ii) = NULL 'make sure to free this element of the array for later use!
	endif
	return ret
end function
property OGL.GUIWIN.getimg(byval ii as ulong) as HANDLE
	return this.imgs(ii)
end property
property OGL.GUIWIN.getimgtype(byval ii as ulong) as boolean
	return this.imgtypes(ii)
end property

'general methods: some controls do not work with these methods
property OGL.GUIWIN.image(byval ci as ulong, byval newimg as ulong)
	select case this.types(ci) 'each control has its own way of dealing with icons and bitmaps
		case CT.WIN 'if the control is a window, set the small icon
			SendMessage(this.wins(ci), WM_SETICON, ICON_SMALL, cast(LPARAM, this.imgs(newimg)))
		case CT.LABEL
			if this.styles(ci) and SS_ICON then SendMessage(this.wins(ci), STM_SETIMAGE, IMAGE_ICON, cast(LPARAM, this.imgs(newimg)))
			if this.styles(ci) and SS_BITMAP then SendMessage(this.wins(ci), STM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM, this.imgs(newimg)))
		case CT.BUTTON
			if this.styles(ci) and BS_ICON then SendMessage(this.wins(ci), BM_SETIMAGE, IMAGE_ICON, cast(LPARAM, this.imgs(newimg)))
			if this.styles(ci) and BS_BITMAP then SendMessage(this.wins(ci), BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM, this.imgs(newimg)))
	end select
end property
property OGL.GUIWIN.image(byval ci as ulong) as HANDLE
	select case this.types(ci) 'each control has its own way of dealing with icons and bitmaps
		case CT.WIN 'if the control is a window, get the small icon
			return cast(HANDLE, SendMessage(this.wins(ci), WM_GETICON, ICON_SMALL, 0))
		case CT.LABEL
			dim ret as HANDLE = cast(HANDLE, SendMessage(this.wins(ci), STM_GETIMAGE, IMAGE_ICON, 0))
			if ret = NULL then ret = cast(HANDLE, SendMessage(this.wins(ci), STM_GETIMAGE, IMAGE_BITMAP, 0))
			return ret
		case CT.BUTTON
			dim ret as HANDLE = cast(HANDLE, SendMessage(this.wins(ci), BM_GETIMAGE, IMAGE_ICON, 0))
			if ret = NULL then ret = cast(HANDLE, SendMessage(this.wins(ci), BM_GETIMAGE, IMAGE_BITMAP, 0))
			return ret
		case else 'a control which does not support images
			return NULL
	end select
end property
property OGL.GUIWIN.font(byval ci as ulong, byval newfont as GUIFONT ptr)
	if ci = 0 and newfont = NULL then
		'make sure that the default font isn't replaced with an attempt to make it use the default font as if it were a control!
	else
		if newfont <> NULL then
			this.fonts(ci).h = newfont->h
			this.fonts(ci).w = newfont->w
			this.fonts(ci).weight = newfont->weight
			this.fonts(ci).italic = newfont->italic
			this.fonts(ci).underline = newfont->underline
			this.fonts(ci).strikeout = newfont->strikeout
			this.fonts(ci).typeface = newfont->typeface
			this.fonts(ci).update
		else
			this.fonts(ci).destroy 'cause the font within the chosen control to be destroyed and replaced with the default font
			this.fonts(ci).h = this.fonts(0).h
			this.fonts(ci).w = this.fonts(0).w
			this.fonts(ci).weight = this.fonts(0).weight
			this.fonts(ci).italic = this.fonts(0).italic
			this.fonts(ci).underline = this.fonts(0).underline
			this.fonts(ci).strikeout = this.fonts(0).strikeout
			this.fonts(ci).typeface = this.fonts(0).typeface
			this.fonts(ci).update
		endif
		if ci = 0 then 'if amending the default font, reset the font of all controls which use NULL
			for i as ulong = lbound(this.wins)+1 to ubound(this.wins)
				if this.fonts(i).handle = NULL then SendMessage(this.wins(ci), WM_SETFONT, cast(WPARAM, this.fonts(0).handle), true)
			next
		else
			SendMessage(this.wins(ci), WM_SETFONT, cast(WPARAM, this.fonts(ci).handle), true)
		endif
	endif
end property
property OGL.GUIWIN.font(byval ci as ulong) as GUIFONT ptr
	return @this.fonts(ci)
end property

'window specific methods
function OGL.GUIWIN.uponclose(byref msg as MSG) as boolean
	return uponclose_any(msg, this.wins(0))
end function
function OGL.GUIWIN.msgbox(byval msg as LPTSTR, byval cpt as LPTSTR = NULL, byval flags as ulong = MB_ICONEXCLAMATION or MB_APPLMODAL) as long
	return msgbox_null(msg, cpt, flags, this.wins(0))
end function
property OGL.GUIWIN.window_state(byval newstate as ulong)
	ShowWindow(this.wins(0), newstate)
end property
property OGL.GUIWIN.window_state() as ulong
	dim as WINDOWPLACEMENT wp
	wp.length = sizeof(WINDOWPLACEMENT)
	GetWindowPlacement(this.wins(0), @wp)
	return wp.showCmd
end property
property OGL.GUIWIN.window_menu(byval newmenu as HMENU)
	SetMenu(this.wins(0), newmenu)
end property
property OGL.GUIWIN.window_menu() as HMENU
	return GetMenu(this.wins(0))
end property

'button specific methods
property OGL.GUIWIN.button_state(byval ci as ulong, byval newstate as OGL.BS)
	if this.types(ci) = CT.BUTTON then SendMessage(this.wins(ci), BM_SETCHECK, newstate, 0)
end property
property OGL.GUIWIN.button_state(byval ci as ulong) as OGL.BS
	if this.types(ci) = CT.BUTTON then return SendMessage(this.wins(ci), BM_GETCHECK, 0, 0) else return BS.NOT_A_BUTTON
end property

'textbox specific methods - these can be used with both single- and multi-line edit controls
property OGL.GUIWIN.edit_sel(byval ci as ulong, byval newsel as OGL.TIINFO)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SETSEL, newsel.istart, newsel.iend)
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_SETSEL, newsel.istart, newsel.iend)
	endif
end property
property OGL.GUIWIN.edit_sel(byval ci as ulong) as OGL.TIINFO
	dim as TIINFO ret
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_GETSEL, cast(WPARAM, @ret.istart), cast(LPARAM, @ret.iend))
		return ret
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_GETSEL, cast(WPARAM, @ret.istart), cast(LPARAM, @ret.iend))
		return ret
	else
		return ret
	endif
end property
property OGL.GUIWIN.edit_seltext(byval ci as ulong, byval newsel as LPTSTR)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_REPLACESEL, true, cast(LPARAM, newsel))
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_REPLACESEL, true, cast(LPARAM, newsel))
	endif
end property
property OGL.GUIWIN.edit_seltext(byval ci as ulong) as LPTSTR
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		dim as LPTSTR ret = callocate(((this.edit_sel(ci).iend)-(this.edit_sel(ci).istart+1)+1)*2+1)
		for loopVar as long = this.edit_sel(ci).istart+1 to this.edit_sel(ci).iend
			*ret &= mid(*this.caption(ci), loopVar, 1)
		next
		return ret
	elseif this.cbec(ci) then
		dim as LPTSTR ret = callocate(((this.edit_sel(ci).iend)-(this.edit_sel(ci).istart+1)+1)*2+1)
		for loopVar as long = this.edit_sel(ci).istart+1 to this.edit_sel(ci).iend
			*ret &= mid(*this.caption(ci), loopVar, 1)
		next
		return ret
	else
		return NULL
	endif
end property
property OGL.GUIWIN.edit_chrlimit(byval ci as ulong, byval newlimit as ulong)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_LIMITTEXT, newlimit, 0)
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_LIMITTEXT, newlimit, 0)
	endif
end property
property OGL.GUIWIN.edit_chrlimit(byval ci as ulong) as ulong
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return SendMessage(this.wins(ci), EM_GETLIMITTEXT, 0, 0)
	elseif this.cbec(ci) then
		return SendMessage(this.edit_get(ci), EM_GETLIMITTEXT, 0, 0)
	else
		return 0
	endif
end property
property OGL.GUIWIN.edit_lmargin(byval ci as ulong, byval neww as ushort)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SETMARGINS, EC_LEFTMARGIN, MAKELONG(neww, 0))
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_SETMARGINS, EC_LEFTMARGIN, MAKELONG(neww, 0))
	endif
end property
property OGL.GUIWIN.edit_lmargin(byval ci as ulong) as ushort
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return loword(SendMessage(this.wins(ci), EM_GETMARGINS, 0, 0))
	elseif this.cbec(ci) then
		return loword(SendMessage(this.edit_get(ci), EM_GETMARGINS, 0, 0))
	else
		return 0
	endif
end property
property OGL.GUIWIN.edit_rmargin(byval ci as ulong, byval neww as ushort)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SETMARGINS, EC_RIGHTMARGIN, MAKELONG(0, neww))
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_SETMARGINS, EC_RIGHTMARGIN, MAKELONG(0, neww))
	endif
end property
property OGL.GUIWIN.edit_rmargin(byval ci as ulong) as ushort
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return hiword(SendMessage(this.wins(ci), EM_GETMARGINS, 0, 0))
	elseif this.cbec(ci) then
		return hiword(SendMessage(this.edit_get(ci), EM_GETMARGINS, 0, 0))
	else
		return 0
	endif
end property
function OGL.GUIWIN.edit_margins(byval ci as ulong, byval newl as ushort, byval newr as ushort) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN, MAKELONG(newl, newr))
		return true
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN, MAKELONG(newl, newr))
		return true
	else
		return false
	endif
end function
property OGL.GUIWIN.edit_modified(byval ci as ulong, byval newstate as boolean)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SETMODIFY, newstate, 0)
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_SETMODIFY, newstate, 0)
	endif
end property
property OGL.GUIWIN.edit_modified(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return SendMessage(this.wins(ci), EM_GETMODIFY, 0, 0)
	elseif this.cbec(ci) then
		return SendMessage(this.edit_get(ci), EM_GETMODIFY, 0, 0)
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_password(byval ci as ulong, byval newchar as ulong)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SETPASSWORDCHAR, newchar, 0)
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_SETPASSWORDCHAR, newchar, 0)
	endif
end property
property OGL.GUIWIN.edit_password(byval ci as ulong) as ulong
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return SendMessage(this.wins(ci), EM_GETPASSWORDCHAR, 0, 0)
	elseif this.cbec(ci) then
		return SendMessage(this.edit_get(ci), EM_GETPASSWORDCHAR, 0, 0)
	else
		return NULL
	endif
end property
property OGL.GUIWIN.edit_readonly(byval ci as ulong, byval newro as boolean)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SETREADONLY, newro, 0)
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_SETREADONLY, newro, 0)
	endif
end property
property OGL.GUIWIN.edit_readonly(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		if this.styles(ci) and ES_READONLY then return true else return false
	elseif this.cbec(ci) then
		if GetWindowLong(this.edit_get(ci), GWL_STYLE) and ES_READONLY then return true else return false
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_undo(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return SendMessage(this.wins(ci), EM_UNDO, 0, 0)
	elseif this.cbec(ci) then
		return SendMessage(this.edit_get(ci), EM_UNDO, 0, 0)
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_canundo(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return SendMessage(this.wins(ci), EM_CANUNDO, 0, 0)
	elseif this.cbec(ci) then
		return SendMessage(this.edit_get(ci), EM_CANUNDO, 0, 0)
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_emptyundo(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_EMPTYUNDOBUFFER, 0, 0)
		return true
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), EM_EMPTYUNDOBUFFER, 0, 0)
		return true
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_selstate(byval ci as ulong, byval selstate as boolean)
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		if selstate then 'if TRUE, select all text
			SendMessage(this.wins(ci), EM_SETSEL, 0, -1)
		else 'if FALSE, deselect
			SendMessage(this.wins(ci), EM_SETSEL, -1, 0)
		endif
	elseif this.cbec(ci) then
		if selstate then 'if TRUE, select all text
			SendMessage(this.edit_get(ci), EM_SETSEL, 0, -1)
		else 'if FALSE, deselect
			SendMessage(this.edit_get(ci), EM_SETSEL, -1, 0)
		endif
	endif
end property
property OGL.GUIWIN.edit_lines(byval ci as ulong) as ulong
	if this.cbec(ci) then return 1
	select case this.types(ci)
		case CT.EDIT
			return 1
		case CT.ML_EDIT
			return SendMessage(this.wins(ci), EM_GETLINECOUNT, 0, 0)
		case else
			return 0
	end select
end property
property OGL.GUIWIN.edit_copy(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), WM_COPY, 0, 0)
		return true
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), WM_COPY, 0, 0)
		return true
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_cut(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), WM_CUT, 0, 0)
		return true
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), WM_CUT, 0, 0)
		return true
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_paste(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), WM_PASTE, 0, 0)
		return true
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), WM_PASTE, 0, 0)
		return true
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_delsel(byval ci as ulong) as boolean
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), WM_CLEAR, 0, 0)
		return true
	elseif this.cbec(ci) then
		SendMessage(this.edit_get(ci), WM_CLEAR, 0, 0)
		return true
	else
		return false
	endif
end property
property OGL.GUIWIN.edit_get(byval ci as ulong) as HWND
	if this.types(ci) = CT.EDIT or this.types(ci) = CT.ML_EDIT then
		return this.wins(ci) 'if the control given WAS an edit control, simply return its handle
	elseif this.types(ci) = CT.COMBOBOX then
		dim as COMBOBOXINFO cbi
		cbi.cbSize = sizeof(COMBOBOXINFO)
		SendMessage(this.wins(ci), CB_GETCOMBOBOXINFO, 0, cast(LPARAM, @cbi))
		return cbi.hwndItem 'if the control given was a combobox and it has the right style, retrieve the edit control's handle
	else
		return NULL
	endif
end property

'multi-line textbox specific methods
property OGL.GUIWIN.edit_wordbreakproc(byval ci as ulong, byval proc as EDITWORDBREAKPROC)
	if this.types(ci) = CT.ML_EDIT then SendMessage(this.wins(ci), EM_SETWORDBREAKPROC, 0, cast(LPARAM, proc))
end property
property OGL.GUIWIN.edit_wordbreakproc(byval ci as ulong) as EDITWORDBREAKPROC
	if this.types(ci) = CT.ML_EDIT then return cast(EDITWORDBREAKPROC, SendMessage(this.wins(ci), EM_GETWORDBREAKPROC, 0, 0)) else return NULL
end property
property OGL.GUIWIN.edit_topmostline(byval ci as ulong) as ulong
	if this.types(ci) = CT.ML_EDIT then return SendMessage(this.wins(ci), EM_GETFIRSTVISIBLELINE, 0, 0) else return 0
end property
property OGL.GUIWIN.edit_linelen(byval mi as OGL.TIINFO) as ulong
	if this.types(mi.istart) = CT.ML_EDIT then
		return SendMessage(this.wins(mi.istart), EM_LINELENGTH, mi.iend, 0)
	else
		return 0
	endif
end property
property OGL.GUIWIN.edit_line(byval mi as OGL.TIINFO) as LPTSTR
	'this property GETS a line from a multi-line textbox
	if this.types(mi.istart) = CT.ML_EDIT then
		dim as ushort ll = this.edit_linelen(mi)
		if ll > 0 then
			dim as LPTSTR ret = callocate(ll*2+1)
			*ret &= ll
			dim as ulong check = SendMessage(this.wins(mi.istart), EM_GETLINE, mi.iend, cast(LPARAM, ret))
			if check = 0 then return NULL else return ret
		else 'if the line doesn't exist or have any character
			return NULL
		endif
	else
		return NULL
	endif
end property
function OGL.GUIWIN.edit_linescroll(byval ci as ulong, byval chars as long, byval lines as long) as boolean
	if this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_LINESCROLL, chars, lines)
		return true
	else
		return false
	endif
end function
property OGL.GUIWIN.edit_linefromchar(byval mi as OGL.TIINFO) as ulong
	if this.types(mi.istart) = CT.ML_EDIT then return SendMessage(this.wins(mi.istart), EM_LINEFROMCHAR, mi.iend, 0) else return NULL
end property
property OGL.GUIWIN.edit_charofline(byval mi as OGL.TIINFO) as ulong
	if this.types(mi.istart) = CT.ML_EDIT then return SendMessage(this.wins(mi.istart), EM_LINEINDEX, mi.iend, 0) else return NULL
end property
property OGL.GUIWIN.edit_charofcurline(byval ci as ulong) as ulong
	if this.types(ci) = CT.ML_EDIT then return SendMessage(this.wins(ci), EM_LINEINDEX, -1, 0) else return NULL
end property
property OGL.GUIWIN.edit_scrollcaret(byval ci as ulong) as boolean
	if this.types(ci) = CT.ML_EDIT then
		SendMessage(this.wins(ci), EM_SCROLLCARET, 0, 0)
		return true
	else
		return false
	endif
end property

'combobox and listbox specific methods
property OGL.GUIWIN.list_additem(byval ci as ulong, byval icpt as LPTSTR)
	if this.types(ci) = CT.COMBOBOX then
		SendMessage(this.wins(ci), CB_ADDSTRING, 0, cast(LPARAM, icpt))
	elseif this.types(ci) = CT.LISTBOX or this.types(ci) = CT.MS_LISTBOX then
		SendMessage(this.wins(ci), LB_ADDSTRING, 0, cast(LPARAM, icpt))
	endif
end property
property OGL.GUIWIN.list_insitem(byval mi as TIINFO, byval icpt as LPTSTR)
	if this.types(mi.istart) = CT.COMBOBOX then
		SendMessage(this.wins(mi.istart), CB_INSERTSTRING, mi.iend, cast(LPARAM, icpt))
	elseif this.types(mi.istart) = CT.LISTBOX or this.types(mi.istart) = CT.MS_LISTBOX then
		SendMessage(this.wins(mi.istart), LB_INSERTSTRING, mi.iend, cast(LPARAM, icpt))
	endif
end property
property OGL.GUIWIN.list_delitem(byval mi as TIINFO) as boolean
	if this.types(mi.istart) = CT.COMBOBOX then
		dim as LRESULT ret = SendMessage(this.wins(mi.istart), CB_DELETESTRING, mi.iend, 0)
		if ret = CB_ERR then return false else return true
	elseif this.types(mi.istart) = CT.LISTBOX or this.types(mi.istart) = CT.MS_LISTBOX then
		dim as LRESULT ret = SendMessage(this.wins(mi.istart), LB_DELETESTRING, mi.iend, 0)
		if ret = LB_ERR then return false else return true
	else
		return false
	endif
end property
property OGL.GUIWIN.list_clear(byval ci as ulong) as boolean
	if this.types(ci) = CT.COMBOBOX then
		SendMessage(this.wins(ci), CB_RESETCONTENT, 0, 0)
		return true
	elseif this.types(ci) = CT.LISTBOX or this.types(ci) = CT.MS_LISTBOX then
		SendMessage(this.wins(ci), LB_RESETCONTENT, 0, 0)
		return true
	else
		return false
	endif
end property
property OGL.GUIWIN.list_item(byval mi as TIINFO, byval newcpt as LPTSTR)
	if this.types(mi.istart) = CT.COMBOBOX then
		SendMessage(this.wins(mi.istart), CB_DELETESTRING, mi.iend, 0)
		SendMessage(this.wins(mi.istart), CB_INSERTSTRING, mi.iend, cast(LPARAM, newcpt))
	elseif this.types(mi.istart) = CT.LISTBOX or this.types(mi.istart) = CT.MS_LISTBOX then
		SendMessage(this.wins(mi.istart), LB_DELETESTRING, mi.iend, 0)
		SendMessage(this.wins(mi.istart), LB_INSERTSTRING, mi.iend, cast(LPARAM, newcpt))
	endif
end property
property OGL.GUIWIN.list_item(byval mi as TIINFO) as LPTSTR
	if this.types(mi.istart) = CT.COMBOBOX then
		dim as LPTSTR ret = callocate((this.list_itemlen(mi)+1)*2)
		SendMessage(this.wins(mi.istart), CB_GETLBTEXT, mi.iend, cast(LPARAM, ret))
		return ret
	elseif this.types(mi.istart) = CT.LISTBOX or this.types(mi.istart) = CT.MS_LISTBOX then
		dim as LPTSTR ret = callocate((this.list_itemlen(mi)+1)*2)
		SendMessage(this.wins(mi.istart), LB_GETTEXT, mi.iend, cast(LPARAM, ret))
		return ret
	else
		return NULL
	endif
end property
property OGL.GUIWIN.list_sel(byval ci as ulong, byval newsel as ulong)
	if this.types(ci) = CT.COMBOBOX then
		SendMessage(this.wins(ci), CB_SETCURSEL, newsel, 0)
	elseif this.types(ci) = CT.LISTBOX then
		SendMessage(this.wins(ci), LB_SETCURSEL, newsel, 0)
	elseif this.types(ci) = CT.MS_LISTBOX then 'can be used to select a single item in a multi-select listbox
		if this.mslistsel then this.mslist_allsel(ci) = false
		SendMessage(this.wins(ci), LB_SETSEL, true, newsel)
	endif
end property
property OGL.GUIWIN.list_sel(byval ci as ulong) as ulong 'single-select listbox only!
	if this.types(ci) = CT.COMBOBOX then
		return SendMessage(this.wins(ci), CB_GETCURSEL, 0, 0)
	elseif this.types(ci) = CT.LISTBOX then
		return SendMessage(this.wins(ci), LB_GETCURSEL, 0, 0)
	else
		return 0
	endif
end property
property OGL.GUIWIN.list_itemh(byval mi as TIINFO, byval newh as ulong)
	dim as long param = iif(mi.iend = 0, 0, -1)
	if this.types(mi.istart) = CT.COMBOBOX then
		SendMessage(this.wins(mi.istart), CB_SETITEMHEIGHT, param, newh)
	elseif this.types(mi.istart) = CT.LISTBOX or this.types(mi.istart) = CT.MS_LISTBOX then
		param = 0
		SendMessage(this.wins(mi.istart), LB_SETITEMHEIGHT, param, newh)
	endif
end property
property OGL.GUIWIN.list_itemh(byval mi as TIINFO) as ulong
	dim as long param = iif(mi.iend = 0, 0, -1)
	if this.types(mi.istart) = CT.COMBOBOX then
		return SendMessage(this.wins(mi.istart), CB_GETITEMHEIGHT, param, 0)
	elseif this.types(mi.istart) = CT.LISTBOX or this.types(mi.istart) = CT.MS_LISTBOX then
		param = 0
		return SendMessage(this.wins(mi.istart), LB_GETITEMHEIGHT, param, 0)
	else
		return NULL
	endif
end property
property OGL.GUIWIN.list_topitem(byval ci as ulong, byval newitem as ulong)
	if this.types(ci) = CT.COMBOBOX then
		SendMessage(this.wins(ci), CB_SETTOPINDEX, newitem, 0)
	elseif this.types(ci) = CT.LISTBOX or this.types(ci) = CT.MS_LISTBOX then
		SendMessage(this.wins(ci), LB_SETTOPINDEX, newitem, 0)
	endif
end property
property OGL.GUIWIN.list_topitem(byval ci as ulong) as ulong
	if this.types(ci) = CT.COMBOBOX then
		return SendMessage(this.wins(ci), CB_GETTOPINDEX, 0, 0)
	elseif this.types(ci) = CT.LISTBOX or this.types(ci) = CT.MS_LISTBOX then
		return SendMessage(this.wins(ci), LB_GETTOPINDEX, 0, 0)
	else
		return NULL
	endif
end property
property OGL.GUIWIN.list_itemlen(byval mi as TIINFO) as ulong
	if this.types(mi.istart) = CT.COMBOBOX then
		return SendMessage(this.wins(mi.istart), CB_GETLBTEXTLEN, mi.iend, 0)
	elseif this.types(mi.istart) = CT.LISTBOX or this.types(mi.istart) = CT.MS_LISTBOX then
		return SendMessage(this.wins(mi.istart), LB_GETTEXTLEN, mi.iend, 0)
	else
		return 0
	endif
end property
property OGL.GUIWIN.list_items(byval ci as ulong) as ulong
	if this.types(ci) = CT.COMBOBOX then
		return SendMessage(this.wins(ci), CB_GETCOUNT, 0, 0)
	elseif this.types(ci) = CT.LISTBOX or this.types(ci) = CT.MS_LISTBOX then
		return SendMessage(this.wins(ci), LB_GETCOUNT, 0, 0)
	else
		return 0
	endif
end property
property OGL.GUIWIN.list_clssel(byval ci as ulong) as boolean 'single-select listbox only!
	if this.types(ci) = CT.COMBOBOX then
		SendMessage(this.wins(ci), CB_SETCURSEL, -1, 0)
		return true
	elseif this.types(ci) = CT.LISTBOX then
		SendMessage(this.wins(ci), LB_SETCURSEL, -1, 0)
		return true
	else
		return false
	endif
end property

'combobox specific methods
property OGL.GUIWIN.combo_dropdown(byval ci as ulong, byval newstate as boolean)
	if this.types(ci) = CT.COMBOBOX then SendMessage(this.wins(ci), CB_SHOWDROPDOWN, newstate, 0)
end property
property OGL.GUIWIN.combo_dropdown(byval ci as ulong) as boolean
	if this.types(ci) = CT.COMBOBOX then return SendMessage(this.wins(ci), CB_GETDROPPEDSTATE, 0, 0) else return false
end property
property OGL.GUIWIN.combo_dropdownw(byval ci as ulong, byval neww as ulong)
	if this.types(ci) = CT.COMBOBOX then SendMessage(this.wins(ci), CB_SETDROPPEDWIDTH, neww, 0)
end property
property OGL.GUIWIN.combo_dropdownw(byval ci as ulong) as ulong
	if this.types(ci) = CT.COMBOBOX then return SendMessage(this.wins(ci), CB_GETDROPPEDWIDTH, 0, 0) else return 0
end property

'multi-select listbox specified methods
property OGL.GUIWIN.mslist_caret(byval ci as ulong, byval newindex as ulong)
	if this.types(ci) = CT.MS_LISTBOX then SendMessage(this.wins(ci), LB_SETCARETINDEX, newindex, false)
end property
property OGL.GUIWIN.mslist_caret(byval ci as ulong) as ulong
	if this.types(ci) = CT.MS_LISTBOX then return SendMessage(this.wins(ci), LB_GETCARETINDEX, 0, 0) else return NULL
end property
property OGL.GUIWIN.mslist_selcount(byval ci as ulong) as ulong
	if this.types(ci) = CT.MS_LISTBOX then return SendMessage(this.wins(ci), LB_GETSELCOUNT, 0, 0) else return 0
end property
property OGL.GUIWIN.mslist_allsel(byval ci as ulong, byval newstate as boolean) 'either selects all or deselects everything
	if this.types(ci) = CT.MS_LISTBOX then SendMessage(this.wins(ci), LB_SETSEL, newstate, -1)
end property
property OGL.GUIWIN.mslist_sel(byval ci as ulong, newitems() as TIINFO)
	if this.types(ci) = CT.MS_LISTBOX then
		for i as long = lbound(newitems) to ubound(newitems)
			SendMessage(this.wins(ci), LB_SETSEL, cbool(newitems(i).iend), newitems(i).istart)
		next
	endif
end property
property OGL.GUIWIN.mslist_selrange(byval ci as ulong, byval range as TIINFO)
	if this.types(ci) = CT.MS_LISTBOX then
		SendMessage(this.wins(ci), LB_SELITEMRANGE, true, MAKELPARAM(cast(ushort, range.istart), cast(ushort, range.iend)))
	endif
end property
property OGL.GUIWIN.mslist_deselrange(byval ci as ulong, byval range as TIINFO)
	if this.types(ci) = CT.MS_LISTBOX then
		SendMessage(this.wins(ci), LB_SELITEMRANGE, false, MAKELPARAM(cast(ushort, range.istart), cast(ushort, range.iend)))
	endif
end property
property OGL.GUIWIN.mslist_sel(byval ci as ulong) as ulong ptr
	if this.types(ci) = CT.MS_LISTBOX and this.mslist_selcount(ci) > 0 then
		dim as ulong ptr pindex = callocate(this.mslist_selcount(ci), sizeof(ulong))
		if pindex = NULL then return NULL
		SendMessage(this.wins(ci), LB_GETSELITEMS, this.mslist_selcount(ci), cast(LPARAM, pindex))
		return pindex
	else
		return NULL
	endif
end property

'window/control management methods
/'steps:
1. Get the lowest free index: like with the freefile function
2. If there is none, then the internal arrays are re-dimensioned another one time
3. If there is one, then use that index instead of re-dimensioning the internal arrays
4. Allocate control and assign the information to the internal arrays
5. A return value of 0 indicates an error
The old system involved re-dimensioning the internal arrays every time the programmer
deallocated a window, which caused some indexes (captured by the programmer in their
program) to become invalid. The programmer had to amend the index variables (minus the
indexes of the windows created AFTER the deleted window) to cause the indexes to
properly refer to their original window. If the programmer did not do so, they should
expect weird behaviour (indexes would refer to the window created AFTER the window
itself).
This system resolves this issue and cuts down on the amount of code the programmer has
to write. It works a lot like FB's freefile mechanism or the HANDLE system, but more
like the latter as the library does it all for you.'/
function OGL.GUIWIN.allowin(byval ctrlt as OGL.CT, byval xval as long, byval yval as long, byval wval as long, byval hval as long, _
		byval cval as LPTSTR = NULL, byval sval as ulong = 0, byval eval as boolean = true, byval vval as boolean = true, byval exts as ulong = 0) as ulong
	if ctrlt > CT.WIN then
		'steps 1 and 3
		dim as ulong index = ubound(this.wins)+1
		dim as boolean onefound = false
		for i as ulong = lbound(this.wins) to ubound(this.wins)
			if this.wins(i) = NULL then onefound = true: index = i: exit for
		next
		'step 2
		if onefound = false then
			redim preserve this.wins(ubound(this.wins)+1)
			redim preserve this.types(ubound(this.types)+1)
			redim preserve this.fonts(ubound(this.fonts)+1)
		endif
		'step 4
		dim as ulong defsval = 0
		if this.defstyles then 'assign default styling to certain controls
			select case ctrlt
				case CT.EDIT
					defsval or= WS_BORDER
				case CT.ML_EDIT
					defsval or= ES_MULTILINE or ES_AUTOHSCROLL or ES_AUTOVSCROLL or ES_WANTRETURN or WS_HSCROLL or WS_VSCROLL or WS_BORDER
				case CT.COMBOBOX
					defsval or= CBS_DROPDOWN or WS_VSCROLL
				case CT.LISTBOX
					defsval or= WS_BORDER or WS_VSCROLL
				case CT.MS_LISTBOX
					defsval or= WS_BORDER or WS_VSCROLL or LBS_EXTENDEDSEL or LBS_MULTIPLESEL
			end select
		endif
		this.wins(index) = CreateWindowEx(exts, controltypeclass(ctrlt), cval, _
			WS_CHILD or defsval or sval or iif(this.debugmode, WS_BORDER, 0) or iif(eval, 0, WS_DISABLED) or iif(vval, WS_VISIBLE, 0), xval, yval, _
			wval, hval, this.wins(0), NULL, GetModuleHandle(0), NULL)
		this.types(index) = ctrlt
		SendMessage(this.wins(index), WM_SETFONT, cast(WPARAM, this.fonts(0).handle), true)
		'step 5
		if this.wins(index) = NULL then return 0 else return index
	else
		return 0 'you can't create child windows this way: they work a little differently
	endif
end function
function OGL.GUIWIN.deallowin(byval ci as ulong) as boolean
	dim as boolean ret = false
	'do not destroy the main window this way!
	if ci > 0 and this.wins(ci) <> NULL then ret = DestroyWindow(this.wins(ci)): this.wins(ci) = NULL: this.types(ci) = CT.NO_CTRL: this.fonts(ci).destructor() 'make sure to free this element of the array for later use!
	return ret
end function

function OGL.GUIWIN.allochild(byval xval as long, byval yval as long, byval wval as long, byval hval as long, _
		byval cval as LPTSTR = NULL, byval sval as ulong = WS_OVERLAPPEDWINDOW, byval eval as boolean = true, byval vval as boolean = true, byval exts as ulong = 0, _
			byval mval as HMENU = NULL) as ulong
	'steps 1 and 3
	dim as ulong index = ubound(this.childs)+1
	dim as boolean onefound = false
	for i as ulong = lbound(this.childs) to ubound(this.childs)
		if this.childs(i) = NULL then onefound = true: index = i: exit for
	next
	'step 2
	if onefound = false then redim preserve this.childs(ubound(this.childs)+1)
	'step 4
	this.childs(index) = new OGL.GUIWIN(xval, yval, wval, hval, cval, sval or WS_CHILD, eval, vval, exts, mval, this.wins(0))
	'step 5
	if this.childs(index) = NULL then return 0 else return index
end function
sub OGL.GUIWIN.deallochild(byval ci as ulong)
	if this.childs(ci) <> NULL then delete this.childs(ci): this.childs(ci) = NULL 'make sure to free this element of the array for later use!
end sub
property OGL.GUIWIN.child(byval ci as ulong) as GUIWIN ptr
	return this.childs(ci)
end property
