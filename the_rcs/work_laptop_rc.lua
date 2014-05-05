-- Standard awesome library {{{
local awful           = require("awful")
awful.rules           = require("awful.rules")
require("awful.autofocus")
local wibox           = require("wibox")
local beautiful       = require("beautiful")
-- }}}
-- Extra {{{
-- Define some paths
configdir       = awful.util.getdir("config")
scriptdir       = configdir .. "/scripts/"
beautiful.init(configdir .. "/themes/personal/theme.lua")
local vicious   = require("vicious")
local mylayouts = require("mylayouts")
local mywidgets = require("mywidgets")
require("commonparts.commonrc")
-- }}}

-- {{{ Variable Definitions

mywiboxhgt = 15

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.fair,
    mylayouts.threep,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Tags
tags = {
    -- names = { "ㄡ", "ㄠ", "ㄓ", "ㄕ", "ㄈ", "ㄒ", "〇", "ㄛ", "ㄎ" },
    names = { "ㄡ", "ㄠ", "ㄓ", "ㄕ", "ㄈ", "ㄒ", "ハ", "ㄏ", "ㄎ" },
    layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[7] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag( tags.names, s, tags.layout)
end
-- }}}

-- {{{ Define widgets
myspacer = wibox.widget.textbox(' ')

-- Wifi widget - just tell me if the wifi is up
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi, gen.wifinorm, 10, wcard)

-- volume widget
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, gen.volnorm, 1, "Master")

-- mpd widget, what song is playing
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd, gen.mpdnorm, 1)


-- cpu graph widget
cpuwidget = awful.widget.graph()
cpuwidget:set_width(50)
cpuwidget:set_background_color("#222222")
cpuwidget:set_color({type="linear", from={0, 0}, to={10, 0}, stops={ {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96"} }})
vicious.register(cpuwidget, vicious.widgets.cpu, "$1")


-- ram revgraph widget
ramwidget = mywidgets.revgraph()
ramwidget:set_width(50)
ramwidget:set_background_color("#222222")
ramwidget:set_color({type="linear", from={0, 0}, to={45, 0}, stops={ {0, "#AECF96"}, {8, "#AECF96"}, {9.2, "#00FF00"}, {10, "#FF5656"}} })
vicious.register(ramwidget, vicious.widgets.mem, "$1")

-- battery widget
batwidget = awful.widget.progressbar()
batwidget:set_width(100)
batwidget:set_height(3)
batwidget:set_vertical(false)
batwidget:set_background_color('#000000')
batwidget:set_border_color(nil)
batwidget:set_color("#00bfff")
vicious.register(batwidget, vicious.widgets.bat, gen.batbar, 30, "BAT0")


-- textclock
mytextclock = awful.widget.textclock()
gen.attach_calendar(mytextclock, beautiful.bg_normal, beautiful.fg_normal)
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
    -- Create the wibox {{{
    mywibox[s] = awful.wibox({ position = "top", height = mywiboxhgt, screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(cpuwidget)
    left_layout:add(myspacer)
    left_layout:add(mpdwidget)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(myspacer)
    right_layout:add(ramwidget)
    right_layout:add(myspacer)
    right_layout:add(batwidget)
    right_layout:add(myspacer)
    right_layout:add(volwidget)
    right_layout:add(myspacer)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

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
require("commonparts.setupglobalkeys")
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][9], floating = true } },
    { rule = { name = "Mendeley Desktop" },
      properties = { floating = true } },
}
local numrulessofar = #awful.rules.rules
for k,v in pairs(baserules) do awful.rules.rules[k + numrulessofar] = v end
-- }}}

-- {{{ Signals
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- }}}


-- vim: set foldmethod=marker filetype=lua:
