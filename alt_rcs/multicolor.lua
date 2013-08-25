--[[                                    ]]--
--                                        -
--   Multicolor Awesome WM 3.5.+ config   --
--       github.com/copycat-killer        --
--                                        -
--[[                                    ]]--


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
local snap       = require("myfunctions.snap")
local app_menu   = require("my_menus.app_menu")
local mylayouts  = require("mylayouts")
local gen        = require("myfunctions.general")
require("myfunctions.cal")
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
        in_error = false
    end)
end
-- }}}

-- {{{ Variable Definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(configdir .. "/themes/multicolor/theme.lua")

terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
tasks = terminal .. " -e htop "

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
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

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
tags = {
       names = { "web", "term", "docs", "media", "files", "other" },       
       layout = { layouts[1], layouts[3], layouts[4], layouts[1], layouts[7], layouts[1] } 
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
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

-- {{{ Widgets
-- Separators
spacer = wibox.widget.textbox(" ")

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

cal.attach_calendar(mytextclock, beautiful.bg_normal, beautiful.fg_normal)

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
                 end, 60)

-- MPD Widget
mpdwidget = wibox.widget.textbox()
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(theme.confdir .. "/widgets/note.png")

vicious.register(mpdwidget, vicious.widgets.mpd,
function(widget, args)
    -- play
    if (args["{state}"] == "Play") then
        return red .. args["{Title}"] .. coldef .. colwhi .. " - " .. coldef .. colwhi  .. 
        args["{Artist}"] .. coldef
    -- pause
    elseif (args["{state}"] == "Pause") then
        return red .. "mpd</span>" .. colwhi .." paused</span>"
    -- stop
    elseif (args["{state}"] == "Stop") then
        return red .. "mpd</span>" .. colwhi .." stopped</span>"
    -- not running
    else
        return red .. "mpd</span>" .. colwhi .." off</span>"
    end
    end, 1)


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
    vicious.register(fshwidget, vicious.widgets.fs,
    function (widget, args)
        if args["{/home/apple/share used_p}"] >= 95 and args["{/home/apple/share used_p}"] < 99 then
            return colwhi .. args["{/home/apple/share used_p}"] .. "%" .. coldef
        elseif args["{/home/apple/share used_p}"] >= 99 and args["{/home/apple/share used_p}"] <= 100 then
            naughty.notify({ title = "warning", text = "/share partition ran out!\nmake some room",
                             timeout = 10,
                             position = "top_right",
                             fg = beautiful.fg_urgent,
                             bg = beautiful.bg_urgent })
            return colwhi .. args["{/home/apple/share used_p}"] .. "%" .. coldef
        else
            return azure .. args["{/home/apple/share used_p}"] .. "%" .. coldef
        end
    end, 620)


fshsize = {margin=10, height=170, width=600}
fshwidget:connect_signal('mouse::enter', function () gen.add_info('Terminus', fshsize) end)
fshwidget:connect_signal('mouse::leave', function () gen.remove_info() end)

-- Battery widget
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
batwidget = wibox.widget.textbox()
vicious.register( batwidget, vicious.widgets.bat, "$2", 1, "BAT0")

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat,
function (widget, args)
  -- plugged
  if (gen.batstate() == 'Cable plugged' or gen.batstate() == 'Unknown') then
    return "AC "
    -- critical
  elseif (args[2] <= 5 and gen.batstate() == 'Discharging') then
    naughty.notify({
      text = "battery about to die...",
      title = "Urgent Battery State",
      position = "top_right",
      timeout = 1,
      fg="#000000",
      bg="#ffffff",
      screen = 1,
      ontop = true,
    })
    -- low
  elseif (args[2] <= 10 and gen.batstate() == 'Discharging') then
    naughty.notify({
      text = "battery is low",
      title = "Battery Warning",
      position = "top_right",
      timeout = 1,
      fg="#ffffff",
      bg="#262729",
      screen = 1,
      ontop = true,
    })
  end
    return " " .. args[2] .. "% "
end, 1, 'BAT0')

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
vicious.register(netdowninfo, vicious.widgets.net, green .. "${wlp5s0 down_kb}" .. coldef, 1)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
netupicon.align = "middle"
netupinfo = wibox.widget.textbox()
vicious.register(netupinfo, vicious.widgets.net, red .. "${wlp5s0 up_kb}" .. coldef, 1)

-- Memory widget
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, yellow .. "$1%" .. coldef, 1)


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

    -- Create the upper wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 }) 
    --border_width = 0, height =  20 })
        
    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(spacer)
    --left_layout:add(mylauncher)
    --left_layout:add(spacer)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    --left_layout:add(spacer)
    left_layout:add(mpdicon)
    left_layout:add(mpdwidget)
    --left_layout:add(spacer)

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(netdownicon)
    right_layout:add(netdowninfo)
    right_layout:add(spacer)
    right_layout:add(netupicon)
    right_layout:add(netupinfo)
    right_layout:add(spacer)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(spacer)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(spacer)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(fshicon)
    right_layout:add(fshwidget)
    right_layout:add(spacer)
    right_layout:add(uptimeicon)
    right_layout:add(uptimewidget) 
    right_layout:add(spacer)
    right_layout:add(weathericon)
    right_layout:add(weatherwidget)
    right_layout:add(spacer)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(spacer)
    right_layout:add(mygmailimg)
    right_layout:add(mygmail)
    right_layout:add(spacer)     
    right_layout:add(baticon)
    right_layout:add(batwidget)
    --right_layout:add(spacer)
    right_layout:add(clockicon)
    right_layout:add(mytextclock)
    --right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    
    mywibox[s]:set_widget(layout)

    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 20 })
    --mybottomwibox[s].visible = false
            
    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(spacer)
                        
    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(spacer)
    bottom_right_layout:add(mylayoutbox[s])
                                            
    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)

end

-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

    -- Move clients
    awful.key({ altkey }, "Next",  function () awful.client.moveresize( 1,  1, -2, -2) end),
    awful.key({ altkey }, "Prior", function () awful.client.moveresize(-1, -1,  2,  2) end),
    awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  1,   0,   0) end),
    awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -1,   0,   0) end),
    awful.key({ altkey }, "Left",  function () awful.client.moveresize(-1,   0,   0,   0) end),
    awful.key({ altkey }, "Right", function () awful.client.moveresize( 1,   0,   0,   0) end),
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
    awful.key({ altkey,           }, "c",     function () cal.show_calendar(5, 0) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

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
    awful.key({modkey}, "q", function(c) snap.snapwin(c, screen[c.screen], "tl") end),
    awful.key({modkey}, "e", function(c) snap.snapwin(c, screen[c.screen], "tr") end),
    awful.key({modkey}, "z", function(c) snap.snapwin(c, screen[c.screen], "bl") end),
    awful.key({modkey}, "c", function(c) snap.snapwin(c, screen[c.screen], "br") end),
    awful.key({modkey, "Control"}, "c", function(c) snap.snapwin(c, screen[c.screen], "brs") end),
    awful.key({modkey, "Control"}, "x", function(c) snap.snapwin(c, screen[c.screen], "bml") end),
    awful.key({modkey, "Control"}, "e", function(c) snap.snapwin(c, screen[c.screen], "trn") end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)
-- Add ror to globalkeys
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))

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


clientbuttons = awful.util.table.join(
    -- add the c:raise() in this function to allow raise on click
    awful.button({ }, 1, function (c) client.focus = c end), -- ; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
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
          properties = { tag = tags[1][6] } },
    { rule = { class = "Torrent-search" },
          properties = { tag = tags[1][6] } },
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
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
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
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- vim: set foldmethod=marker:
