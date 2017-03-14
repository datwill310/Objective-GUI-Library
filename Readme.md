# Objective GUI Library (OGL)
An object-oriented, Free BASIC library used to create GUI programs. [Forum post](http://www.freebasic.net/forum/viewtopic.php?f=8&t=25207).

# Preparing to Release 2.1. (Tuesday 14th March, 2017)
I have decided to release 2.1 early. It has the following new features: basic DPI-awareness, some monitor methods (they are in the beta version!) and a few more x-&-y dimensional stuff, such as finding the central x and y of a window according to its owner/parent, and client dimension retrieval. Also another method not in the beta version which allows you to find the control index based on a handle given to it. At the moment, you can only do the other way around. I have found that this process can be helpful while I was programming something with the OGL :smile:!

2.1 is not yet released, but you can test with the beta file in OGL.beta. Primarily, this is actually for me and anyone techy who wants to help. Beta versions shouldn't break your computer or anything: but they shouldn't be used for actual programs as they have not yet been validated as 100% working. **Note to users of beta file: this version of 2.1 can only scale according to the primary monitor. The real version will scale accoridng to the monitor the window is within, but will not scale 100% correctly if control is hovering over two monitors.**

2.1 will be released this week, including an updated doc file, including a tutorial about how High-DPI awareness is used in the OGL (shout out to the forum!).

Sorry: unfortuneatly no CommonControl support yet :disappointed:. But I intend for version 2.2 support for ToolTips, and basic support for menus coming back to the OGL (the old support was mostly broken: you weren't missing anything).

# Version 2.1b is Released. (Sunday 12th March, 2017)
After a long time (sorry!), a beta version of the up and coming 2.1 version is out. Though it's not been fully validated yet, you can have a go and test the header file.

This beta version contains a few High-DPI aware features. A list of new features will only be published once I officially release 2.1.

Thanks for your patience.

# Version 2.0 is Officially Released! (Sunday 15th January, 2017)
Version 2.0 is officially released!

It's changed a lot from the 1.x series. I've updated the examples, the doc, and, of course, the header file :wink:!

Dynamic font amendment has been fixed. New tutorials. A new interface, which will make it even easier to extend the OGL, as well as use it!

A full list of what this new version can do can be found at the Version Log. Many tiny details will be fixed in the course of the next few hours.

Unfortunately, no Wishlist item has yet been implemented (oh, expect a few more entries here as well!). But for 2.1, I intend to implement High-DPI aware features, along with a few other bug fixes.

I hope you enjoy this new re-write of the OGL!

# Now Preparing For the Release of 2.0! (Sunday 15th January, 2017)
The repository will change dramatically over the cause of the next couple of days. This is because I'm preparing for the new release of the 2.0 version of the OGL!

The 1.x series will be moved to the new folder OGL.old. While the OGL2.0 is unreleased, you can find the current version of the OGL within this folder.

Thank you for your support! Version 2.0 is right around the corner!

Check the forum post for the latest updates!

# All Versions of the OGL are Now Released Under the 3-Clause BSD License. (Friday 6th January, 2017)
Please familiarise yourself with the License.md file. All textual files (including the doc and images, but NOT the XML files) will be licensed under the 3-Clause BSD. References will be provided in each file in this repository.<br>
The 2.x series will also be released under this license. The OGL is not dead but is still under major development.
Thanks for your time and support.

# Version 1.1 is Officially Released. (Saturday 26th November, 2016)
Now with support for Unicode and a few other goodies (check out the documentation for more!), hopefully this library is getting closer to becoming more relevant to your programming needs!<br>
For the manifest file and examples, please look at the first version's folder!<br>
**Note**: the updated Example 4 will not fully work because the Free BASIC dir command does not read filenames in Unicode. Instead a tiny update was made to the fileupdate macro so that the textbox' contents could be read: I'm not too fussed about coding a Windows API, fully Unicode version just yet.

# Version 1.0 is Officially Released. (Thursday 24th November, 2016)
It has the following features:<br>
- Constants - NL and TB_FULLMULTILINE
- Enumerations - CB3W, SO, and LS
- Namespaces - DS
- Functions - loadbmp(), loadico(), and waitevent()
- Objects - SYSFONT
- Classes -
    - APPWINDOW
    - BASE_CLASS
    - BUTTON
    - CHECKBOX
    - CHECKBOX3WAY
    - COMBOBOX
    - GROUPBOX
    - GUIFONT
    - LABEL
    - LISTBOX
    - RADIOBUTTON
    - STATICOBJ
    - TEXT_CLASS
    - TEXTBOX
- 8 code examples
- Manifest file to "modernise" your controls
- 4 in-documentation tutorials
- Documentation (you'd better look at that if you want to understand the full meaning behind this readme)
- The header file, OGL.bi

## BETA VERSION SCRAPPED - The old version 1.0 is no longer hosted online. The main features of the beta version were considered too broken or not useful enough to include in the official version.
