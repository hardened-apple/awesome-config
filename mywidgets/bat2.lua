


function on()
    local status_f = io.open('/sys/class/power_supply/BAT0/status', 'r')
    local status = status_f:read()
    status_f:close()
    if status == 'Discharging' then
        return true
    else
        return false
    end
end

function charge()
    local now_f = io.open('/sys/class/power_supply/BAT0/charge_now', 'r')
    local now = now_f:read()
    now_f:close()
    local full_f = io.open('/sys/class/power_supply/BAT0/charge_full_design', 'r')
    local full = full_f:read()
    full_f:close()
    local perc == math.floor(now / full * 100)
    return perc
end
