---------------------------
-- Default awesome theme --
---------------------------
-- No idea why this has to be "local" but doesn't work without
local awful = require("awful")

theme = {}


home                  = os.getenv("HOME")
config                = awful.util.getdir("config")
layoutdir             = config .. "/themes/icons/layouts_white"
themedir              = config .. "/themes/personal"
shared                = "/usr/share/awesome"
sharedtheme           = "/usr/share/awesome/themes/default"


-- Really haven't found the best font yet.
theme.font          = "terminus 8"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

theme.taglist_squares_sel     = themedir .. "/taglist/smallsquarefw.png"
theme.taglist_squares_unsel   = themedir .. "/taglist/smallsquarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = sharedtheme .. "/submenu.png"
theme.menu_height = 15
theme.menu_width  = 120

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = sharedtheme .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = sharedtheme .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive     = sharedtheme .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = sharedtheme .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = sharedtheme .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = sharedtheme .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = sharedtheme .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = sharedtheme .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = sharedtheme .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = sharedtheme .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = sharedtheme .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = sharedtheme .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = sharedtheme .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = sharedtheme .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = sharedtheme .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = sharedtheme .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = sharedtheme .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = sharedtheme .. "/titlebar/maximized_focus_active.png"

-- can use the default with sharedtheme .. "/background.png"
theme.wallpaper = themedir .. "/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh            = layoutdir .. "/fairhw.png"
theme.layout_fairv            = layoutdir .. "/fairvw.png"
-- theme.layout_threep           = themedir .. "/layouts_white/tileleftw.png"
theme.layout_floating         = layoutdir .. "/floating_aw.png"
theme.layout_magnifier        = layoutdir .. "/magnifierw.png"
theme.layout_max              = layoutdir .. "/maxw.png"
theme.layout_tilebottom       = layoutdir .. "/tilebottomw.png"
theme.layout_tileleft         = layoutdir .. "/tileleftw.png"
theme.layout_tile             = layoutdir .. "/tilew.png"
theme.layout_tiletop          = layoutdir .. "/tiletopw.png"
theme.layout_spiral           = layoutdir .. "/spiralw.png"
theme.layout_dwindle          = layoutdir .. "/dwindlew.png"
theme.layout_fullscreen       = sharedtheme .. "/layouts/fullscreenw.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- My icons for other things
theme.app_menu_icon = themedir .. "/alticons/arch-linux-logosmall.jpg"


return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
