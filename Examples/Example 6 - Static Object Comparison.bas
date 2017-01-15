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

'this program demonstrates what you can do with the _STATIC control type

'notice: this was one of the original examples of the OGL,
'which demonstrated the use of the STATICOBJ class.
'This class has not been exclusively given a control type,
'instead, one is to use the _STATIC or LABEL control types.

'include the header file
#include "OGL.bi"

'bring the OGL namespace into scope
using OGL

'create the MSG structure used to hold messages, and our controls
dim as MSG msg
dim as GUIWIN win = GUIWIN(200, 200, 700, 400, "Static Objects in the OGL")
dim as ulong blackbox = win.allowin(CT._STATIC, 5, 5, 200, 200, , SS_BLACKRECT), _
	graybox = win.allowin(CT._STATIC, 25, 25, 200, 200, , SS_GRAYRECT), _
	whitebox = win.allowin(CT._STATIC, 45, 45, 200, 200, , SS_WHITERECT or WS_BORDER), _ 'remember that the white box has a border!
	blackframe = win.allowin(CT._STATIC, 325, 5, 200, 200, , SS_BLACKFRAME), _
	grayframe = win.allowin(CT._STATIC, 345, 25, 200, 200, , SS_GRAYFRAME), _
	whiteframe = win.allowin(CT._STATIC, 365, 45, 200, 200, , SS_WHITEFRAME)

'The values 1 and 2 can be used to great effect with the stat8ic objects and the dimension properties to produce lines
'(you can even choose their colour between the three demonstrated using the styles above!)
dim as ulong horizontal = win.allowin(CT._STATIC, 5, 255, 650, 1, , SS_GRAYFRAME), _
	horizontalthick = win.allowin(CT._STATIC, 5, 265, 650, 2, , SS_GRAYFRAME), _
	vertical = win.allowin(CT._STATIC, 280, 5, 1, 300, , SS_GRAYFRAME), _
	verticalthick = win.allowin(CT._STATIC, 290, 5, 2, 300, , SS_GRAYFRAME)

'this loop will execute forever until the user closes the window
do
	'this function is needed to correctly process messages sent to and fro in this application
	'it even plays a part in the uponclose() method,
	'so always put this line of code at the beginning of your loop!
	waitevent_all(msg)
	
loop until win.uponclose(msg) 'uponclose() returns true if the user closed the window using the X button
