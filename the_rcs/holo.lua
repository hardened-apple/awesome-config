--[[                                ]]--
--                                    -
--    Holo Awesome WM 3.5.+ config    --
--     github.com/copycat-killer      --
--                                    -
--[[                                ]]--


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
beautiful.init(configdir .. "/themes/holo/theme.lua")
local vicious    = require("vicious")
local mylayouts  = require("mylayouts")
require("commonparts.commonrc")
-- }}}

-- {{{ Variable Definitions

mywiboxhgt = 32

wifi = terminal .. " -e sudo wifi-menu "
musicplr = terminal .. " -g 130x34-320+16 -e ncmpcpp -c ~/.config/ncmpcpp/config "

layouts =
{
    awful.layout.suit.floating,             -- 1
    awful.layout.suit.tile,                 -- 2
    awful.layout.suit.fair,                 -- 3
    awful.layout.suit.tile.left,            -- 4
    awful.layout.suit.tile.top,             -- 5
}
-- }}}

-- {{{ Tags

tags = {
       names = { " WEB ", " TERMINAL ", " FILES ", " OTHER " },
       layout = { layouts[1], layouts[3], layouts[2], layouts[4] }
}
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Define widgets
coldef  = "</span>"
holowhite  = "<span color='#FFFFFF'>"
blue = "<span color='#80CCE6'>"
space = "<span font='Tamsyn 3'> </span>"

local util = awful.util

-- Menu widget
awesome_icon = wibox.widget.imagebox()
awesome_icon:set_image(beautiful.awesome_icon)
awesome_icon:buttons(util.table.join( awful.button({ }, 1, function() mymainmenu:toggle() end)))

-- Clock widget
mytextclock = awful.widget.textclock(holowhite .. space .. "%H:%M<span font='Tamsyn 2'> </span>" .. coldef)
clock_icon = wibox.widget.imagebox()
clock_icon:set_image(beautiful.clock)
clockwidget = wibox.widget.background()
clockwidget:set_widget(mytextclock)
clockwidget:set_bgimage(beautiful.widget_bg)

-- Calendar widget
mytextcalendar = awful.widget.textclock(holowhite .. space .. "%A %d %B<span font='Tamsyn 5'> </span>" .. coldef)
calendar_icon = wibox.widget.imagebox()
calendar_icon:set_image(beautiful.calendar)
calendarwidget = wibox.widget.background()
calendarwidget:set_widget(mytextcalendar)
calendarwidget:set_bgimage(beautiful.widget_bg)
gen.attach_calendar(calendarwidget, "#FFFFFF", "#242424")

-- GMail widget
mygmail = wibox.widget.textbox()
gmail_t = awful.tooltip({ objects = { mygmail },})
notify_shown = false
mailcount = 0
vicious.register(mygmail, vicious.widgets.gmail, gen.mailsteam, 60)

-- Mpd widget
mpdwidget = wibox.widget.textbox()
mpd_icon = wibox.widget.imagebox()
mpd_icon:set_image(beautiful.mpd)
prev_icon = wibox.widget.imagebox()
prev_icon:set_image(beautiful.prev)
next_icon = wibox.widget.imagebox()
next_icon:set_image(beautiful.nex)
stop_icon = wibox.widget.imagebox()
stop_icon:set_image(beautiful.stop)
pause_icon = wibox.widget.imagebox()
pause_icon:set_image(beautiful.pause)
play_pause_icon = wibox.widget.imagebox()
play_pause_icon:set_image(beautiful.play)
vicious.register(mpdwidget, vicious.widgets.mpd, gen.mpdholo, 1)

musicwidget = wibox.widget.background()
musicwidget:set_widget(mpdwidget)
musicwidget:set_bgimage(beautiful.widget_bg)
musicwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
mpd_icon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
prev_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                awful.util.spawn_with_shell( "mpc prev", false )
                                                                vicious.force({ mpdwidget } )
                                                             end)))
next_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                awful.util.spawn_with_shell( "mpc next", false )
                                                                vicious.force({ mpdwidget } )
                                                             end)))
stop_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                play_pause_icon:set_image(beautiful.play)
                                                                awful.util.spawn_with_shell( "mpc stop", false )
                                                                vicious.force({ mpdwidget } )
                                                             end)))
play_pause_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                awful.util.spawn_with_shell( "mpc toggle", false )
                                                                vicious.force({ mpdwidget } )
                                                             end)))
-- /home fs widget
fshwidget = wibox.widget.textbox()
too_much = false
vicious.register(fshwidget, vicious.widgets.fs, gen.fsholo, 600)

fshsize = {margin=10, height=170, width=600}
fshwidget:connect_signal('mouse::enter', function () gen.showfs('Tamsyn 8', fshsize) end)
fshwidget:connect_signal('mouse::leave', function () gen.removefs() end)

-- Battery widget
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, gen.batnorm, 1, 'BAT0')

-- {{{ Volume widget
--
-- original version: http://awesome.naquadah.org/wiki/Rman%27s_Simple_Volume_Widget

local alsawidget =
{
    channel = "Master",
    step = "5%",
    colors =
    {
        unmute = "#80CCE6",
        mute = "#FF9F9F"
    },
    mixer = terminal .. " -e alsamixer", -- or whatever your preferred sound mixer is
    notifications =
  {
    font = "Tamsyn 12",
    bar_size = 32
  }
}

alsawidget.bar = awful.widget.progressbar ()
alsawidget.bar:set_width (80)
alsawidget.bar:set_height (10)
awful.widget.progressbar.set_ticks (alsawidget.bar, true)
alsamargin = wibox.layout.margin (alsawidget.bar, 5, 8, 80)
wibox.layout.margin.set_top (alsamargin, 12)
wibox.layout.margin.set_bottom (alsamargin, 12)
volumewidget = wibox.widget.background()
volumewidget:set_widget(alsamargin)
volumewidget:set_bgimage(beautiful.widget_bg)


alsawidget.bar:set_background_color ("#595959")
alsawidget.bar:set_color (alsawidget.colors.unmute)
alsawidget.bar:buttons (awful.util.table.join (
    awful.button ({}, 1, function()
        awful.util.spawn (alsawidget.mixer)
    end),
    awful.button ({}, 3, function()
        awful.util.spawn ("amixer sset " .. alsawidget.channel .. " toggle")
        vicious.force ({ alsawidget.bar })
    end),
    awful.button ({}, 4, function()
        awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+")
        vicious.force ({ alsawidget.bar })
    end),
    awful.button ({}, 5, function()
        awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-")
        vicious.force ({ alsawidget.bar })
    end)
))

-- tooltip
alsawidget.tooltip = awful.tooltip ({ objects = { alsawidget.bar } })

-- naughty notifications
alsawidget._current_level = 0
alsawidget._muted = false

function alsawidget:notify ()
    local preset =
    {
    --   title = "", text = "",
    timeout = 3,
        height = 40,
        width = 285,
        font = alsawidget.notifications.font,
    fg = "#EEE5E5",
    bg = "#222222"
    }

    if alsawidget._muted
  then
        preset.title = alsawidget.channel .. " - Muted"
    else
        preset.title = alsawidget.channel .. " - " .. alsawidget._current_level .. "%"
    end

  local int = math.modf (alsawidget._current_level / 100 * alsawidget.notifications.bar_size)
  preset.text = "[" .. string.rep ("|", int) .. string.rep (" ", alsawidget.notifications.bar_size - int) .. "]"

  if alsawidget._notify ~= nil
  then
        alsawidget._notify = naughty.notify (
        {
            replaces_id = alsawidget._notify.id,
            preset = preset
        })
    else
        alsawidget._notify = naughty.notify ({ preset = preset })
    end
end

-- register the widget through vicious
vicious.register (alsawidget.bar, vicious.widgets.volume, function (widget, args)
    alsawidget._current_level = args[1]
    if args[2] ~= "♩"
    then
      alsawidget._muted = false
      alsawidget.tooltip:set_text (" " .. alsawidget.channel .. ": " .. args[1] .. "% ")
      widget:set_color (alsawidget.colors.unmute)
  else
        alsawidget._muted = true
        alsawidget.tooltip:set_text (" [Muted] ")
        widget:set_color (alsawidget.colors.mute)
  end
  return args[1]
end, 5, alsawidget.channel) -- relatively high update time, use of keys/mouse will force update

-- }}}

-- CPU widget
cpu_widget = wibox.widget.textbox()
vicious.register(cpu_widget, vicious.widgets.cpu, holowhite .. space .. "CPU $1%<span font='Tamsyn 5'> </span>" .. coldef, 3)
cpuwidget = wibox.widget.background()
cpuwidget:set_widget(cpu_widget)
cpuwidget:set_bgimage(beautiful.widget_bg)
cpu_icon = wibox.widget.imagebox()
cpu_icon:set_image(beautiful.cpu)

-- Wifi widget
netdown_icon = wibox.widget.imagebox()
netdown_icon:set_image(beautiful.net_down)
netup_icon = wibox.widget.imagebox()
netup_icon:set_image(beautiful.net_up)
no_net_shown = true
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, gen.wifiholo, 3)
networkwidget = wibox.widget.background()
networkwidget:set_widget(netwidget)
networkwidget:set_bgimage(beautiful.widget_bg)
networkwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(wifi) end)))

-- Separators
first = wibox.widget.textbox('<span font="Tamsyn 4"> </span>')
last = wibox.widget.imagebox()
last:set_image(beautiful.last)
spr = wibox.widget.imagebox()
spr:set_image(beautiful.spr)
spr_small = wibox.widget.imagebox()
spr_small:set_image(beautiful.spr_small)
spr_very_small = wibox.widget.imagebox()
spr_very_small:set_image(beautiful.spr_very_small)
spr_right = wibox.widget.imagebox()
spr_right:set_image(beautiful.spr_right)
spr_bottom_right = wibox.widget.imagebox()
spr_bottom_right:set_image(beautiful.spr_bottom_right)
spr_left = wibox.widget.imagebox()
spr_left:set_image(beautiful.spr_left)
bar = wibox.widget.imagebox()
bar:set_image(beautiful.bar)
bottom_bar = wibox.widget.imagebox()
bottom_bar:set_image(beautiful.bottom_bar)

-- }}}

-- Place widgets {{{
-- Create a wibox for each screen and add it
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

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(first)
    left_layout:add(mytaglist[s])
    left_layout:add(spr_small)
    left_layout:add(mylayoutbox[s])

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mygmail)
    right_layout:add(fshwidget)
    right_layout:add(batwidget)
    right_layout:add(spr_right)
    right_layout:add(prev_icon)
    right_layout:add(next_icon)
    right_layout:add(stop_icon)
    right_layout:add(play_pause_icon)
    right_layout:add(bar)
    right_layout:add(mpd_icon)
    right_layout:add(musicwidget)
    right_layout:add(bar)
    right_layout:add(spr_very_small)
    right_layout:add(volumewidget)
    right_layout:add(spr_left)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    -- }}}
    -- Create bottom wibox {{{
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = mywiboxhgt })

    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(awesome_icon)
    bottom_left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(spr_bottom_right)
    bottom_right_layout:add(netdown_icon)
    bottom_right_layout:add(networkwidget)
    bottom_right_layout:add(netup_icon)
    bottom_right_layout:add(bottom_bar)
    bottom_right_layout:add(cpu_icon)
    bottom_right_layout:add(cpuwidget)
    bottom_right_layout:add(bottom_bar)
    bottom_right_layout:add(calendar_icon)
    bottom_right_layout:add(calendarwidget)
    bottom_right_layout:add(bottom_bar)
    bottom_right_layout:add(clock_icon)
    bottom_right_layout:add(clockwidget)
    bottom_right_layout:add(last)

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)

    -- Set proper backgrounds, instead of beautiful.bg_normal
    mywibox[s]:set_bg(beautiful.topbar_path .. screen[s].workarea.width .. ".png")
    mybottomwibox[s]:set_bg("#242424")
    -- }}}
end

-- }}}

-- {{{ Keys
extrakeys = awful.util.table.join(

    -- Move clients
    --awful.key({ altkey }, "Next",  function () awful.client.moveresize( 1,  1, -2, -2) end),
    --awful.key({ altkey }, "Prior", function () awful.client.moveresize(-1, -1,  2,  2) end),
    --awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  1,   0,   0) end),
    --awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -1,   0,   0) end),
    --awful.key({ altkey }, "Left",  function () awful.client.moveresize(-1,   0,   0,   0) end),
    --awful.key({ altkey }, "Right", function () awful.client.moveresize( 1,   0,   0,   0) end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
        mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
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
          properties = { tag = tags[1][4] } },
    { rule = { class = "Torrent-search" },
          properties = { tag = tags[1][4] } },
}
local numrulessofar = #awful.rules.rules
for k,v in pairs(baserules) do awful.rules.rules[k + numrulessofar] = v end
-- }}}

-- {{{ Signals
-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = "0"
            c.border_color = beautiful.border_normal
        else
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)

for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                    awful.client.moveresize(0, 0, 2, 2, clients[1])
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end

-- vim: set foldmethod=marker:
