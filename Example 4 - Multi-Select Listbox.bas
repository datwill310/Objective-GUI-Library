'this program demonstrates how to use a listbox, particularly a multi-select one
'you will also find how to assign an icon to a window in this example!

'include the header files
#include "OGL.bi"
#include "dir.bi" 'included for the constants used with dir

'bring the OGL namespace into scope
using OGL

'define directory searching macro
#macro fileupdate
	if chdir(dirbox.caption) = 0 then
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