-- Standard awesome library {{{
local gears           = require("gears")
local awful           = require("awful")
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
-- shifty - dynamic tagging library
local shifty = require("shifty")
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
beautiful.init(configdir .. "/themes/personal/theme.lua")


-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.fair,
    mylayouts.revthreep,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- Shifty configured tags. {{{
shifty.config.tags = {
    w1 = {
        layout    = awful.layout.suit.max,
        mwfact    = 0.60,  -- master window size (tiling master V slave)
        exclusive = false, -- allow apps not specified? (true - like subtle)
        position  = 1,     -- Super+<N> opens this ( here N==1)
        init      = true,  -- create tag at startup, be persistant
        screen    = 1,     -- only have this tag on screen 1
        slave     = true,
    },
    play = {
        layout    = revthreep,
        exclusive = false,
        position  = 2,
        init      = true,
    },
    python = {
        layout    = awful.layout.suit.fair.horizontal,
        spawn     = "xterm -e ipython",
        position  = 3,
        -- init      = true,
        -- persist   = true,
    },
    mail = {
        layout    = awful.layout.suit.tile,
        mwfact    = 0.55,
        exclusive = false,
        position  = 5,
        spawn     = mail,
        slave     = true
    },
    media = {
        layout    = awful.layout.suit.floating,
        exclusive = false,
        position  = 7,
    },
    web = {
        layout      = awful.layout.suit.floating,
        -- mwfact      = 0.65,
        exclusive   = true, -- only firefox etc allowed
        max_clients = 4,    -- maximum number of clients allowed
        position    = 9,
        -- spawn       = browser,
        spawn       = "firefox",
    },
}
-- }}}

-- SHIFTY: application matching rules {{{
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
        match = {
            "Navigator",
            "Vimperator",
            "Gran Paradiso",
            "testterm",
        },
        tag = "web",
    },
    {
        match = {
            "tk",
        },
        float = true,
    },
    {
        match = {
            "Shredder.*",
            "Thunderbird",
            "mutt",
        },
        tag = "mail",
    },
    {
        match = {
            "pcmanfm",
        },
        slave = true
    },
    {
        match = {
            "OpenOffice.*",
            "Abiword",
            "Gnumeric",
        },
        tag = "office",
    },
    {
        match = {
            "Mplayer.*",
            "Mirage",
            "gimp",
            "gtkpod",
            "Ufraw",
            "easytag",
        },
        tag = "media",
        nopopup = true,
    },
    {
        match = {
            "MPlayer",
            "Gnuplot",
            "galculator",
        },
        float = true,
    },
    {
        match = {
            terminal,
        },
        honorsizehints = false,
        slave = true,
    },
    {
        match = {""},
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c)
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
                end),
            awful.button({modkey}, 3, awful.mouse.client.resize)
            )
    },
}
-- }}}

-- SHIFTY: default tag creation rules {{{
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile.bottom,
    ncol = 1,
    mwfact = 0.60,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}
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
-- {{{ Define widgets
myspacer = wibox.widget.textbox()
myspacer:set_text(' ')

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
            return ' ' .. args["{Title}"] .. ' '
        end
    end, 1)



batwidget = wibox.widget.textbox()
function battester()
    local val_f = io.open('/sys/class/power_supply/BAT0/status', 'r')
    if (val_f == nil) then
        return "Plugged"
    end
    local val = val_f:read("*line")
    val_f:close()
    if (val == 'Discharging') then
        return val
    else
        return "Plugged"
    end
end

vicious.register(batwidget, vicious.widgets.bat,
function(widget, args)
    -- plugged
    if (battester() == "Plugged") then
        return ''
    elseif (args[2] <=10 and batstate() == 'Discharging') then
        naughty.notify{
            text = 'battery is very low',
            title = 'Warning',
            position = 'top_right',
            timeout = 0,
            fg='#000000',
            bg='#ff0000',
            screen = 1,
            ontop = true,
        }
    end
    return args[2]
end, 60, 'BAT0')


-- {{{ Calendar functions
-- taken from copycat-killer/awesome-copycats
local os = os
local string = string
local table = table
local util = awful.util

char_width = nil
text_color = theme.fg_normal or "#FFFFFF"
today_color = theme.tasklist_fg_focus or "#FF7100"
calendar_width = 21

local calendar = nil
local offset = 0

local data = nil

local function pop_spaces(s1, s2, maxsize)
   local sps = ""
   for i = 1, maxsize - string.len(s1) - string.len(s2) do
      sps = sps .. " "
   end
   return s1 .. sps .. s2
end

local function create_calendar()
   offset = offset or 0

   local now = os.date("*t")
   local cal_month = now.month + offset
   local cal_year = now.year
   if cal_month > 12 then
      cal_month = (cal_month % 12)
      cal_year = cal_year + 1
   elseif cal_month < 1 then
      cal_month = (cal_month + 12)
      cal_year = cal_year - 1
   end

   local last_day = os.date("%d", os.time({ day = 1, year = cal_year,
                                            month = cal_month + 1}) - 86400)
   local first_day = os.time({ day = 1, month = cal_month, year = cal_year})
   local first_day_in_week =
      os.date("%w", first_day)
   local result = "su mo tu we th fr sa\n"
   for i = 1, first_day_in_week do
      result = result .. "   "
   end

   local this_month = false
   for day = 1, last_day do
      local last_in_week = (day + first_day_in_week) % 7 == 0
      local day_str = pop_spaces("", day, 2) .. (last_in_week and "" or " ")
      if cal_month == now.month and cal_year == now.year and day == now.day then
         this_month = true
         result = result ..
            string.format('<span weight="bold" foreground = "%s">%s</span>',
                          today_color, day_str)
      else
         result = result .. day_str
      end
      if last_in_week and day ~= last_day then
         result = result .. "\n"
      end
   end

   local header
   if this_month then
      header = os.date("%a, %d %b %Y")
   else
      header = os.date("%B %Y", first_day)
   end
   return header, string.format('<span font="%s" foreground="%s">%s</span>',
                                theme.font, text_color, result)
end

local function calculate_char_width()
   return beautiful.get_font_height(theme.font) * 0.555
end

function hide()
   if calendar ~= nil then
      naughty.destroy(calendar)
      calendar = nil
      offset = 0
   end
end

function show(inc_offset)
   inc_offset = inc_offset or 0

   local save_offset = offset
   hide()
   offset = save_offset + inc_offset

   local char_width = char_width or calculate_char_width()
   local header, cal_text = create_calendar()
   calendar = naughty.notify({ title = header,
                               text = cal_text,
                               timeout = 0, hover_timeout = 0.5,
                            })
end

function add_calendar(t_out)
   hide()
   local char_width = char_width or calculate_char_width()
   local header, cal_text = create_calendar()
   calendar = naughty.notify({ title = header,
                               text = cal_text,
                               timeout = t_out,
                            })
end
-- }}}

datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, "%a: %R ", 60)
datewidget:connect_signal("mouse::enter", function() show(0) end)
datewidget:connect_signal("mouse::leave", hide)
datewidget:buttons(util.table.join( awful.button({ }, 1, function() show(-1) end),
                                     awful.button({ }, 3, function() show(1) end)))


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
end
-- }}}

-- SHIFTY: initialize shifty {{{
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings (inc. shifty bindings)
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    
    -- Shifty: keybindings specific to shifty
    awful.key({modkey, "Shift"}, "d", shifty.del), -- delete a tag
    awful.key({modkey, "Shift"}, "n", shifty.send_prev), -- client to prev tag
    awful.key({modkey}, "n", shifty.send_next), -- client to next tag
    awful.key({modkey, "Control"},
              "n",
              function()
                  local t = awful.tag.selected()
                  local s = awful.util.cycle(screen.count(), awful.tag.getscreen(t) + 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
              end),
    awful.key({modkey}, "a", shifty.add), -- creat a new tag
    awful.key({modkey, "Shift"}, "r", shifty.rename), -- rename a tag
    awful.key({modkey, "Shift"}, "a", -- nopopup new tag
    function()
        shifty.add({nopopup = true})
    end),

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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) end),
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


    -- Calendar pop-up
    awful.key({ altkey,           }, "c",     function () add_calendar(5) end),

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
    awful.key({ modkey, "Shift"   }, "t",      function (c) shifty.create_titlebar(c) awful.titlebar(c) c.border_width = 1 end),
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
-- SHIFTY: assign client keys to shifty for use in {{{
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                      awful.tag.viewonly(shifty.getpos(i))
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      awful.tag.viewtoggle(shifty.getpos(i))
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local t = shifty.getpos(i)
                          awful.client.movetotag(t)
                          awful.tag.viewonly(t)
                       end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          awful.client.toggletag(shifty.getpos(i))
                      end
                  end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- vim: set foldmethod=marker:
