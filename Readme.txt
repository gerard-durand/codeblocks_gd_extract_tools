Two command files : extract.bat or extract.cmd. 
- extract.bat (the version I use most of the time); it calls extract.bash as a bash command file,
- extract.cmd is for Windows only (normally stricly equivallent).

These command files extract strings from all cpp, h, scripts, manifests, xrc files in several pass. They build several pot files and merge them in a big pot file to be able to share strings when they are found in several different sources.

find, sed,  gettext, grep, msgcat, rm, xargs, xgettext used here in both command files are unix/linux utilities.
You can find Windows versions of bash, find, sed ..., at least in the msys2 distribution.
As "find" also exists on Dos/Windows, but with a different syntax, the linux port must appear 
in the Windows system PATH before the Windows one:
With msys2 distribution, C:\msys64\usr\bin must be declared before C:\Windows\system32

wxrc can be built as a wxWidgets tool.

Recent 64 bits versions of these tools may be found in the folder Unix_Tools (partial copy of msys2 installation).

In your CodeBlocks source folder, you'll find a i18n subfolder at the same level than other subfolders as include, src, plugins, ...
Create a new subfolder, for example i18n_mine and put inside the command files. Don't use i18n to avoid eventually conflicts.
If necessary, put the content of Unix_Tools somewhere in your PATH: if you have msys2, they should already exist in C:\msys64\usr\bin except wxrc.exe, but this 
executable must also be accessible via the system PATH.