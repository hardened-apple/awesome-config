local ipairs = ipairs
local math   = math

local revthreep = {}

local function do_three(p)
    local wa = p.workarea
    local cls = p.clients

    if #cls > 0 then

        for k, c in ipairs(cls) do
            -- k = k-1 -- Make zero based
            local g = {}

            -- k starts at 1
            myopt = k % 3

            if myopt == 1 then
                g.height = wa.height * 0.5
                g.y = wa.height * 0.05
                g.width  = wa.width * 0.52
                g.x = wa.width * 0.02
            elseif myopt == 2 then
                g.height = wa.height * 0.5
                g.y = 0
                g.width  = wa.width * 0.4
                g.x = wa.width*0.6
            else
                g.height = wa.height*0.4
                g.width  = wa.width
                g.x      = 0
                g.y      = wa.height*0.6
            end


            g.height  = g.height - c.border_width*2
            g.width   = g.width  - c.border_width*2
            g.x       = g.x + wa.x
            g.y       = g.y + wa.y

            c:geometry(g)
        end
    end
end

revthreep.name = "revthreep"
function revthreep.arrange(p)
    return do_three(p)
end

return revthreep
