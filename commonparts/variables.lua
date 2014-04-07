rettab = {
    wcard = "wlp5s0",
    terminal = "xterm",
    editor = os.getenv("EDITOR") or "vi",
    modkey = "Mod4",
    altkey = "Mod1"
}

rettab.editor_cmd = rettab.terminal .. " -e " .. rettab.editor

return rettab
