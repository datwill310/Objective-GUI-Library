# Aims
Note: This file has been started over as of V2.0.

The following will be incorporated into the OGL in future versions (in no particular order):
- [ ] A MENU class - Was a part of the beta release, but has to be rewritten from scratch, and therefore is not part of the OGL at this point. Context Menu support is also envisioned.
- [ ] CommonControl support - No CommonControl is yet supported.
- [ ] A line application property - At the moment, one can only retrieve a line. There may be a property in the future which replaces a line's contents.
- [ ] GroupBox support - You can create them, but the OGL doesn't support creating groups for those groupbox controls. This will be changed in the future.
- [ ] Better string allocation - As of the current version of the OGL, all codepoints are assumed to be 2 bytes in length, which is not always true. Moreover, string allocation may not be 100% correct within the OGL (it all *works*, but there is plenty of room for optimisation).
- [ ] Making fonts work internally - As of V2.0, fonts are somewhat handled externally i.e. through the use of GUIFONT objects. My idea is to also include support for handling with fonts internally, without having to create GUIFONT objects. One can sort of do this already (see font property in the doc), but better support may be given in a future version.

There are other items to this list, some of which have been referred to in the doc. As soon as I can relocate these items, I will add them to the list. They are only small, but are still important!

# Requests
The following were not aims of the developer, but are requests made by Free BASIC forum members.
- [ ] Making the OGL High-DPI Aware - Request posted by PaulSquires. One of the aims of 2.1.
