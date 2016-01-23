--[[
VLC Song Track Extension for VLC media player
Copyright 2015 Reiuiji

Authors: Reiuiji
Contact: reiuiji@gmail.com

Information:
Keeps track of what songs were played in VLC and saves the meta information and time played to a csv file which can be parsed by any spreadsheet application (LibreOffice Calc).

-------------------------
Installation Instructions
-------------------------

Place this file in the corresponding folder and restart vlc.

Linux: ~/.local/share/vlc/lua/extensions/

Windows and Mac OS X: lua/{playlist,meta,intf}/

--]]

-- Global Variables
FileName = "VLCSongTrack.csv"
SongTrackFile = ""
FileHeader = "Date,Time,Title,Artist,Album,Genre,Comments,Location\n"

-- Descriptor
function descriptor()
  return {
    title = "VLC Song Track 0.0.5",
    version = "0.0.5",
    author = "Reiuiji",
    url = "https://github.com/Reiuiji/VLCAddons",
    shortdesc = "VLC Song Track",
    description = "Keeps track of what songs were played in VLC and saves the meta information and time played to <UserDataDirectory>\VLCSongTrack.csv which can be parsed by any spreadsheet application (LibreOffice Calc).",
    capabilities = { "input-listener" }
  }
end

-- Activate plugin
function activate()
  vlc.msg.dbg("[VLC Song Track] -- Activate")
  init()
  update_song_track()
end

-- Deactivate Plugin
function deactivate()
  vlc.msg.dbg("[VLC Song Track] -- Deactivate")
end

-- Close Trigger
function close()
  vlc.msg.dbg("[VLC Song Track] -- Close")
end

-- Triggers
function input_changed()
  vlc.msg.dbg("[VLC Song Track] -- Input Changed")
  update_song_track()
end
function meta_changed()
  vlc.msg.dbg("[VLC Song Track] -- Meta Changed")
  update_song_track()
end

-- First time init file
function init()
  vlc.msg.dbg("[VLC Song Track] Initializing plugin")
  SongTrackFile = vlc.config.userdatadir() .. "/" .. FileName
  vlc.msg.dbg("[VLC Song Track] Song Track File: " .. SongTrackFile .. ")")
  -- Check if the file exist
  local file = io.open(SongTrackFile,"r")
  if file ~= nil then
    io.close(file)
  else
    vlc.msg.dbg("[VLC Song Track] File does not exist, Creating Header")
    local file = io.open(SongTrackFile, "w+")
    file:write(FileHeader)
    file:close()
  end
end

-- Update Track
function update_song_track()
  vlc.msg.dbg("[VLC Song Track] Update Song Track!")
  if vlc.input.is_playing() then
    local item = vlc.item or vlc.input.item()
    if item then
      local meta = item:metas()
      local uri = item:uri()
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

        --Date & Time
        local date = os.date("%d/%m/%Y")
        local time = os.date("%H:%M:%S")

        local info = date .. "," .. time .. "," .. title .. "," .. artist .. "," .. album .. "," .. genre .. "," .. description .. "," .. uri
        write_file(info)
        return true
      end
    end
  end
end

-- Write File
function write_file(info)
  vlc.msg.dbg("[VLC Song Track] Write File!")
  local file = io.open(SongTrackFile, "a")
  file:write(info .. "\n")
  file:close()
end
