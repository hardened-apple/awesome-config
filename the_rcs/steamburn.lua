--[[                                     ]]--
--                                         -
--    Steamburn Awesome WM 3.5.+ config    --
--        github.com/copycat-killer        --
--                                         -
--[[                                     ]]--


-- Standard awesome library {{{
local awful           = require("awful")
awful.rules           = require("awful.rules")
require("awful.autofocus")
local wibox           = require("wibox")
local beautiful       = require("beautiful")
-- }}}
-- Extra {{{
-- Define some paths
configdir        = awful.util.getdir("config")
scriptdir        = configdir .. "/scripts/"
beautiful.init(configdir .. "/themes/steamburn/theme.lua")
local vicious    = require("vicious")
local mylayouts  = require("mylayouts")
require("commonparts.commonrc")
-- }}}

-- {{{ Variable Definitions

mywiboxhgt = 18

wifi = terminal .. " -e sudo wifi-menu "
musicplr = terminal .. " -g 78x22 -e ncmpcpp"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,             -- 1
    awful.layout.suit.tile,                 -- 2
    awful.layout.suit.tile.left,            -- 3
    awful.layout.suit.tile.bottom,          -- 4
    awful.layout.suit.tile.top,             -- 5
    awful.layout.suit.fair,                 -- 6
    awful.layout.suit.fair.horizontal,      -- 7
    awful.layout.suit.spiral,               -- 8
    awful.layout.suit.spiral.dwindle,       -- 9
    awful.layout.suit.max,                  -- 10
    mylayouts.tilegaps,                     -- 11
}
-- }}}

-- {{{ Tags
tags = {
       names = { "web", "term", "docs", "media", "down"},
       layout = { layouts[1], layouts[3], layouts[4], layouts[1], layouts[7] }
}
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Define widgets
-- Separators
spr = wibox.widget.textbox(' ')
leftbr = wibox.widget.textbox(' [')
rightbr = wibox.widget.textbox('] ')

-- Colours
coldef  = "</span>"
white  = "<span color='#cdcdcd'>"
gray = "<span color='#94928f'>"

-- Textclock widget
mytextclock = awful.widget.textclock(white .. "%H:%M"  .. coldef)
gen.attach_calendar(mytextclock, beautiful.bg_normal, beautiful.fg_normal)

-- Mail widget
mygmail = wibox.widget.textbox()
notify_shown = false
vicious.register(mygmail, vicious.widgets.gmail, gen.mailsteam, 120)

-- Mpd widget
mpdwidget = wibox.widget.textbox()
mpdwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
vicious.register(mpdwidget, vicious.widgets.mpd, gen.mpdsteam, 1)

-- MEM widget
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, gray .. "Mem " .. coldef .. white .. "$1 " .. coldef, 13) -- in Megabytes

-- CPU widget
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, gray .. "Cpu " .. coldef .. white .. "$1 " .. coldef, 3)

-- Temp widget
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, gray .. "Temp " .. coldef .. white .. "$1 " .. coldef, 9, {"coretemp.0", "core"} )

-- /home fs widget
fshwidget = wibox.widget.textbox()
vicious.register(fshwidget, vicious.widgets.fs, gen.fssteam, 600)

fshsize = {margin=10, height=180, width=700}
fshwidget:connect_signal('mouse::enter', function () gen.showfs('Tamsyn', fshsize) end)
fshwidget:connect_signal('mouse::leave', function () gen.removefs() end)

-- Battery widget
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, gen.batnorm, 1, 'BAT0')

-- Volume widget
volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, gen.volsteam, 1, "Master")

-- Net widget
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, gray .. "Net " .. coldef .. white .. "${" .. wcard .. " down_kb} " .. "<span font=\"Terminus 8\">↓↑ </span>" .. "${" .. wcard .. " up_kb} " .. coldef, 3)
netwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(wifi) end)))


-- }}}

-- Place widgets {{{
mywibox = {}
mypromptbox = {}
mylayoutbox = {}

for s = 1, screen.count() do
    -- Set up Buttons {{{
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    -- }}}
    -- Create wibox {{{
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = mywiboxhgt })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    left_layout:add(leftbr)
    left_layout:add(mylayoutbox[s])
    left_layout:add(rightbr)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spr)
    right_layout:add(mpdwidget)
    right_layout:add(spr)
    right_layout:add(mygmail)
    right_layout:add(spr)
    right_layout:add(cpuwidget)
    right_layout:add(spr)
    right_layout:add(memwidget)
    right_layout:add(spr)
    right_layout:add(tempwidget)
    right_layout:add(spr)
    right_layout:add(fshwidget)
    right_layout:add(spr)
    right_layout:add(batwidget)
    right_layout:add(spr)
    right_layout:add(netwidget)
    right_layout:add(spr)
    right_layout:add(volumewidget)
    right_layout:add(spr)
    right_layout:add(mytextclock)
    right_layout:add(spr)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    -- }}}
end
-- }}}

-- {{{ Keys
extrakeys = awful.util.table.join(

    -- Move clients
    awful.key({ altkey }, "Next",  function () awful.client.moveresize( 1,  1, -2, -2) end),
    awful.key({ altkey }, "Prior", function () awful.client.moveresize(-1, -1,  2,  2) end),
    -- awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  1,   0,   0) end),
    -- awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -1,   0,   0) end),
    -- awful.key({ altkey }, "Left",  function () awful.client.moveresize(-1,   0,   0,   0) end),
    -- awful.key({ altkey }, "Right", function () awful.client.moveresize( 1,   0,   0,   0) end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end)
)

require("commonparts.setupglobalkeys")
globalkeys = awful.util.table.join(globalkeys, extrakeys)
root.keys(globalkeys)
--}}}

-- {{{ Rules
awful.rules.rules = {
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1], floating = true } }
}
local numrulessofar = #awful.rules.rules
for k,v in pairs(baserules) do awful.rules.rules[k + numrulessofar] = v end
-- }}}

-- {{{ Signals
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- }}}


-- vim: set foldmethod=marker:
