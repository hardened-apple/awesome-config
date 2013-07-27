-- {{{ Grab environment
local tonumber = tonumber
local setmetatable = setmetatable
local string = { format = string.format }
local helpers = require("vicious.helpers")
local math = {
    min = math.min,
    floor = math.floor
}
-- }}}


-- Bat: provides state, charge, and remaining time for a requested battery
-- vicious.widgets.bat
local bat = {}


-- {{{ Battery widget type
local function worker(format, warg)
    if not warg then return end

    local battery = helpers.pathtotable("/sys/class/power_supply/"..warg)
    -- Check if the battery is present
    if battery.present ~= "1\n" then
        return 0
    end

    -- Get capacity information
    remaining, capacity = battery.charge_now, battery.charge_full_design
    local percent = math.min(math.floor(remaining / capacity * 100), 100)

    return percent
end
-- }}}

return setmetatable(bat, { __call = function(_, ...) return worker(...) end })
