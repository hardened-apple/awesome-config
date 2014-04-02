--[[                                ]]--
--                                    -
--    Holo Awesome WM 3.5.+ config    --
--     github.com/copycat-killer      --
--                                    -
--[[                                ]]--


-- Standard awesome library {{{
local gears           = require("gears")
local awful           = require("awful")
awful.rules           = require("awful.rules")
require("awful.autofocus")
local wibox           = require("wibox")
local beautiful       = require("beautiful")
local naughty         = require("naughty")
local menubar         = require("menubar")
-- }}}
-- Extra {{{
-- Define some paths
configdir        = awful.util.getdir("config")
scriptdir        = configdir .. "/scripts/"
local ror        = require("myfunctions.aweror")
local vicious    = require("vicious")
local app_menu   = require("my_menus.app_menu")
local mylayouts  = require("mylayouts")
local gen        = require("myfunctions.general")
-- }}}

-- {{{ Error Handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        local in_error = false
    end)
end
-- }}}

-- {{{ Variable Definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(configdir .. "/themes/holo/theme.lua")

mywiboxhgt = 32
terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "gvim"
wifi = terminal .. " -e sudo wifi-menu "
musicplr = terminal .. " -g 130x34-320+16 -e ncmpcpp -c ~/.config/ncmpcpp/config "

modkey = "Mod4"
altkey = "Mod1"

layouts =
{
    awful.layout.suit.floating,             -- 1
    awful.layout.suit.tile,                 -- 2
    awful.layout.suit.fair,                 -- 3
    awful.layout.suit.tile.left,            -- 4
    awful.layout.suit.tile.top,             -- 5
}
-- }}}

-- {{{ Wallpaper

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

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

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

-- Add menu in here
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Firefox", "/usr/bin/firefox" },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
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

-- {{{ Layout

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
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

    -- Create the wibox
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

    -- Create the bottom wibox
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
end

-- }}}

-- {{{ Mouse Bindings

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings
-- {{{ Global Keys
globalkeys = awful.util.table.join(

    -- Capture a screenshot
    awful.key({ altkey }, "p", function() awful.util.spawn("screenshot", false) end),

    -- Move clients
    --awful.key({ altkey }, "Next",  function () awful.client.moveresize( 1,  1, -2, -2) end),
    --awful.key({ altkey }, "Prior", function () awful.client.moveresize(-1, -1,  2,  2) end),
    --awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  1,   0,   0) end),
    --awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -1,   0,   0) end),
    --awful.key({ altkey }, "Left",  function () awful.client.moveresize(-1,   0,   0,   0) end),
    --awful.key({ altkey }, "Right", function () awful.client.moveresize( 1,   0,   0,   0) end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),

    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey,           }, "h",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey,           }, "l",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
        mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "=",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "-",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "-",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "=",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "-",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "=",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Calendar pop-up
    awful.key({ altkey,           }, "c",     function () gen.show_calendar(5, 0) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    awful.key({altkey}, "t",
              function()
                  awful.prompt.run({ prompt = "Change theme: " },
                                    mypromptbox[mouse.screen].widget,
                                    function(mytext)
                                        gen.change_theme(scriptdir, mytext)
                                    end)
              end)
)
-- Add ror to globalkeys
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))
--}}}
--{{{ Clientkeys
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    -- Adding snap-to keybindings
    awful.key({modkey}, "q", function(c) gen.snap(c, screen[c.screen], "tl", mywiboxhgt) end),
    awful.key({modkey}, "e", function(c) gen.snap(c, screen[c.screen], "tr", mywiboxhgt) end),
    awful.key({modkey}, "z", function(c) gen.snap(c, screen[c.screen], "bl", mywiboxhgt) end),
    awful.key({modkey}, "c", function(c) gen.snap(c, screen[c.screen], "br", mywiboxhgt) end),
    awful.key({modkey, "Control"}, "c", function(c) gen.resize(c, screen[c.screen], "small") end),
    awful.key({modkey, "Control"}, "x", function(c) gen.resize(c, screen[c.screen], "long") end),
    awful.key({modkey, "Control"}, "e", function(c) gen.resize(c, screen[c.screen], "normal") end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)
-- }}}
-- {{{ Tag motions
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end
-- }}}
-- {{{ set rootkeys, define client buttons
clientbuttons = awful.util.table.join(
    -- add the c:raise() in this function to allow raise on click
    awful.button({ }, 1, function (c) client.focus = c end), -- ; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
-- }}}

-- {{{ Rules

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     opacity = 1,
                     size_hints_honor = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1], floating = true } },
    { rule = { class = "VirtualBox" },
      properties = { floating = true } },
    { rule = { class = "Xmessage" },
      properties = { floating = true } },
    { rule = { class = "Tk" },
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "XTerm" },
      properties = { opacity = 0.6 } },
    { rule = { class = "Zathura" },
        properties = { tag = tags[1][3] } },
    { rule = { class = "Rtorrent" },
          properties = { tag = tags[1][4] } },
    { rule = { class = "Torrent-search" },
          properties = { tag = tags[1][4] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if c.class == "feh" or titlebars_enabled and (c.type == "normal" or c.type == "dialog") then

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        -- buttons for the titlebar
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

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
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}

-- {{{ Arrange signal handler

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
