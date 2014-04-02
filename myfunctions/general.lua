local awful     = require("awful")
local naughty   = require("naughty")
local beautiful = require("beautiful")
local io        = require("io")
local os        = require("os")
local tonumber  = tonumber

rettab = {}

-- {{{ Define Colours
coldef  = "</span>"
colwhi  = "<span color='#b2b2b2'>"
white  = "<span color='#cdcdcd'>"
holowhite = "<span color='#FFFFFF'>"
blue = "<span color='#80CCE6'>"
gray = "<span color='#94928f'>"
red = "<span color='#e54c62'>"
azure = "<span color='#80d9d8'>"
-- }}}

-- {{{ Autostart applications
function rettab.run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
 end
-- }}}

-- {{{ Wifi functions
function rettab.wifinorm(widget, args)
    if args["{sign}"] == 0 then
        return "✗"
    else
        return "✓"
    end
end

function rettab.wifiholo(widget, args)
    if args["{wlp5s0 carrier}"] == 0 then
       if no_net_shown == true then
         naughty.notify({ title = "wlp5s0", text = "No carrier",
         timeout = 7,
         position = "top_left",
         icon = beautiful.widget_no_net_notify,
         fg = "#FF1919",
         bg = beautiful.bg_normal })
         no_net_shown = false
         netdown_icon:set_image()
         netup_icon:set_image()
       end
       return holowhite .. "<span font='Tamsyn 2'> </span>Net " .. coldef .. "<span color='#FF4040'>Off<span font='Tamsyn 5'> </span>"  .. coldef
    else
       if no_net_shown ~= true then
         netdown_icon:set_image(beautiful.net_down)
         netup_icon:set_image(beautiful.net_up)
         no_net_shown = true
       end
       return holowhite .. "<span font='Tamsyn 2'> </span>" .. args["{wlp5s0 down_kb}"] .. " - " .. args["{wlp5s0 up_kb}"] .. "<span font='Tamsyn 2'> </span>" .. coldef
    end
end
-- }}}

-- {{{ Battery functions
function rettab.batstate()
  local file = io.open("/sys/class/power_supply/BAT0/status", "r")
  if (file == nil) then
    return 'Cable plugged'
  end
  local batstate = file:read("*line")
  file:close()
  if (batstate == 'Discharging' or batstate == 'Charging') then
    return batstate
  else
    return "Fully charged"
  end
end


function rettab.batbar(widget, args)
    if (rettab.batstate() == 'Fully charged' or rettab.batstate() == 'Charging') then
        widget:set_width(0)
    else
        widget:set_width(100)
    end
    return args[2]
end


function rettab.batnorm(widget, args)
    -- plugged
  if (rettab.batstate() == 'Cable plugged' or rettab.batstate() == 'Fully charged') then
    if beautiful.name == 'holo' then
        return ''
    else
        return 'AC'
    end
    -- critical
  elseif (args[2] <= 5 and rettab.batstate() == 'Discharging') then
    naughty.notify({
      text = "battery about to die...",
      title = "Urgent Battery State",
      position = "top_right",
      timeout = 10,
      fg="#000000",
      bg="#ffffff",
      screen = 1,
      ontop = true,
    })
    -- low
  elseif (args[2] <= 10 and rettab.batstate() == 'Discharging') then
    naughty.notify({
      text = "battery is low",
      title = "Battery Warning",
      position = "top_right",
      timeout = 10,
      fg="#ffffff",
      bg="#262729",
      screen = 1,
      ontop = true,
    })
  end
  if beautiful.name == 'steamburn' then
    return gray .. "Bat " .. coldef .. white .. args[2] .. " " .. coldef
elseif beautiful.name == 'holo' then
    return blue .. "Bat " .. coldef .. holowhite .. args[2] .. " " .. coldef
  end
  return args[2] .. "%"
end
-- }}}

-- {{{ Disk space functions
local viewformat = "{/ used_p}"
local infos = nil

function rettab.removefs()
    if infos ~= nil then
        naughty.destroy(infos)
        infos = nil
    end
end

-- This function calls the global 'scriptdir' that must be defined in any rc
-- that calls it.
function rettab.showfs(font, size)
    local font = font or beautiful.font
    rettab.removefs()
    local capi = {
        mouse = mouse,
        screen = screen
      }
    local hdd = awful.util.pread(scriptdir .. "dfs")
    hdd = string.gsub(hdd, "          ^%s*(.-)%s*$", "%1")
    infos = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', font, hdd),
        timeout = 0,
        position = "top_right",
        margin = size.margin or 10,
        height = size.height or 170,
        width = size.width or 600,
        screen  = capi.mouse.screen
    })
end

function rettab.fssteam(widget, args)
  if ( args[viewformat] >= 99 ) then
    naughty.notify({ title = "warning", text = "/share partition ran out!\nmake some room",
    timeout = 10,
    position = "top_right",
    fg = beautiful.fg_urgent,
    bg = beautiful.bg_urgent })
  end
  return gray .. "Hdd " .. coldef .. white .. args[viewformat] .. coldef
end


function rettab.fsholo(widget, args)
  if ( args[viewformat] >= 90 ) then
      if ( args[viewformat] >= 99 and too_much == false ) then
        naughty.notify({ title = "warning", text = "/share partition ran out!\nmake some room",
        timeout = 7,
        position = "top_right",
        fg = beautiful.fg_urgent,
        bg = beautiful.bg_urgent })
        too_much = true
      end
      return holowhite .. " Hdd " .. coldef .. blue .. args[viewformat] .. coldef .. " "
  else
    return " "
  end
end


function rettab.fscol(widget, args)
    if args[viewformat] >= 90 and args[viewformat] < 99 then
        return colwhi .. args[viewformat] .. "%" .. coldef
    elseif args[viewformat] >= 99 then
        naughty.notify({ title = "warning", text = "/share partition ran out!\nmake some room",
                            timeout = 10,
                            position = "top_right",
                            fg = beautiful.fg_urgent,
                            bg = beautiful.bg_urgent })
        return colwhi .. args[viewformat] .. "%" .. coldef
    else
        return azure .. args[viewformat] .. "%" .. coldef
    end
end
-- }}}

-- {{{ MPD widgets

function rettab.mpdnorm(widget, args)
    if args["{state}"] == "Stop" then
        return "  "
    else
        return ' ' .. args["{Title}"] .. ' '
    end
end


curr_track = nil
function rettab.mpdsteam(widget, args)
    if (args["{state}"] == "Play") then
    if( args["{Title}"] ~= curr_track )
    then
        curr_track = args["{Title}"]
        os.execute(scriptdir .. "mpdinfo")
        old_id = naughty.notify({
            title = "Now playing",
            text = args["{Artist}"] .. " (" .. args["{Album}"] .. ")\n" .. args["{Title}"],
            icon = "/tmp/mpdnotify_cover.png",
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            timeout = 5,
            replaces_id = old_id
        }).id
    end
        return gray .. args["{Title}"] .. coldef .. white .. " " .. args["{Artist}"] .. coldef
    elseif (args["{state}"] == "Pause") then
        return gray .. "mpd " .. coldef .. white .. "paused" .. coldef
    else
        return ""
    end
end


function rettab.mpdholo(widget, args)
	if args["{state}"] == "Play" then
        if args["{Title}"] ~= curr_track then
            curr_track = args["{Title}"]
            os.execute(scriptdir .. "mpdinfo")
            old_id = naughty.notify({
                title = "Now playing",
                text = args["{Artist}"] .. " (" .. args["{Album}"] .. ")\n" .. args["{Title}"],
                icon = "/tmp/mpdnotify_cover.png",
                fg = beautiful.fg_normal,
                bg = beautiful.bg_normal,
                timeout = 5,
                replaces_id = old_id
            }).id
        end
        mpd_icon:set_image(beautiful.mpd_on)
        play_pause_icon:set_image(beautiful.pause)
        return blue  .. "<span font='Tamsyn 1'> </span>" .. args["{Title}"] .. coldef .. holowhite .. " " .. args["{Artist}"] .. coldef .. " "
    elseif args["{state}"] == "Pause" then
        mpd_icon:set_image(beautiful.mpd)
        play_pause_icon:set_image(beautiful.play)

        return blue .. "<span font='Tamsyn 2'> </span>mpd " .. coldef .. holowhite .. "paused " .. coldef
	else
        mpd_icon:set_image(beautiful.mpd)
        curr_track = nil
        return "<span font='Tamsyn 3'> </span>"
    end
end


function rettab.mpdcol(widget, args)
    -- play
    if (args["{state}"] == "Play") then
        return red .. args["{Title}"] .. coldef .. colwhi .. " - " .. coldef ..
               colwhi  ..  args["{Artist}"] .. coldef
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
end
-- }}}

-- {{{ Gmail functions
function rettab.mailsteam(widget, args)
  if beautiful.name == 'holo' then
    notify_position = 'top_right'
  else
    notify_position = 'top_left'
  end
  notify_title = "You have a new message."
  notify_text = '"' .. args["{subject}"] .. '"'
  if (args["{count}"] > 0 ) then
    if (notify_shown == false) then
      if (args["{count}"] == 1) then
          notify_title = "You have 1 new message"
          notify_text = args["{subject}"]
      else
          notify_title = "You have " .. args["{count}"] .. " new messages"
          notify_text = 'On: "' .. args["{subject}"] .. '"'
      end
      naughty.notify({ title = notify_title, text = notify_text,
      timeout = 7,
      position = notify_position,
      icon = beautiful.widget_mail_notify,
      fg = beautiful.fg_urgent,
      bg = beautiful.bg_urgent })
      notify_shown = true
    end
    if beautiful.name == "steamburn" then
        return gray .. " Mail " .. coldef .. white .. args["{count}"] .. " " .. coldef
    else
        return holowhite .. " Mail " .. coldef .. blue .. args["{count}"] .. " " .. coldef
    end
  else
    notify_shown = false
    return ''
  end
end
-- }}}

-- {{{ Volume functions
function rettab.volnorm(widget, args)
    return ' ' .. args[2] .. ':' .. args[1] .. ' '
end

function rettab.volsteam(widget, args)
  if (args[2] ~= "♩" ) then
     return gray .. "Vol " .. coldef .. white .. args[1] .. " " .. coldef
  else
     return gray .. "Vol " .. coldef .. white .. "mute " .. coldef
  end
end
-- }}}

-- {{{ Calendar function
calendar = {}

local function create_calendar(background, foreground)
    calendar.id = nil
    calendar.offset = 0
    -- calendar.icons_dir = icons_dir .. "cal/white/" -- default
    calendar.notify_icon = nil
    calendar.font_size = 8
    calendar.bg = background or beautiful.bg_normal
    calendar.fg = foreground or beautiful.fg_normal
    calendar.foc = beautiful.fg_focus or "#535d6c"
end


function rettab.hide_calendar()
    if calendar.id ~= nil then
        naughty.destroy(calendar.id)
        calendar.id = nil
    end
end


function rettab.show_calendar(t_out, inc_offset)
    rettab.hide_calendar()

    local offs = inc_offset or 0
    local tims = t_out or 0
    local f, c_text
    local today = tonumber(os.date('%d'))
    local init_t = '/usr/bin/cal | sed -r -e "s/(^| )( '
    -- let's take font only, font size is set in calendar table
    local font = beautiful.font:sub(beautiful.font:find(""), beautiful.font:find(" "))

    if offs == 0 then -- current month showing, today highlighted
        if today >= 10 then
           init_t = '/usr/bin/cal | sed -r -e "s/(^| )('
        end

        -- calendar.notify_icon = calendar.icons_dir .. today .. ".png"
        calendar.offset = 0

        -- bg and fg inverted to highlight today
        f = io.popen( init_t .. today ..
                      ')($| )/\\1<b><span foreground=\\"'
                      .. calendar.foc ..
                      '\\">\\2<\\/span><\\/b>\\3/"',"r" )

    else -- no current month showing, no day to highlight
       local month = tonumber(os.date('%m'))
       local year = tonumber(os.date('%Y'))

       calendar.offset = calendar.offset + offs
       month = month + calendar.offset

       if month > 12 then
           month = 12
           calendar.offset = 12 - tonumber(os.date('%m'))
       elseif month < 1 then
           month = 1
           calendar.offset = 1 - tonumber(os.date('%m'))
       end

       calendar.notify_icon = nil

       f = io.popen('/usr/bin/cal ' .. month .. ' ' .. year ,"r")

    end

    c_text = "<tt><span font='" .. font .. " "
             .. calendar.font_size .. "'><b>"
             .. f:read() .. "</b>\n\n"
             .. f:read() .. "\n"
             .. f:read("*all"):gsub("\n*$", "") .. "</span></tt>"
    f:close()

    -- notification
    if beautiful.name == "holo" then
        calendar.id = naughty.notify({ text = c_text,
                                       position = "bottom_right",
                                       fg = beautiful.fg_normal,
                                       bg = beautiful.bg_normal,
                                       timeout = t_out
                                       })
    else
        calendar.id = naughty.notify({ text = c_text,
                                       icon = calendar.notify_icon,
                                       fg = calendar.fg,
                                       bg = calendar.bg,
                                       timeout = tims
                                       })
    end
end

function rettab.attach_calendar(widget, background, foreground)
    create_calendar(background, foreground)
    widget:connect_signal("mouse::enter", function () rettab.show_calendar() end)
    widget:connect_signal("mouse::leave", function () rettab.hide_calendar() end)
    widget:buttons(awful.util.table.join( awful.button({ }, 1, function () rettab.show_calendar(0,  1) end),
                                    awful.button({ }, 3, function () rettab.show_calendar(0, -1) end) ))
end

-- }}}

-- {{{ Snap function
-- {{{ Position definitions
-- To change the defined positions, just modify these three tables.
-- All values are in percentage of workarea, borders are from edge of monitor
local abstract_borders = {top=0.008, side=0.006}

local abstract_sizes = {small={0.35, 0.5}, normal={0.43, 0.44}, long={0.3, 0.987}}

local abstract_positions = {tl=function(g) return {borders['top'], borders['left']} end,
                            tr=function(g) return {borders['top'], borders['right'] - g.width} end,
                            bl=function(g) return {borders['bottom'] - g.height, borders['left']} end,
                            br=function(g) return {borders['bottom'] - g.height,
                                                   borders['right'] - g.width} end,
                            center=function(g) return {wa.height/2 - g.height/2,
                                                       wa.width/2 - g.width/2} end }
-- }}}

-- {{{ Moving
local function find_borders_in_pixels(wa)
    -- Converts the global abstract_borders into actual values based on workarea size
    -- gives borders in pixels away from workarea borders - does not account for
    -- multiple monitors or wiboxes
    local topval = math.floor(wa.height * abstract_borders.top)
    local bottomval = wa.height - topval
    local leftval = math.floor(wa.width * abstract_borders.side)
    local rightval = wa.width - leftval
    return {top=topval, bottom=bottomval, right=rightval, left=leftval}
end


function rettab.snap(c, scr, pos, wiboxhgt)
    -- c is client, pos is symbolic representation of position
    local cgeom = c:geometry()
    local scrgeom = scr.geometry
    wa = scr.workarea
    borders = find_borders_in_pixels(wa, cgeom)
    newgeom = {}
    -- Uses the fact that wa and borders are global variables
    newposition = abstract_positions[pos](cgeom)
    newgeom.y = newposition[1] + scrgeom.y + wiboxhgt
    newgeom.x = newposition[2] + scrgeom.x
    c:geometry(newgeom)
end
-- }}}

-- {{{ Resizing
local function create_actual_sizes(wa, sz)
    -- Converts abstract sizes into actual sizes based on work area size
    local function actu(tab)
        return {height=math.floor(tab[1] * wa.height), width=math.floor(tab[2] * wa.width)}
    end
    pixel_sizes = {}
    for key, value in pairs(actu(abstract_sizes[sz])) do pixel_sizes[key]=value end
    return pixel_sizes
end

function rettab.resize(c, scr, size)
    local cgeom = c:geometry()
    local wa = scr.workarea
    local scrgeom = scr.geometry
    local newgeom = create_actual_sizes(wa, size)
    newgeom.x, newgeom.y = cgeom.x, cgeom.y
    local borders = find_borders_in_pixels(wa)
    if cgeom.x + newgeom.width > borders.right + scrgeom.x  or cgeom.y + newgeom.height > borders.bottom + scrgeom.y then
        newgeom.x = newgeom.x - math.max(cgeom.x + newgeom.width - borders.right - scrgeom.x, 0)
        newgeom.y = newgeom.y - math.max(cgeom.y + newgeom.height - borders.bottom - scrgeom.y, 0)
    end
    c:geometry(newgeom)
end
-- }}}

-- }}}

-- {{{ change theme
function rettab.run_script(script, myprompt, promptbox)
    awful.prompt.run({prompt=myprompt}, promptbox[mouse.screen].widget,
                        function(text)
                            os.execute(script .. text)
                        end)
end

mythemes = {multicolor = "awesome", steamburn = "awesome", muted = "awesome",
            main = "awesome", dust = "awesome", holo = "awesome", shifty = "awesome",
            pek_woman = "pek", pek_build = "pek", pek_pier = "pek",
            pek_windmill = "pek", subtle_new = "subtle", subtle_orig = "subtle"}

-- Changes theme, if changing to awesome then change the rc.lua (link to
--       different place) and restart, if changing to other window manager, then use
--       exec on a script and let the script use exec on the new WM
function rettab.change_theme(scriptdir, themename)
    if mythemes[themename] == "awesome" then
        os.execute(scriptdir .. 'change_theme.sh ' .. themename)
        awesome.restart()
    elseif mythemes[themename] == "pek" or mythemes[themename] == "subtle" then
        -- Replace awesome with the shell script that changes the xresources
        -- and sets the background, then replaces itself with a new swindow
        -- manager
        awesome.exec(scriptdir .. 'change_theme.sh ' .. themename)
    end
end
-- }}}

return rettab

-- vim: foldmethod=marker:
