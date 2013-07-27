--{{{ Main
local awful = require("awful")

theme = {}

home          = os.getenv("HOME")
config        = awful.util.getdir("config")
shared        = "/usr/share/awesome"
sharedicons   = shared .. "/icons"
sharedthemes  = shared .. "/themes"
themes        = config .. "/themes"
themename     = "/tree"
themedir      = themes .. themename

theme.wallpaper = themedir .. "/background.jpg"
--}}}

theme.font          = "terminus 8"

theme.bg_normal     = "#484e3a"
theme.bg_focus      = "#67744a"
theme.bg_urgent     = "#ff5a00"
theme.bg_minimize   = "#67744a"

theme.fg_normal     = "#d0d0cc"
theme.fg_focus      = "#d0d0cc"
theme.fg_urgent     = "#2c2c2c"
theme.fg_minimize   = "#2c2c2c"

theme.border_width  = "0"
theme.border_normal = "#100000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.taglist_squares_sel   = themedir .. "/taglist/squarefw.png"
theme.taglist_squares_unsel = themedir .. "/taglist/squarew.png"

theme.tasklist_floating_icon = themedir .. "/tasklist/floatingw.png"

theme.menu_submenu_icon = themedir .. "/submenu.png"
theme.menu_height   = "15"
theme.menu_width    = "100"

-- Define the image to load
theme.titlebar_close_button_normal = themedir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themedir .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = themedir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themedir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themedir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themedir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themedir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themedir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themedir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themedir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themedir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themedir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themedir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themedir .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themedir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themedir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themedir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themedir .. "/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themedir .. "/layouts14/fairhw.png"
theme.layout_fairv = themedir .. "/layouts14/fairvw.png"
theme.layout_floating  = themedir .. "/layouts14/floatingw.png"
theme.layout_magnifier = themedir .. "/layouts14/magnifierw.png"
theme.layout_max = themedir .. "/layouts14/maxw.png"
theme.layout_fullscreen = themedir .. "/layouts14/fullscreenw.png"
theme.layout_tilebottom = themedir .. "/layouts14/tilebottomw.png"
theme.layout_tileleft   = themedir .. "/layouts14/tileleftw.png"
theme.layout_tile = themedir .. "/layouts14/tilew.png"
theme.layout_tiletop = themedir .. "/layouts14/tiletopw.png"
theme.layout_spiral  = themedir .. "/layouts14/spiralw.png"
theme.layout_dwindle = themedir .. "/layouts14/dwindlew.png"

theme.awesome_icon = themedir .. "/logo20.png"



return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
