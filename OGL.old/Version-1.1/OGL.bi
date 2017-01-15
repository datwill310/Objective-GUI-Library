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

#include once "windows.bi"
#include once "win\commctrl.bi"
dim as INITCOMMONCONTROLSEX icce
icce.dwSize = sizeof(INITCOMMONCONTROLSEX)
icce.dwICC = ICC_USEREX_CLASSES 'this function, for now, only makes sure that the .exe.manifest file works, but for me, it works anyway (idk about you)
InitCommonControlsEx(@icce)

namespace OGL
	const TB_FULLMULTILINE = WS_VISIBLE or ES_MULTILINE or ES_AUTOHSCROLL or ES_AUTOVSCROLL or ES_WANTRETURN or WS_HSCROLL or WS_VSCROLL or WS_BORDER
	#ifdef UNICODE
		const NL = wchr(13)+wchr(10)
	#else
		const NL = chr(13)+chr(10)
	#endif
	enum CB3W
		CHECKED       = BST_CHECKED
		UNCHECKED     = BST_UNCHECKED
		INDETERMINATE = BST_INDETERMINATE
	end enum
	enum SO
		BLACK     = SS_BLACKFRAME
		BLACKFILL = SS_BLACKRECT
		GRAY      = SS_GRAYFRAME
		GRAYFILL  = SS_GRAYRECT
		WHITE     = SS_WHITEFRAME
		WHITEFILL = SS_WHITERECT
	end enum
	enum LS
		THIN  = 1
		THICK = 2
	end enum
	namespace DS
		const WIN   = WS_VISIBLE or WS_OVERLAPPEDWINDOW
		const LBL   = WS_VISIBLE
		const BTN   = WS_VISIBLE
		const CB    = WS_VISIBLE
		const CBTW  = WS_VISIBLE
		const RB    = WS_VISIBLE
		const GB    = WS_VISIBLE
		const STATO = WS_VISIBLE
		const COMBO = WS_VISIBLE or CBS_AUTOHSCROLL or CBS_DROPDOWN
		const TB    = WS_VISIBLE or ES_AUTOHSCROLL or WS_BORDER
		const LB    = WS_VISIBLE or LBS_NOINTEGRALHEIGHT or WS_BORDER
	end namespace
	
	function waitevent(byref msg as MSG) as boolean
		dim as long ret = GetMessage(@msg, 0, 0, 0)
		if ret then TranslateMessage(@msg): DispatchMessage(@msg)
		return cbool(ret)
	end function
	function loadico(byval iconpath as LPTSTR, byval w as long = 32, byval h as long = 32, byval additionalflags as ulong = 0) as HICON
		return LoadImage(0, iconpath, IMAGE_ICON, w, h, LR_LOADFROMFILE or additionalflags)
	end function
	function loadbmp(byval bmppath as LPTSTR, byval w as long, byval h as long, byval additionalflags as ulong = 0) as HBITMAP
		return LoadImage(0, bmppath, IMAGE_BITMAP, w, h, LR_LOADFROMFILE or additionalflags)
	end function
	
	type BASE_CLASS
		declare destructor()
		declare property x(byval newx as long)
		declare property x() as long
		declare property y(byval newy as long)
		declare property y() as long
		declare property w(byval neww as long)
		declare property w() as long
		declare property h(byval newh as long)
		declare property h() as long
		declare property caption(byval newcaption as LPTSTR)
		declare property caption() as LPTSTR
		declare property styles(byval newstyles as long)
		declare property styles() as long
		declare property extended(byval newextstyles as long)
		declare property extended() as long
		declare property enabled(byval newenabled as boolean)
		declare property enabled() as boolean
		declare property visible(byval newvisible as boolean)
		declare property visible() as boolean
		declare property parent(byval newparent as HWND)
		declare property parent() as HWND
		declare property font(byval newfont as HFONT)
		declare property font() as HFONT
		declare property hwin() as HWND
		protected:
			as HWND winhandle
	end type
	type APPWINDOW extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval cval as LPTSTR, _
							byval sval as long = OGL.DS.WIN, byval eval as long = 0, byval pval as HWND = 0, byval ival as HICON = 0, byval mval as HMENU = 0, _
							byval stval as ulong = SW_SHOW, byval zval as HWND = HWND_TOP)
		declare property icon(byval newicon as HICON)
		declare property icon() as HICON
		declare property menu(byval newmenu as HMENU)
		declare property menu() as HMENU
		declare property state(byval newstate as ulong)
		declare property state() as ulong
		declare property z(byval newz as HWND)
		declare function getzprevious() as HWND
		declare function getznext() as HWND
		declare function uponclose(byref msg as MSG) as boolean
		declare function msgbox(byval message as LPTSTR, byval caption as LPTSTR = cast(LPTSTR, @"Message"), byval styles as ulong = MB_ICONEXCLAMATION or MB_APPLMODAL) as long
		declare sub updatemenu()
	end type
	type GUIFONT
		declare constructor(byval fval as LPTSTR = NULL, byval ahval as long = 16, byval awval as long = 6, byval wval as long = 0, _
							byval ival as boolean = false, byval uval as boolean = false, byval sval as boolean = false)
		declare destructor()
		declare property fonth() as HFONT
		protected:
			as HFONT fonthandle
	end type
	dim as GUIFONT SYSFONT = GUIFONT
	type LABEL extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.LBL, _
							byval eval as long = 0)
		declare property image(byval newimg as HANDLE)
		declare property image() as HANDLE
	end type
	type BUTTON extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.BTN, _
							byval eval as long = 0)
		declare property image(byval newimg as HANDLE)
		declare property image() as HANDLE
	end type
	type CHECKBOX extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.CB, _
							byval eval as long = 0, byval stateval as boolean = false, byval autoornot as boolean = true)
		declare property state(byval newstate as boolean)
		declare property state() as boolean
		declare property image(byval newimg as HANDLE)
		declare property image() as HANDLE
	end type
	type CHECKBOX3WAY extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.CBTW, _
							byval eval as long = 0, byval stateval as OGL.CB3W = OGL.CB3W.UNCHECKED, byval autoornot as boolean = true)
		declare property state(byval newstate as OGL.CB3W)
		declare property state() as OGL.CB3W
		declare property image(byval newimg as HANDLE)
		declare property image() as HANDLE
	end type
	type RADIOBUTTON extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.RB, _
							byval eval as long = 0, byval stateval as boolean = false, byval autoornot as boolean = true)
		declare property state(byval newstate as boolean)
		declare property state() as boolean
		declare property image(byval newimg as HANDLE)
		declare property image() as HANDLE
	end type
	type GROUPBOX extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.GB, byval eval as long = 0)
		declare property enabled(byval newstate as boolean)
		declare property enabled() as boolean
	end type
	type STATICOBJ extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval oval as OGL.SO = OGL.SO.GRAY, byval sval as long = OGL.DS.STATO, byval eval as long = 0)
	end type
	type TEXT_CLASS extends BASE_CLASS
		declare property edit_modify(byval newstate as boolean)
		declare property edit_modify() as boolean
		declare property edit_textlimit(byval newtl as ulong)
		declare property edit_textlimit() as ulong
		declare property edit_passwordchar(byval newchar as LPTSTR)
		declare property edit_passwordchar() as LPTSTR
		declare property edit_wordbreakproc(byval newproc as EDITWORDBREAKPROC) 'requires testing
		declare property edit_wordbreakproc() as EDITWORDBREAKPROC 'requires testing
		declare function edit_getselection() as LPTSTR
		declare function edit_handle() as HWND
		declare function edit_getlinelength(byval lineindex as long) as long
		declare function edit_getfirstvisibleitem() as ulong 'doesn't seem to work with single-line editboxes
		declare function edit_getline(byval lineindex as ulong = 0) as LPTSTR
		declare function edit_linecount() as ulong
		declare function edit_getlineofchar(byval charindex as long = -1) as ulong 'BE WARNED! this also includes indexes for each cartridge return!
		declare function edit_getfirstcharoflineindex(byval lineindex as long = -1) as long 'BE WARNED! this also includes indexes for each cartridge return!
		declare sub edit_setselection(byval startindex as long = 0, byval endindex as long = -1)
		declare sub edit_replaceselection(byval replacewith as LPTSTR = NULL, byval undoflag as boolean = false)
		declare sub edit_copy()
		declare sub edit_cut()
		declare sub edit_paste()
		declare sub edit_scroll(byval bychar as long, byval byline as long)
		declare sub edit_scrolltocaret()
		protected:
			as HWND editcontrol
	end type
	type COMBOBOX extends TEXT_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.COMBO, byval eval as long = 0, _
							byval tlval as ulong = 30000, byval ddwval as long = -1)
		declare property textlimit(byval newlimit as ulong)
		declare property textlimit() as ulong
		declare property dropdownwidth(byval newwidth as long)
		declare property dropdownwidth() as long
		declare property selection(byval itemindex as long)
		declare property selection() as long
		declare property itemtext(byval index as long, byval newstr as LPTSTR)
		declare property itemtext(byval index as long) as LPTSTR
		declare property liststate(byval newstate as boolean)
		declare property liststate() as boolean
		declare property topindex(byval itemindex as ulong)
		declare property topindex() as ulong
		declare property itemheight(byval newh as long)
		declare property itemheight() as long
		declare property editheight(byval newh as long)
		declare property editheight() as long
		declare function itemcount() as ulong
		declare sub insertitem(byval itemindex as long, byval itemtext as LPTSTR)
		declare sub removeitem(byval itemindex as long = -1)
		declare sub additem(byval itemtext as LPTSTR) 'this function is to be used if you want your list box sorted!
		protected:
			as ulong txtlimit
	end type
	type TEXTBOX extends TEXT_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.TB, byval eval as long = 0, _
							byval tlval as ulong = 30000)
	end type
	type LISTBOX extends BASE_CLASS
		declare constructor(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.LB, byval eval as long = 0)
		declare property selection(byval itemindex as long)
		declare property selection() as long
		declare property itemtext(byval index as long, byval newstr as LPTSTR)
		declare property itemtext(byval index as long) as LPTSTR
		declare property topindex(byval itemindex as ulong)
		declare property topindex() as ulong
		declare property itemheight(byval newh as long)
		declare property itemheight() as long
		declare function itemcount() as ulong
		declare function selectioncount() as ulong
		declare function getselitemsindex(byval maxitemcount as ulong) as ulong ptr
		declare sub insertitem(byval itemindex as long, byval itemtext as LPTSTR)
		declare sub removeitem(byval itemindex as long = -1)
		declare sub additem(byval itemtext as LPTSTR) 'this functions is to be used if you want your list box sorted!
		declare sub setselitems(byval istart as ulong, byval iend as ulong, byval sflag as boolean = true)
		declare sub setcolumnwidth(byval w as long)
	end type
end namespace

destructor OGL.BASE_CLASS
	DestroyWindow(this.winhandle)
end destructor
property OGL.BASE_CLASS.x(byval newx as long)
	setwindowpos(this.winhandle, 0, newx, this.y, this.w, this.h, SWP_NOZORDER)
end property
property OGL.BASE_CLASS.x() as long
	dim as RECT temp
	getwindowrect(this.winhandle, @temp)
	return temp.left
end property
property OGL.BASE_CLASS.y(byval newy as long)
	setwindowpos(this.winhandle, 0, this.x, newy, this.w, this.h, SWP_NOZORDER)
end property
property OGL.BASE_CLASS.y() as long
	dim as RECT temp
	getwindowrect(this.winhandle, @temp)
	return temp.top
end property
property OGL.BASE_CLASS.w(byval neww as long)
	setwindowpos(this.winhandle, 0, this.x, this.y, neww, this.h, SWP_NOZORDER)
end property
property OGL.BASE_CLASS.w() as long
	dim as RECT temp
	getwindowrect(this.winhandle, @temp)
	return temp.right-temp.left
end property
property OGL.BASE_CLASS.h(byval newh as long)
	setwindowpos(this.winhandle, 0, this.x, this.y, this.w, newh, SWP_NOZORDER)
end property
property OGL.BASE_CLASS.h() as long
	dim as RECT temp
	getwindowrect(this.winhandle, @temp)
	return temp.bottom-temp.top
end property
property OGL.BASE_CLASS.caption(byval newcaption as LPTSTR)
	SetWindowText(this.winhandle, newcaption)
end property
property OGL.BASE_CLASS.caption() as LPTSTR
	dim as LPTSTR buffer = callocate(GetWindowTextLength(this.winhandle)+1, 2)
	GetWindowText(this.winhandle, buffer, GetWindowTextLength(this.winhandle)+1*2)
	return buffer
end property
property OGL.BASE_CLASS.styles(byval newstyles as long)
	setwindowlong(this.winhandle, GWL_STYLE, newstyles)
end property
property OGL.BASE_CLASS.styles() as long
	return getwindowlong(this.winhandle, GWL_STYLE)
end property
property OGL.BASE_CLASS.extended(byval newextstyles as long)
	setwindowlong(this.winhandle, GWL_EXSTYLE, newextstyles)
end property
property OGL.BASE_CLASS.extended() as long
	return getwindowlong(this.winhandle, GWL_EXSTYLE)
end property

property OGL.BASE_CLASS.enabled(byval newenabled as boolean)
	EnableWindow(this.winhandle, newenabled)
end property
property OGL.BASE_CLASS.enabled() as boolean
	return IsWindowEnabled(this.winhandle)
end property
property OGL.BASE_CLASS.visible(byval newvisible as boolean)
	ShowWindow(this.winhandle, iif(newvisible, SW_SHOW, SW_HIDE))
end property
property OGL.BASE_CLASS.visible() as boolean
	return IsWindowVisible(this.winhandle)
end property
property OGL.BASE_CLASS.parent(byval newparent as HWND)
	setparent(this.winhandle, newparent)
end property
property OGL.BASE_CLASS.parent() as HWND
	return getparent(this.winhandle)
end property
property OGL.BASE_CLASS.font(byval newfont as HFONT)
	SendMessage(this.winhandle, WM_SETFONT, cast(WPARAM, newfont), true)
end property
property OGL.BASE_CLASS.font() as HFONT
	dim as HFONT ptr ret = cast(HFONT ptr, SendMessage(this.winhandle, WM_GETFONT, 0, 0))
	return *ret
end property
property OGL.BASE_CLASS.hwin() as HWND
	return this.winhandle
end property

constructor OGL.APPWINDOW(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval cval as LPTSTR, _
						  byval sval as long = OGL.DS.WIN, byval eval as long = 0, byval pval as HWND = 0, byval ival as HICON = 0, byval mval as HMENU = 0, _
						  byval stval as ulong = SW_SHOW, byval zval as HWND = HWND_TOP)
	this.winhandle = CreateWindowEx(eval, "#32770", cval, sval, xval, yval, wval, hval, pval, mval, GetModuleHandle(0), 0)
	this.icon = ival
	this.state = stval
	this.z = zval
end constructor
property OGL.APPWINDOW.icon(byval newicon as HICON)
	SendMessage(this.winhandle, WM_SETICON, ICON_SMALL, cast(LPARAM, newicon))
end property
property OGL.APPWINDOW.icon() as HICON
	return cast(HICON, SendMessage(this.winhandle, WM_GETICON, ICON_SMALL, 0))
end property
property OGL.APPWINDOW.menu(byval newmenu as HMENU)
	setmenu(this.winhandle, newmenu)
end property
property OGL.APPWINDOW.menu() as HMENU
	return getmenu(this.winhandle)
end property
property OGL.APPWINDOW.state(byval newstate as ulong)
	showwindow(this.winhandle, newstate)
end property
property OGL.APPWINDOW.state() as ulong
	dim as WINDOWPLACEMENT wptemp
	wptemp.length = sizeof(WINDOWPLACEMENT)
	getwindowplacement(this.winhandle, @wptemp)
	return wptemp.showCmd
end property
property OGL.APPWINDOW.z(byval newz as HWND)
	setwindowpos(this.winhandle, newz, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
end property
function OGL.APPWINDOW.getzprevious() as HWND
	return getnextwindow(this.winhandle, GW_HWNDPREV)
end function
function OGL.APPWINDOW.getznext() as HWND
	return getnextwindow(this.winhandle, GW_HWNDNEXT)
end function
function OGL.APPWINDOW.uponclose(byref msg as MSG) as boolean
	if msg.hwnd = this.winhandle and msg.message = 161 and msg.wParam = 20 then return true else return false
end function
function OGL.APPWINDOW.msgbox(byval message as LPTSTR, byval caption as LPTSTR = cast(LPTSTR, @"Message"), byval styles as ulong = MB_ICONEXCLAMATION or MB_APPLMODAL) as long
	return messagebox(this.winhandle, message, caption, styles)
end function
sub OGL.APPWINDOW.updatemenu()
	drawmenubar(this.winhandle)
end sub

constructor OGL.GUIFONT(byval fval as LPTSTR = NULL, byval ahval as long = 16, byval awval as long = 6, byval wval as long = 0, _
						byval ival as boolean = false, byval uval as boolean = false, byval sval as boolean = false)
	if fval = NULL then
		this.fonthandle = CreateFont(ahval, awval, 0, 0, wval, ival, uval, sval, ANSI_CHARSET, false, false, DEFAULT_QUALITY, DEFAULT_PITCH or FF_ROMAN, "arial")
	else
		dim as LPCTSTR fontname = fval
		this.fonthandle = CreateFont(ahval, awval, 0, 0, wval, ival, uval, sval, ANSI_CHARSET, false, false, DEFAULT_QUALITY, DEFAULT_PITCH or FF_ROMAN, fontname)
	endif
end constructor
destructor OGL.GUIFONT()
	DeleteObject(this.fonthandle)
end destructor

property OGL.GUIFONT.fonth() as HFONT
	return this.fonthandle
end property

constructor OGL.LABEL(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
					  byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.LBL, _
					  byval eval as long = 0)
	this.winhandle = CreateWindowEx(eval, "STATIC", cval, WS_CHILD or sval, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	if sval and SS_ICON or sval and SS_BITMAP then this.image = imgval else this.font = fval
end constructor
property OGL.LABEL.image(byval newimg as HANDLE)
	dim as HANDLE img = cast(HANDLE, SendMessage(this.winhandle, STM_SETIMAGE, IMAGE_ICON, cast(LPARAM, newimg)))
	if img <> newimg then SendMessage(this.winhandle, STM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM, newimg))
end property
property OGL.LABEL.image() as HANDLE
	dim as HANDLE ret = cast(HANDLE, SendMessage(this.winhandle, STM_GETIMAGE, IMAGE_ICON, 0))
	if ret = null then ret = cast(HANDLE, SendMessage(this.winhandle, STM_GETIMAGE, IMAGE_BITMAP, 0))
	return ret
end property

constructor OGL.BUTTON(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
					   byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.BTN, _
					   byval eval as long = 0)
	this.winhandle = CreateWindowEx(eval, "BUTTON", cval, WS_CHILD or sval, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	if sval and BS_ICON or sval and BS_BITMAP then this.image = imgval else this.font = fval
end constructor
property OGL.BUTTON.image(byval newimg as HANDLE)
	dim as HANDLE img = cast(HANDLE, SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_ICON, cast(LPARAM, newimg)))
	if img <> newimg then SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM, newimg))
end property
property OGL.BUTTON.image() as HANDLE
	dim as HANDLE ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_ICON, 0))
	if ret = null then ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_BITMAP, 0))
	return ret
end property

constructor OGL.CHECKBOX(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
						 byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.CB, _
						 byval eval as long = 0, byval stateval as boolean = false, byval autoornot as boolean = true)
	this.winhandle = CreateWindowEx(eval, "BUTTON", cval, WS_CHILD or iif(autoornot, BS_AUTOCHECKBOX, BS_CHECKBOX) or sval, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	if sval and BS_ICON or sval and BS_BITMAP then this.image = imgval else this.font = fval
	this.state = stateval
end constructor
property OGL.CHECKBOX.state(byval newstate as boolean)
	SendMessage(this.winhandle, BM_SETCHECK, iif(newstate, BST_CHECKED, BST_UNCHECKED), 0)
end property
property OGL.CHECKBOX.state() as boolean
	dim as long ret = SendMessage(this.winhandle, BM_GETCHECK, 0, 0)
	if ret = BST_CHECKED then return true else return false
end property
property OGL.CHECKBOX.image(byval newimg as HANDLE)
	dim as HANDLE img = cast(HANDLE, SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_ICON, cast(LPARAM, newimg)))
	if img <> newimg then SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM, newimg))
end property
property OGL.CHECKBOX.image() as HANDLE
	dim as HANDLE ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_ICON, 0))
	if ret = null then ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_BITMAP, 0))
	return ret
end property

constructor OGL.CHECKBOX3WAY(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							 byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.CBTW, _
							 byval eval as long = 0, byval stateval as OGL.CB3W = OGL.CB3W.UNCHECKED, byval autoornot as boolean = true)
	this.winhandle = CreateWindowEx(eval, "BUTTON", cval, WS_CHILD or iif(autoornot, BS_AUTO3STATE, BS_3STATE) or sval, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	if sval and BS_ICON or sval and BS_BITMAP then this.image = imgval else this.font = fval
	this.state = stateval
end constructor
property OGL.CHECKBOX3WAY.state(byval newstate as OGL.CB3W)
	SendMessage(this.winhandle, BM_SETCHECK, newstate, 0)
end property
property OGL.CHECKBOX3WAY.state() as OGL.CB3W
	select case SendMessage(this.winhandle, BM_GETCHECK, 0, 0)
		case BST_CHECKED
			return OGL.CB3W.CHECKED
		case BST_UNCHECKED
			return OGL.CB3W.UNCHECKED
		case else
			return OGL.CB3W.INDETERMINATE
	end select
end property
property OGL.CHECKBOX3WAY.image(byval newimg as HANDLE)
	dim as HANDLE img = cast(HANDLE, SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_ICON, cast(LPARAM, newimg)))
	if img <> newimg then SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM, newimg))
end property
property OGL.CHECKBOX3WAY.image() as HANDLE
	dim as HANDLE ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_ICON, 0))
	if ret = null then ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_BITMAP, 0))
	return ret
end property

constructor OGL.RADIOBUTTON(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
							byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval imgval as HANDLE = 0, byval sval as long = OGL.DS.RB, _
							byval eval as long = 0, byval stateval as boolean = false, byval autoornot as boolean = true)
	this.winhandle = CreateWindowEx(eval, "BUTTON", cval, WS_CHILD or iif(autoornot, BS_AUTORADIOBUTTON, BS_RADIOBUTTON) or sval, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	if sval and BS_ICON or sval and BS_BITMAP then this.image = imgval else this.font = fval
	this.state = stateval
end constructor
property OGL.RADIOBUTTON.state(byval newstate as boolean)
	SendMessage(this.winhandle, BM_SETCHECK, iif(newstate, BST_CHECKED, BST_UNCHECKED), 0)
end property
property OGL.RADIOBUTTON.state() as boolean
	dim as long ret = SendMessage(this.winhandle, BM_GETCHECK, 0, 0)
	if ret = BST_CHECKED then return true else return false
end property
property OGL.RADIOBUTTON.image(byval newimg as HANDLE)
	dim as HANDLE img = cast(HANDLE, SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_ICON, cast(LPARAM, newimg)))
	if img <> newimg then SendMessage(this.winhandle, BM_SETIMAGE, IMAGE_BITMAP, cast(LPARAM, newimg))
end property
property OGL.RADIOBUTTON.image() as HANDLE
	dim as HANDLE ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_ICON, 0))
	if ret = null then ret = cast(HANDLE, SendMessage(this.winhandle, BM_GETIMAGE, IMAGE_BITMAP, 0))
	return ret
end property

constructor OGL.GROUPBOX(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
						 byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.GB, byval eval as long = 0)
	this.winhandle = CreateWindowEx(eval, "BUTTON", cval, WS_CHILD or BS_GROUPBOX or sval, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	this.font = fval
end constructor
property OGL.GROUPBOX.enabled(byval newstate as boolean)
	EnableWindow(this.winhandle, newstate)
end property
property OGL.GROUPBOX.enabled() as boolean
	return iswindowenabled(this.winhandle)
end property

constructor OGL.STATICOBJ(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
						  byval oval as OGL.SO = OGL.SO.GRAY, byval sval as long = OGL.DS.STATO, byval eval as long = 0)
	this.winhandle = CreateWindowEx(eval, "STATIC", "", WS_CHILD or oval or sval, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
end constructor

property OGL.TEXT_CLASS.edit_modify(byval newstate as boolean)
	SendMessage(this.editcontrol, EM_SETMODIFY, newstate, 0)
end property
property OGL.TEXT_CLASS.edit_modify() as boolean
	return SendMessage(this.editcontrol, EM_GETMODIFY, 0, 0)
end property
property OGL.TEXT_CLASS.edit_textlimit(byval newtl as ulong)
	SendMessage(this.editcontrol, EM_SETLIMITTEXT, newtl, 0)
end property
property OGL.TEXT_CLASS.edit_textlimit() as ulong
	return SendMessage(this.editcontrol, EM_GETLIMITTEXT, 0, 0)
end property
property OGL.TEXT_CLASS.edit_passwordchar(byval newchar as LPTSTR)
	if newchar <> NULL then
		if len(*newchar) > 1 then *newchar = left(*newchar, 1)
		SendMessage(this.editcontrol, EM_SETPASSWORDCHAR, asc(*newchar), 0)
	endif
end property
property OGL.TEXT_CLASS.edit_passwordchar() as LPTSTR
	dim as LPTSTR ret = callocate(2, 2)
	#ifdef UNICODE
		*ret = wchr(SendMessage(this.editcontrol, EM_GETPASSWORDCHAR, 0, 0))
	#else
		*ret = chr(SendMessage(this.editcontrol, EM_GETPASSWORDCHAR, 0, 0))
	#endif
	return ret
end property
property OGL.TEXT_CLASS.edit_wordbreakproc(byval newproc as editwordbreakproc)
	SendMessage(this.editcontrol, EM_SETWORDBREAKPROC, 0, cast(LPARAM, newproc))
end property
property OGL.TEXT_CLASS.edit_wordbreakproc() as editwordbreakproc
	return cast(editwordbreakproc, SendMessage(this.editcontrol, EM_GETWORDBREAKPROC, 0, 0))
end property
function OGL.TEXT_CLASS.edit_getselection() as LPTSTR 'phew! THIS function took a while to crack!
	dim as ulong start = loword(SendMessage(this.editcontrol, EM_GETSEL, 0, 0))+1, iend = hiword(SendMessage(this.editcontrol, EM_GETSEL, 0, 0))
	dim as LPTSTR ret = callocate(iend-start, 2), buffer = callocate(GetWindowTextLength(this.editcontrol)+1, 2)
	GetWindowText(this.editcontrol, buffer, len(*buffer))
	for loopVar as long = loword(SendMessage(this.editcontrol, EM_GETSEL, 0, 0))+1 to hiword(SendMessage(this.editcontrol, EM_GETSEL, 0, 0))
		*ret &= mid(*buffer, loopVar, 1)
	next
	return ret
end function
function OGL.TEXT_CLASS.edit_handle() as HWND
	return this.editcontrol
end function
function OGL.TEXT_CLASS.edit_getlinelength(byval lineindex as long) as long
	return SendMessage(this.editcontrol, EM_LINELENGTH, lineindex, 0)
end function
function OGL.TEXT_CLASS.edit_getfirstvisibleitem() as ulong
	return SendMessage(this.editcontrol, EM_GETFIRSTVISIBLELINE, 0, 0)
end function
function OGL.TEXT_CLASS.edit_getline(byval lineindex as ulong = 0) as LPTSTR
	dim as LPTSTR buffer = callocate(SendMessage(this.editcontrol, EM_LINELENGTH, SendMessage(this.editcontrol, EM_LINEINDEX, lineindex, 0), 0)+1, 2)
	SendMessage(this.editcontrol, EM_GETLINE, lineindex, cast(LPARAM, buffer))
	return buffer
end function
function OGL.TEXT_CLASS.edit_linecount() as ulong
	return SendMessage(this.editcontrol, EM_GETLINECOUNT, 0, 0)
end function
function OGL.TEXT_CLASS.edit_getlineofchar(byval charindex as long = -1) as ulong
	return SendMessage(this.editcontrol, EM_LINEFROMCHAR, charindex, 0)
end function
function OGL.TEXT_CLASS.edit_getfirstcharoflineindex(byval lineindex as long = -1) as long
	return SendMessage(this.editcontrol, EM_LINEINDEX, lineindex, 0)
end function
sub OGL.TEXT_CLASS.edit_setselection(byval startindex as long = 0, byval endindex as long = -1)
	SendMessage(this.editcontrol, em_setsel, startindex, endindex)
end sub
sub OGL.TEXT_CLASS.edit_replaceselection(byval replacewith as LPTSTR = NULL, byval undoflag as boolean = false)
	if replacewith <> NULL then SendMessage(this.editcontrol, EM_REPLACESEL, undoflag, cast(LPARAM, replacewith)) else _
		SendMessage(this.editcontrol, WM_CLEAR, 0, 0)
end sub
sub OGL.TEXT_CLASS.edit_copy()
	SendMessage(this.editcontrol, WM_COPY, 0, 0)
end sub
sub OGL.TEXT_CLASS.edit_cut()
	SendMessage(this.editcontrol, WM_CUT, 0, 0)
end sub
sub OGL.TEXT_CLASS.edit_paste()
	SendMessage(this.editcontrol, WM_PASTE, 0, 0)
end sub
sub OGL.TEXT_CLASS.edit_scroll(byval bychar as long, byval byline as long)
	SendMessage(this.editcontrol, em_linescroll, bychar, byline)
end sub
sub OGL.TEXT_CLASS.edit_scrolltocaret()
	SendMessage(this.editcontrol, em_scrollcaret, 0, 0)
end sub

constructor OGL.COMBOBOX(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
						 byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.COMBO, byval eval as long = 0, _
						 byval tlval as ulong = 30000, byval ddwval as long = -1)
	this.winhandle = CreateWindowEx(eval, "COMBOBOX", cval, sval or WS_CHILD, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	this.font = fval
	SendMessage(this.winhandle, WM_SETTEXT, 0, cast(LPARAM, cval))
	this.textlimit = tlval
	dim as COMBOBOXINFO cbi
	cbi.cbSize = sizeof(COMBOBOXINFO)
	getcomboboxinfo(this.winhandle, @cbi)
	this.editcontrol = cbi.hwndItem
	if ddwval >= 0 then this.dropdownwidth = ddwval
end constructor
property OGL.COMBOBOX.textlimit(byval newlimit as ulong)
	this.txtlimit = newlimit
	SendMessage(this.winhandle, CB_LIMITTEXT, newlimit, 0)
end property
property OGL.COMBOBOX.textlimit() as ulong
	return this.txtlimit
end property
property OGL.COMBOBOX.dropdownwidth(byval newwidth as long)
	SendMessage(this.winhandle, CB_SETDROPPEDWIDTH, newwidth, 0)
end property
property OGL.COMBOBOX.dropdownwidth() as long
	return SendMessage(this.winhandle, CB_GETDROPPEDWIDTH, 0, 0)
end property
property OGL.COMBOBOX.selection(byval itemindex as long)
	SendMessage(this.winhandle, CB_SETCURSEL, itemindex, 0)
end property
property OGL.COMBOBOX.selection() as long
	return SendMessage(this.winhandle, CB_GETCURSEL, 0, 0)
end property
property OGL.COMBOBOX.itemtext(byval index as long, byval newstr as LPTSTR)
	if index = -1 then index = this.selection
	if index <> cb_err then
		SendMessage(this.winhandle, CB_DELETESTRING, index, 0)
		if this.styles and CBS_SORT then
			SendMessage(this.winhandle, CB_ADDSTRING, 0, cast(LPARAM, newstr))
		else
			SendMessage(this.winhandle, CB_INSERTSTRING, index, cast(LPARAM, newstr))
		endif
	endif
end property
property OGL.COMBOBOX.itemtext(byval index as long) as LPTSTR
	if index = -1 then
		index = this.selection
		if index = CB_ERR then return NULL
	endif
	dim as long length = SendMessage(this.winhandle, CB_GETLBTEXTLEN, index, 0)
	dim as LPTSTR it = callocate(length+1, 2)
	SendMessage(this.winhandle, CB_GETLBTEXT, index, cast(LPARAM, it))
	*it = trim(*it)
	return it
end property
property OGL.COMBOBOX.liststate(byval newstate as boolean)
	SendMessage(this.winhandle, CB_SHOWDROPDOWN, newstate, 0)
end property
property OGL.COMBOBOX.liststate() as boolean
	return SendMessage(this.winhandle, CB_GETDROPPEDSTATE, 0, 0)
end property
property OGL.COMBOBOX.topindex(byval itemindex as ulong)
	SendMessage(this.winhandle, CB_SETTOPINDEX, itemindex, 0)
end property
property OGL.COMBOBOX.topindex() as ulong
	return SendMessage(this.winhandle, CB_GETTOPINDEX, 0, 0)
end property
property OGL.COMBOBOX.itemheight(byval newh as long)
	SendMessage(this.winhandle, CB_SETITEMHEIGHT, 0, newh)
end property
property OGL.COMBOBOX.itemheight() as long
	return SendMessage(this.winhandle, CB_GETITEMHEIGHT, 0, 0)
end property
property OGL.COMBOBOX.editheight(byval newh as long)
	SendMessage(this.winhandle, CB_SETITEMHEIGHT, -1, newh)
end property
property OGL.COMBOBOX.editheight() as long
	return SendMessage(this.winhandle, CB_GETITEMHEIGHT, -1, 0)
end property
function OGL.COMBOBOX.itemcount() as ulong
	return SendMessage(this.winhandle, CB_GETCOUNT, 0, 0)
end function
sub OGL.COMBOBOX.insertitem(byval itemindex as long, byval it as LPTSTR)
	SendMessage(this.winhandle, CB_INSERTSTRING, itemindex, cast(LPARAM, it))
end sub
sub OGL.COMBOBOX.removeitem(byval itemindex as long = -1)
	if itemindex = -1 then SendMessage(this.winhandle, CB_RESETCONTENT, 0, 0) else SendMessage(this.winhandle, CB_DELETESTRING, itemindex, 0)
end sub
sub OGL.COMBOBOX.additem(byval it as LPTSTR)
	SendMessage(this.winhandle, CB_ADDSTRING, 0, cast(LPARAM, it))
end sub

constructor OGL.TEXTBOX(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
						byval cval as LPTSTR = NULL, byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.TB, byval eval as long = 0, _
						byval tlval as ulong = 30000)
	this.winhandle = CreateWindowEx(eval, "EDIT", cval, sval or WS_CHILD, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	this.font = fval
	this.editcontrol = this.winhandle
	this.edit_textlimit = tlval
end constructor

constructor OGL.LISTBOX(byval xval as long, byval yval as long, byval wval as long, byval hval as long, byval pval as HWND, _
						byval fval as HFONT = SYSFONT.fonth, byval sval as long = OGL.DS.LB, byval eval as long = 0)
	this.winhandle = CreateWindowEx(eval, "LISTBOX", "", sval or WS_CHILD, xval, yval, wval, hval, pval, 0, GetModuleHandle(0), 0)
	this.font = fval
end constructor
property OGL.LISTBOX.selection(byval itemindex as long)
	SendMessage(this.winhandle, LB_SETCURSEL, itemindex, 0)
end property
property OGL.LISTBOX.selection() as long
	return SendMessage(this.winhandle, LB_GETCURSEL, 0, 0)
end property
property OGL.LISTBOX.itemtext(byval index as long, byval newstr as LPTSTR)
	if index = -1 then index = this.selection
	if index <> CB_ERR then
		SendMessage(this.winhandle, LB_DELETESTRING, index, 0)
		if this.styles and LBS_SORT then
			SendMessage(this.winhandle, LB_ADDSTRING, 0, cast(LPARAM, newstr))
		else
			SendMessage(this.winhandle, LB_INSERTSTRING, index, cast(LPARAM, newstr))
		endif
	endif
end property
property OGL.LISTBOX.itemtext(byval index as long) as LPTSTR
	if index = -1 then
		index = this.selection
		if index = LB_ERR then return NULL
	endif
	dim as long length = SendMessage(this.winhandle, LB_GETTEXTLEN, index, 0)
	dim as LPTSTR it = callocate(length+1, 2)
	SendMessage(this.winhandle, LB_GETTEXT, index, cast(LPARAM, it))
	*it = trim(*it)
	return it
end property
property OGL.LISTBOX.topindex(byval itemindex as ulong)
	SendMessage(this.winhandle, LB_SETTOPINDEX, itemindex, 0)
end property
property OGL.LISTBOX.topindex() as ulong
	return SendMessage(this.winhandle, LB_GETTOPINDEX, 0, 0)
end property
property OGL.LISTBOX.itemheight(byval newh as long)
	SendMessage(this.winhandle, LB_SETITEMHEIGHT, 0, newh)
end property
property OGL.LISTBOX.itemheight() as long
	return SendMessage(this.winhandle, LB_GETITEMHEIGHT, 0, 0)
end property
function OGL.LISTBOX.itemcount() as ulong
	return SendMessage(this.winhandle, LB_GETCOUNT, 0, 0)
end function
function OGL.LISTBOX.selectioncount() as ulong
	return SendMessage(this.winhandle, LB_GETSELCOUNT, 0, 0)
end function
function OGL.LISTBOX.getselitemsindex(byval maxitemcount as ulong) as ulong ptr
	dim as ulong ptr pindex = callocate(maxitemcount, sizeof(ulong))
	if pindex = NULL then return 0
	SendMessage(this.winhandle, LB_GETSELITEMS, maxitemcount, cast(LPARAM, pindex))
	return pindex
end function
sub OGL.LISTBOX.insertitem(byval itemindex as long, byval it as LPTSTR)
	SendMessage(this.winhandle, LB_INSERTSTRING, itemindex, cast(LPARAM, it))
end sub
sub OGL.LISTBOX.removeitem(byval itemindex as long = -1)
	if itemindex = -1 then SendMessage(this.winhandle, LB_RESETCONTENT, 0, 0) else SendMessage(this.winhandle, LB_DELETESTRING, itemindex, 0)
end sub
sub OGL.LISTBOX.additem(byval it as LPTSTR)
	SendMessage(this.winhandle, LB_ADDSTRING, 0, cast(LPARAM, it))
end sub
sub OGL.LISTBOX.setselitems(byval istart as ulong, byval iend as ulong, byval sflag as boolean = true)
	SendMessage(this.winhandle, LB_SELITEMRANGE, sflag, MAKELPARAM(istart, iend))
end sub
sub OGL.LISTBOX.setcolumnwidth(byval w as long)
	SendMessage(this.winhandle, lb_setcolumnwidth, w, 0)
end sub
