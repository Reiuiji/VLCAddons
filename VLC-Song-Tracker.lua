--[[
VLC Song Tracker Extension for VLC media player
Copyright 2016 Reiuiji

Authors: Reiuiji
Contact: reiuiji@gmail.com

Information:
Keeps track of which songs were played in VLC and saves the song information as well as the time played to a csv file which can be parsed by any spreadsheet application (LibreOffice Calc).

-------------------------
Installation Instructions
-------------------------

Place this file in the corresponding folder and restart vlc or reload plugin extensions.

Linux:
  Current User: ~/.local/share/vlc/lua/extensions/
     All Users: /usr/lib/vlc/lua/extensions/

Windows:
  Current User: %APPDATA%\vlc\lua\extensions
     All Users: %ProgramFiles%\VideoLAN\VLC\lua\extensions\

Mac OS X:
  Current User: /Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/extensions/
     All Users: /Applications/VLC.app/Contents/MacOS/share/lua/extensions/

The SongList.csv will be saved in the vlc user director which can be found in the following places
    Linux: ~/.local/share/vlc/SongList.csv
  Windows: %APPDATA%\vlc\SongList.csv
 Mac OS X: /Users/%your_name%/Library/Application Support/org.videolan.vlc/SongList.csv

--]]

-- Global Variables
-- Name of the file to save the songs
FileName = "SongList.csv"
SongTrackerFile = ""
-- Default header for the csv file
FileHeader = "Date,Time,Title,Artist,Album,Genre,Comments,Location\n"
-- CSV field separator
CSV_FS = ","--"|"

-- Descriptor
function descriptor()
  return {
    title = "VLC Song Tracker 0.1.2",
    version = "0.1.2",
    author = "Reiuiji",
    url = "https://github.com/Reiuiji/VLCAddons",
    shortdesc = "VLC Song Tracker",
    description = "Keeps track of what songs were played in VLC and saves the meta information and time played to SongList.csv which can be parsed by any spreadsheet application (LibreOffice Calc).",
    capabilities = { "input-listener" }
  }
end

-- Activate plugin
function activate()
  vlc.msg.dbg("[VLC Song Tracker] Activate")
  init()
  update_song_Tracker()
end

-- Deactivate Plugin
function deactivate()
  vlc.msg.dbg("[VLC Song Tracker] Deactivate")
end

-- Close Trigger
function close()
  vlc.msg.dbg("[VLC Song Tracker] Close")
end

-- Triggers
function input_changed()
  vlc.msg.dbg("[VLC Song Tracker] Input Changed")
  update_song_Tracker()
end
function meta_changed()
  vlc.msg.dbg("[VLC Song Tracker] Meta Changed")
  update_song_Tracker()
end

-- First time init file
function init()
  vlc.msg.dbg("[VLC Song Tracker] Initializing plugin")
  local slash = "/"
  --Determine which operating system
  if string.match(vlc.config.datadir(), "^(%a:.+)$") then --Windows Detected
    vlc.msg.dbg("[VLC Song Tracker] OS Detected: Windows")
    slash = "\\"
  elseif string.find(vlc.config.datadir(), 'MacOS') then -- Mac Detected
    vlc.msg.dbg("[VLC Song Tracker] OS Detected: Mac OS X")
    slash = "/"
  else -- Linux/UNIX
    vlc.msg.dbg("[VLC Song Tracker] OS Detected: Linux/Unix")
    slash = "/"
  end
  
  SongTrackerFile = vlc.config.userdatadir() .. slash .. FileName
  vlc.msg.dbg("[VLC Song Tracker] Song Tracker File: " .. SongTrackerFile .. ")")
  -- Check if the file exist
  local file = io.open(SongTrackerFile,"r")
  if file ~= nil then
    io.close(file)
  else
    vlc.msg.dbg("[VLC Song Tracker] File does not exist, Creating Header")
    local file = io.open(SongTrackerFile, "w+")
    file:write(FileHeader)
    file:close()
  end
end

-- Update Tracker
function update_song_Tracker()
  vlc.msg.dbg("[VLC Song Tracker] Update Song Tracker!")
  if vlc.input.is_playing() then
    local item = vlc.item or vlc.input.item()
    if item then
      local meta = item:metas()
      --Check Meta tags
      if meta then
        --Title
        local title = meta["title"]
        if title == nil then
          title = ""
        end

        --Artist
        local artist = meta["artist"]
        if artist == nil then
          artist = ""
        end

        --Album
        local album = meta["album"]
        if album == nil then
          album = ""
        end

        --Genre
        local genre = meta["genre"]
        if genre == nil then
          genre = ""
        end

        --Description
        local description = meta["description"]
        if description == nil then
          description = ""
        end
        --Clean up Description: Remove new lines (\n) and puts two spaces instead
        description = string.gsub(description, "\n", "  ")

        --Date & Time
        local date = os.date("%d/%m/%Y")
        local time = os.date("%H:%M:%S")

        -- uri information
        local uri = item:uri()

        local info = date .. CSV_FS .. time .. CSV_FS .. title .. CSV_FS .. artist .. CSV_FS .. album .. CSV_FS .. genre .. CSV_FS .. description .. CSV_FS .. uri
        write_file(info)
        return true
      end
    end
  end
end

-- Write File
function write_file(info)
  vlc.msg.dbg("[VLC Song Tracker] Write File!")
  local file = io.open(SongTrackerFile, "a")
  file:write(info .. "\n")
  file:close()
end
