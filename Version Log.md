Notation:
+ \+ Something has been added.
+ \- Something has been removed.
+ \* Something has been fixed.
+ ! Something has been amended in a significant way. This is most likely a fix which has major implications.
+ !! An important announcement which has nothing to do with the library itself but is important for the OGL series as a whole.

If a line is in **bold**, it signifies that it was or was influenced by a request posted at the forum at Free BASIC (not necessarily the specific OGL topic, but all requests should be posted there as your request may not be seen!).<br>

If a line is in *italic*, it signifies an improvement made to the library, made by somebody else, and has been incorporated into the OGL because they expressly wanted the improvement as part of the OGL. If you have an improvement which you want to incorporate, please post it on the OGL post.<br>

**Note** : I will **not** include an improvement without express permission from the author/s, and I will definitely **not** *directly* incorporate an improvement made by somebody else **which is owned by them**, *which* must be under the appropriate license found at License.md.

# 2.x
Here is the log for the 2.x series. Version history has started over again as it is a complete (and hopefully the ONLY) rewrite. It lists what it can do as of now: any updates will be listed separately.<br>
Here's a few pointers as to what the new version we have!... Actually, it doesn't add much new to the old versions: this is simply the re-write, after all!
**Version 2.0**
A re-write of the OGL.
It will support:
+ A 'main' window (the parent window). Multiple main windows are created using multiple instantiations of the GUIWIN class.
+ Child windows, which belong to the 'main' window. Child windows are internal instantiations of the GUIWIN class and are manipulated using the child property. Child windows themselves can have child windows.
+ The following child controls:
    + Labels (e.g. Static controls, which offer a bit more than just a label, e.g. borders, rectangles, images in icon or bitmap format etc.).
    + Buttons (facilitates also for toggle buttons such as the Checkbox and Radiobutton, but not fully for Groupboxes).
    + Textbox (also called Edit controls, a multi-line Textbox is considered a separate control in the OGL due to the amount of methods which can't be used with single-line editors).
    + Comboboxes (allows you to access the handle also to the Textbox portion should it have one).
    + Listboxes (you can create single and multi select listboxes, and they are considered separate control in the OGL due to the amount of methods which can't be used with single-select listboxes).
+ Allows for dynamic font amendment. You'd better check out the GUIFONT topics.
+ Allows you to create message boxes independently from a window or ones which belong to a window.
+ Supports Unicode, though not through wstring but through LPTSTR. This type is actually a pointer to string data, not string data itself like string is. Hopefully that helps any problems you might be having ;D.
+ The inclusion of windows.bi.
+ Allows for the storage of icon and bitmap handles in the GUIWIN object to be referenced with an index. As of now, images are only used with the image property, but as the OGL grows, there will be better support for the explicit creation of image lists as used with some CommonControls.
+ For technical details, please read the Requirements topic.

# 1.x
Here is the original log1 for the 1.x series:
!! The OGL was not originally under any license. OGL1.x and all future versions are now under the 3-Clause BSD License. Please read the License.md file.

**Version 1.1**
+ **\+ Added support for Unicode and ANSI through the use of LPTSTR. Just define UNICODE before including OGL.bi to support Unicode!**
+ \+ Enabled Checkbox controls to be become non-automatic.
+ \+ Added BASE_CLASS properties: enabled and visible.

**Version 1.0**

This is the first version of the OGL (there has been a sort of "beta" release where I didn't know what on earth I was doing XD - some features have been either temporarily or permanently removed since then).
