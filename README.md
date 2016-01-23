# VLCAddons
Collection of Various Addons/Extensions created for VLC

## VLC SONG TRACKER
----------------
[VLC-Song-Tracker.lua](VLC-Song-Tracker.lua)

VLC Song Tracker is a extension that will help keep track of which songs were played in VLC.

The information of each song will be saved to a CSV ("Comma Separated Values") file with the following data. The date and time in which the song was played as well as the song information including Title, Artist, Album, Genre, Comments, and the location in which it was played at. The location can be a url for internet radio or the file where it was played from. The CSV will will be able to be parsed by most applications. One example of parsing is a spreadsheet application (LibreOffice Calc).

### Installation Instructions:
Place this file in the corresponding folder and restart vlc or reload plugin extensions.

Linux:
* Current User: ~/.local/share/vlc/lua/extensions/
* All Users: /usr/lib/vlc/lua/extensions/

Windows:
* Current User: %APPDATA%\vlc\lua\extensions
* All Users: %ProgramFiles%\VideoLAN\VLC\lua\extensions\

Mac OS X:
* Current User: /Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/extensions/
* All Users: /Applications/VLC.app/Contents/MacOS/share/lua/extensions/

### Song List Location:
The SongList.csv will be saved in the vlc user director which can be found in the following places:
* Linux: ~/.local/share/vlc/SongList.csv
* Windows: %APPDATA%\vlc\SongList.csv
* Mac OS X: /Users/%your_name%/Library/Application Support/org.videolan.vlc/SongList.csv

-----
GPL License

© Reiuiji - 2016 All Rights reserved
