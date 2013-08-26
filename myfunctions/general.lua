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
    return 'AC'
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
  end
  return args[2] .. "%"
end
-- }}}

-- {{{ Disk space functions
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
    rettab.removefs()
    local capi = {
        mouse = mouse,
        screen = screen
      }
    local cal = awful.util.pread(scriptdir .. "dfs")
    cal = string.gsub(cal, "          ^%s*(.-)%s*$", "%1")
    infos = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', font, cal),
        timeout = 0,
        position = "top_right",
        margin = size.margin or 10,
        height = size.height or 170,
        width = size.width or 600,
        screen  = capi.mouse.screen
    })
end


function rettab.fssteam(widget, args)
  if ( args["{/home/apple/share used_p}"] >= 99 ) then
    naughty.notify({ title = "warning", text = "/share partition ran out!\nmake some room",
    timeout = 10,
    position = "top_right",
    fg = beautiful.fg_urgent,
    bg = beautiful.bg_urgent })
  end
  return gray .. "Hdd " .. coldef .. white .. args["{/home/apple/share used_p}"] .. coldef
end


function rettab.fscol(widget, args)
    if args["{/home/apple/share used_p}"] >= 95 and args["{/home/apple/share used_p}"] < 99 then
        return colwhi .. args["{/home/apple/share used_p}"] .. "%" .. coldef
    elseif args["{/home/apple/share used_p}"] >= 99 then
        naughty.notify({ title = "warning", text = "/share partition ran out!\nmake some room",
                            timeout = 10,
                            position = "top_right",
                            fg = beautiful.fg_urgent,
                            bg = beautiful.bg_urgent })
        return colwhi .. args["{/home/apple/share used_p}"] .. "%" .. coldef
    else
        return azure .. args["{/home/apple/share used_p}"] .. "%" .. coldef
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
      position = "top_left",
      icon = beautiful.widget_mail_notify,
      fg = beautiful.fg_urgent,
      bg = beautiful.bg_urgent })
      notify_shown = true
    end
    return gray .. " Mail " .. coldef .. white .. args["{count}"] .. " " .. coldef
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

    if offs == 0
    then -- current month showing, today highlighted
        if today >= 10
        then
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
    calendar.id = naughty.notify({ text = c_text,
                                   icon = calendar.notify_icon,
                                   fg = calendar.fg, 
                                   bg = calendar.bg,
                                   timeout = tims
                                    })
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
local abstract_borders = {top=0.006, side=0.004}

local abstract_sizes = {small={0.35, 0.5}, normal={0.43, 0.44}, long={0.3, 0.992}}

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

function rettab.resize(c, scr, size, wiboxhgt)
    local cgeom = c:geometry()
    local wa = scr.workarea
    local newgeom = create_actual_sizes(wa, size)
    newgeom.x, newgeom.y = cgeom.x, cgeom.y
    local borders = find_borders_in_pixels(wa)
    if cgeom.x + newgeom.width > borders.right  or cgeom.y + newgeom.height > borders.bottom then
        newgeom.x = newgeom.x - math.max(cgeom.x + newgeom.width - borders.right, 0)
        newgeom.y = newgeom.y - math.max(cgeom.y + newgeom.height - borders.bottom, 0)
    end
    c:geometry(newgeom)
end
-- }}}

-- }}}

return rettab

-- vim: foldmethod=marker:
