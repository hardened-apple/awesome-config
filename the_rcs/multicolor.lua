--[[                                    ]]--
--                                        -
--   Multicolor Awesome WM 3.5.+ config   --
--       github.com/copycat-killer        --
--                                        -
--[[                                    ]]--


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
beautiful.init(configdir .. "/themes/multicolor/theme.lua")
local vicious    = require("vicious")
local mylayouts  = require("mylayouts")
require("commonparts.commonrc")
-- }}}

-- {{{ Variable Definitions

mywiboxhgt = 20

tasks = terminal .. " -e htop "

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
    --awful.layout.suit.max.fullscreen,     -- 11
    --awful.layout.suit.magnifier           -- 12
}
-- }}}

-- {{{ Tags

tags = {
       names = { "web", "term", "docs", "media", "files", "other" },
       layout = { layouts[1], layouts[3], layouts[4], layouts[1], layouts[7], layouts[1] }
}
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Define widgets
myspacer = wibox.widget.textbox(' ')

-- Colours
coldef  = "</span>"
colwhi  = "<span color='#b2b2b2'>"
colbwhi = "<span color='#ffffff'>"
blue = "<span color='#7493d2'>"
yellow = "<span color='#e0da37'>"
purple = "<span color='#e33a6e'>"
lightpurple = "<span color='#eca4c4'>"
azure = "<span color='#80d9d8'>"
green = "<span color='#87af5f'>"
lightgreen = "<span color='#62b786'>"
red = "<span color='#e54c62'>"
orange = "<span color='#ff7100'>"
brown = "<span color='#db842f'>"
fuchsia = "<span color='#800080'>"
gold = "<span color='#e7b400'>"

-- Textclock widget
clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.widget_clock)
mytextclock = awful.widget.textclock("<span color='#7788af'>%A %d %B</span> " .. blue .. "</span><span color=\"#343639\">></span> <span color='#de5e1e'>%H:%M</span> ")

gen.attach_calendar(mytextclock, beautiful.bg_normal, beautiful.fg_normal)

-- Vicious weather widget
weathericon = wibox.widget.imagebox()
weathericon:set_image(theme.confdir .. "/widgets/dish.png")
weatherwidget = wibox.widget.textbox()
vicious.register(weatherwidget, vicious.widgets.weather,
    function (widget, args)
        if args["{tempf}"] == "N/A" then
            return "No Info"
        else
            return "" .. lightpurple .. args["{sky}"] .. " @ " .. args["{tempc}"] .. "°C" .. coldef .. ""
        end
    end, 1800, "EGCC" )

-- Mail widget
mygmail = wibox.widget.textbox()
gmail_t = awful.tooltip({ objects = { mygmail },})
mygmailimg = wibox.widget.imagebox(beautiful.widget_gmail)
vicious.register(mygmail, vicious.widgets.gmail,
                function (widget, args)
                    gmail_t:set_text(args["{subject}"])
                    gmail_t:add_to_object(mygmailimg)
                    return args["{count}"]
                 end, 120)

-- MPD Widget
mpdwidget = wibox.widget.textbox()
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(theme.confdir .. "/widgets/note.png")
vicious.register(mpdwidget, vicious.widgets.mpd, gen.mpdcol, 1)


-- Uptime
uptimeicon = wibox.widget.imagebox()
uptimeicon:set_image(beautiful.widget_uptime)
uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, brown .. "$2.$3" .. coldef)

-- CPU widget
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, purple .. "$1%" .. coldef, 3)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))

-- Temp widget
tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e sudo powertop ", false) end)
    ))
   tempwidget = wibox.widget.textbox()
   vicious.register(tempwidget, vicious.widgets.thermal, "<span color=\"#f1af5f\">$1°C</span>", 9, {"coretemp.0", "core"} )

-- /home fs widget
fshicon = wibox.widget.imagebox()
fshicon:set_image(theme.confdir .. "/widgets/fs.png")
fshwidget = wibox.widget.textbox()
vicious.register(fshwidget, vicious.widgets.fs, gen.fscol, 620)


fshsize = {margin=10, height=170, width=600}
fshwidget:connect_signal('mouse::enter', function () gen.showfs('Terminus', fshsize) end)
fshwidget:connect_signal('mouse::leave', function () gen.removefs() end)

-- Battery widget
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
batwidget = wibox.widget.textbox()
vicious.register( batwidget, vicious.widgets.bat, "$2", 1, "BAT0")

-- battery widget
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, gen.batnorm, 60, 'BAT0')

-- Volume widget
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, blue .. "$1%" .. coldef,  1, "Master")

-- Net widget
netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netdownicon.align = "middle"
netdowninfo = wibox.widget.textbox()
vicious.register(netdowninfo, vicious.widgets.net, green .. "${" .. wcard .. " down_kb}" .. coldef, 1)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
netupicon.align = "middle"
netupinfo = wibox.widget.textbox()
vicious.register(netupinfo, vicious.widgets.net, red .. "${" .. wcard .. " up_kb}" .. coldef, 1)

-- Memory widget
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, yellow .. "$1%" .. coldef, 1)


-- }}}

-- Place widgets {{{
mywibox = {}
mybottomwibox = {}
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
    -- Create upper wibox {{{
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = mywiboxhgt })
    --border_width = 0, height =  20 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(myspacer)
    --left_layout:add(mylauncher)
    --left_layout:add(myspacer)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    --left_layout:add(myspacer)
    left_layout:add(mpdicon)
    left_layout:add(mpdwidget)
    --left_layout:add(myspacer)

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(netdownicon)
    right_layout:add(netdowninfo)
    right_layout:add(myspacer)
    right_layout:add(netupicon)
    right_layout:add(netupinfo)
    right_layout:add(myspacer)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(myspacer)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(myspacer)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(myspacer)
    right_layout:add(fshicon)
    right_layout:add(fshwidget)
    right_layout:add(myspacer)
    right_layout:add(uptimeicon)
    right_layout:add(uptimewidget)
    right_layout:add(myspacer)
    right_layout:add(weathericon)
    right_layout:add(weatherwidget)
    right_layout:add(myspacer)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(myspacer)
    right_layout:add(mygmailimg)
    right_layout:add(mygmail)
    right_layout:add(myspacer)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    --right_layout:add(myspacer)
    right_layout:add(clockicon)
    right_layout:add(mytextclock)
    --right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    -- }}}
    -- Create bottom wibox {{{
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = mywiboxhgt })
    --mybottomwibox[s].visible = false

    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(myspacer)

    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(myspacer)
    bottom_right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)
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
      properties = { tag = tags[1][1], floating = true } },
    { rule = { class = "Zathura" },
        properties = { tag = tags[1][3] } },
    { rule = { class = "Rtorrent" },
          properties = { tag = tags[1][6] } },
    { rule = { class = "Torrent-search" },
          properties = { tag = tags[1][6] } }
}
local numrulessofar = #awful.rules.rules
for k,v in pairs(baserules) do awful.rules.rules[k + numrulessofar] = v end
-- }}}

-- {{{ Signals
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- }}}


-- vim: set foldmethod=marker:
