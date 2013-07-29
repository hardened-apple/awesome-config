-- Standard awesome library {{{
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- }}}
-- Extra {{{
-- Define some paths
config        = awful.util.getdir("config")
-- themedir      = config .. "/themes/personal"
local ror = require("myfunctions.aweror")
local vicious = require("vicious")
local snap = require("myfunctions.snap")
local app_menu = require("my_menus.app_menu")
local mylayouts = require("mylayouts")
-- local mywidgets = require("mywidgets")
-- }}}

-- {{{ Error handling
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

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/dust/theme.lua")
-- beautiful.init(awful.util.getdir("config") .. "/themes/dust/theme.lua")


-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- awful.util.spawn("xmodmap /home/matthew/.awesome_xmodmap")
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.fair,
    mylayouts.threep,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
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
-- Define a tag table which hold all screen tags.
-- can change this to make each tag layout different
tags = {
    -- names = { "ㄡ", "ㄠ", "ㄓ", "ㄕ", "ㄈ", "ㄒ", "〇", "ㄛ", "ㄎ" },
    names = { "ㄡ", "ㄠ", "ㄓ", "ㄕ", "ㄈ", "ㄒ", "ハ", "ㄏ", "ㄎ" },
    layout = { layouts[1], layouts[1], layouts[1], layouts[2], layouts[1], layouts[1], layouts[7], layouts[1], layouts[7] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag( tags.names, s, tags.layout)
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
                                    -- { "Applications", app_menu.menu.Applications, beautiful.app_menu_icon },
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
-- {{{ Define widgets
myspacer = wibox.widget.textbox()
myspacer:set_text(' ')
-- myseparator = wibox.widget.textbox()
-- myseparator:set_text(" - ")

-- Wifi widget - just tell me if the wifi is up
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi,
    function(widget, args)
        if args["{sign}"] == 0 then
            return "✗"
        else
            return "✓"
        end
    end, 10, "wlp5s0")

-- volume widget
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume,
    function(widget, args)
        return ' ' .. args[2] .. ':' .. args[1] .. ' '
    end, 1, "Master")

-- mpd widget, what song is playing
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (mpdwidget, args)
        if args["{state}"] == "Stop" then
            return "  "
        else
            -- return args["{Artist}"]..' - '.. args["{Title}"]
            return ' ' .. args["{Title}"] .. ' '
        end
    end, 1)


-- cpuwidget = awful.widget.graph()
-- cpuwidget:set_width(50)
-- cpuwidget:set_background_color("#222222")
-- cpuwidget:set_color({type="linear", from={0, 0}, to={10, 0}, stops={ {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96"}} })
-- vicious.register(cpuwidget, vicious.widgets.cpu, "$1")

-- Main thing to change is the order that the revgraph widget puts new values
-- on the graph when starting up - my current way of reversing the graph is a
-- little silly
-- ramwidget = mywidgets.revgraph()
-- ramwidget:set_width(50)
-- ramwidget:set_background_color("#222222")
-- ramwidget:set_color({type="linear", from={0, 0}, to={45, 0}, stops={ {0, "#AECF96"}, {8, "#AECF96"}, {9.2, "#00FF00"}, {10, "#FF5656"}} })
-- vicious.register(ramwidget, vicious.widgets.mem, "$1")

-- Remember I've modified the vicious widget slightly.
-- It now reads the charge_full_design file instead of charge_full
-- And returns the percent used, not percent remaining
batwidget = awful.widget.progressbar()
function battest()
    local val_f = io.open('/sys/class/power_supply/BAT0/status', 'r')
    local val = val_f:read()
    val_f:close()
    for line in io.lines('/sys/class/power_supply/BAT0/status') do
        val = line
    end
    if val == 'Discharging' then
        batwidget:set_width(100)
        batwidget:set_height(7)
        batwidget:set_vertical(false)
    else
        batwidget:set_width(0)
        batwidget:set_height(0)
    end
end
batwidget:set_background_color('#000000')
batwidget:set_border_color(nil)
batwidget:set_color("#00bfff")
vicious.register(batwidget, vicious.widgets.bat, "$2", 60, "BAT0")
battest()
battimer = timer{timeout = 2}
battimer:connect_signal("timeout", function() battest() end)
battimer:start()

datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, "%a: %R ", 60)

-- mytextclock = awful.widget.textclock()
-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
-- Buttons {{{
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
    -- }}}

    -- Create the wibox {{{
    mywibox[s] = awful.wibox({ position = "top", height = "15", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    -- left_layout:add(cpuwidget)
    left_layout:add(myspacer)
    left_layout:add(mpdwidget)
    left_layout:add(myspacer)
    -- left_layout:add(batwidget)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(myspacer)
    right_layout:add(batwidget)
    right_layout:add(myspacer)
    -- right_layout:add(ramwidget)
    -- right_layout:add(myspacer)
    right_layout:add(datewidget)
    right_layout:add(myspacer)
    right_layout:add(volwidget)
    right_layout:add(myspacer)
    right_layout:add(wifiwidget)
    right_layout:add(myspacer)
    right_layout:add(myspacer)
    -- right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])
    --right_layout:add(smallcross)
    --right_layout:add(mycross)
    --right_layout:add(date)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}
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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            -- Change below to ...( 1) for original manner
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            -- Change below to ...(-1) for original way
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

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

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

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
    awful.key({modkey, "Control"}, "e", function(c) snap.snapwin(c, screen[c.screen], "tln") end),
    -- Adding transparancy control
    -- awful.key({ modkey }, "Next", function(c)
        -- awful.util.spawn("transset-df --actual --dec 0.1") end),
    -- awful.key({ modkey }, "Prior", function(c)
        -- awful.util.spawn("transset-df --actual --inc 0.1") end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)
--
-- Add ror to globalkeys
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
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
    awful.button({ }, 1, function (c) client.focus = c end), -- ; c:raise() end),
    -- add the c:raise() in above function to allow raise on click
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
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 9 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][9], floating = true } },
    -- Set Xmessage windows to always float
    { rule = { class = "Xmessage" },
      properties = { floating = true } },
    -- Set tk interfaces to float and have the menubar
    { rule = { class = "Tk" },
      properties = { floating = true } }, 
    -- { rule = { name = "Figure 1" },
      -- properties = { floating = true } },
  -- make feh floating
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "XTerm" },
      properties = { opacity = 0.6 } },
    -- Rox - floating, titlebar added in manage signal (below)
    -- { rule = { class = "ROX-Filer" },
      -- properties = { floating = true } },
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


-- Changes below are things I've added
-- Note: If you want to run a shell command, or a command using redirection
--      use     awful.util.spawn_with_shell("<command>")


-- Setting the font
-- awesome.font = 

-- vim: set foldmethod=marker:
