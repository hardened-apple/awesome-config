--[[                                    ]]--
--                                        -
--   Awesome WM 3.5.+ config cal widget   --
--       github.com/copycat-killer        --
--                                        -
--[[                                    ]]--
-- slightly modified by me


local awful   = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local io        = require("io")
local os        = require("os")
local tonumber  = tonumber

module("cal")


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

function hide_calendar()
    if calendar.id ~= nil then
        naughty.destroy(calendar.id)
        calendar.id = nil
    end
end

function show_calendar(t_out, inc_offset)
    hide_calendar()

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

function attach_calendar(widget, background, foreground)
    create_calendar(background, foreground)
    widget:connect_signal("mouse::enter", function () show_calendar() end)
    widget:connect_signal("mouse::leave", function () hide_calendar() end)
    widget:buttons(awful.util.table.join( awful.button({ }, 1, function () show_calendar(0,  1) end),
                                    awful.button({ }, 3, function () show_calendar(0, -1) end) ))
end

