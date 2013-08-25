local awful   = require("awful")
local naughty = require("naughty")

rettab = {}

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

-- {{{ Battery functions
function rettab.batstate()

  local file = io.open("/sys/class/power_supply/BAT0/status", "r")

  if (file == nil) then
    return "Cable plugged"
  end

  local batstate = file:read("*line")
  file:close()

  if (batstate == 'Discharging' or batstate == 'Charging') then
    return batstate
  else
    return "Fully charged"
  end
end
-- }}}

-- {{{ Pop-up disk space functions
local infos = nil

function rettab.remove_info()
    if infos ~= nil then
        naughty.destroy(infos)
        infos = nil
    end
end

function rettab.add_info(font, size)
    rettab.remove_info()
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
-- }}}

return rettab

-- vim: foldmethod=marker:
