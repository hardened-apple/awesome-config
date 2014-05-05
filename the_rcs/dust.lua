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
beautiful.init(configdir .. "/themes/dust/theme.lua")
local vicious    = require("vicious")
local mylayouts  = require("mylayouts")
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
    names = { "ㄡ", "ㄠ", "ㄓ", "ㄕ", "ㄈ", "ㄒ", "ハ", "ㄏ", "ㄎ" },
    layout = { layouts[1], layouts[1], layouts[1], layouts[2], layouts[1], layouts[1], layouts[7], layouts[1], layouts[7] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
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

-- MPD Widget
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd, gen.mpdnorm, 1)

-- battery widget
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, gen.batnorm, 60, 'BAT0')

-- textclock
datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, "%a: %R ", 60)
gen.attach_calendar(datewidget, beautiful.bg_normal, beautiful.fg_normal)
-- }}}

-- Place widgets {{{
-- Create a wibox for each screen and add it
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
    left_layout:add(myspacer)
    left_layout:add(mpdwidget)
    left_layout:add(myspacer)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(myspacer)
    right_layout:add(batwidget)
    right_layout:add(myspacer)
    right_layout:add(myspacer)
    right_layout:add(datewidget)
    right_layout:add(myspacer)
    right_layout:add(volwidget)
    right_layout:add(myspacer)
    right_layout:add(wifiwidget)
    right_layout:add(myspacer)
    right_layout:add(myspacer)
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

-- Keys
require("commonparts.setupglobalkeys")
root.keys(globalkeys)

-- {{{ Rules
awful.rules.rules = {
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][9], floating = true } }
}
local numrulessofar = #awful.rules.rules
for k,v in pairs(baserules) do awful.rules.rules[k + numrulessofar] = v end
-- }}}

-- {{{ Signals
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- }}}


-- vim: set foldmethod=marker:
