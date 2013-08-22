local snap = {}

function snap.snapwin(c, scr, pos)
    local g = c:geometry()
    wa = scr.workarea
    local offset = 15
    if pos == "tl" then
        g.x = wa.width * 0.006
        g.y = wa.height * 0.01 + offset
    elseif pos == "tr" then
        g.x = wa.width * 0.99 - g.width
        g.y = wa.height * 0.006 + offset
    elseif pos == "bl" then
        g.x = wa.width * 0.006
        g.y = wa.height *  0.99 - g.height + offset
    elseif pos == "br" then
        g.x = wa.width * 0.994 - g.width
        g.y = wa.height * 0.99 - g.height + offset
    elseif pos == "brs" then
        g.width = wa.width * 0.5
        g.height = wa.height * 0.35
        g.x = wa.width * 0.994 - g.width
        g.y = wa.height * 0.99 - g.height + offset
    elseif pos == "bml" then
        g.width = wa.width
        g.height = wa.height * 0.3
        g.x = 0
        g.y = wa.height*0.7 + offset
    elseif pos == "trn" then
        g.height = wa.height * 0.48
        g.width = wa.width * 0.47
        g.x = wa.width * 0.99 - g.width
        g.y = wa.height * 0.01 + offset
    end
    c:geometry(g)
end

return snap

