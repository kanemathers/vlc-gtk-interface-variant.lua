
local window_title = "VLC media player"
local variant = "dark"

-- Need to wait a bit for VLC to initialise. It doesn't appear to set a title
-- immediately. At least, from what I can gather by attempting an `xprop` call
-- without this sleep.
os.execute("sleep 0.3")

-- First attempt is assuming VLC wasn't started with a file provided. When
-- this happens, the window title defaults to "VLC media player"
local exit_code = os.execute("xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT " .. variant .. " -name '" .. window_title .. "'")

-- If this fails, we know the title is incorrect and we assume that's a
-- result of VLC starting to play a file and the title being changed to
-- "$file - VLC media player"
if exit_code == nil then
    local item

    repeat
        item = vlc.input.item()
    until item

    local wintitle = item:name() .. " - " .. window_title

    os.execute("xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT " .. variant .. " -name '" .. wintitle .. "'")
end
