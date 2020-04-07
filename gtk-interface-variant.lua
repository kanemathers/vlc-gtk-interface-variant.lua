local default_title = "VLC media player"
local variant = "dark"

-- Lua doesn't seem to have native support for escaping shell args. At least,
-- not from what I can gather doing a quick search. This'll do.
--
-- https://docs.python.org/dev/library/shlex.html#shlex.quote
function shlex_quote(s)
    return "'" .. s:gsub("'", "'\"'\"'") .. "'"
end

function set_xprop(variant, title)
    variant = shlex_quote(variant)
    title = shlex_quote(title)

    cmd = ("xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT %s -name %s"):format(variant, title)

    return os.execute(cmd)
end

-- Need to wait a bit for VLC to initialise. It doesn't appear to set a title
-- immediately. At least, from what I can gather by attempting an `xprop` call
-- without this sleep.
os.execute("sleep 0.3")

-- First attempt is assuming VLC wasn't started with a file provided. When
-- this happens, the window title defaults to "VLC media player"
local status = set_xprop(variant, default_title)

-- If this fails, we know the title is incorrect and we assume that's a
-- result of VLC starting to play a file and the title being changed to
-- "$file - VLC media player"
if status == nil then
    local item

    repeat
        item = vlc.input.item()
    until item

    local wintitle = item:name() .. " - " .. default_title

    set_xprop(variant, wintitle)
end
