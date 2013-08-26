-- dust, awesome3 theme, based off of the gtk+ theme dust, by tdy

--{{{ Main
local awful = require("awful")

theme = {}

home          = os.getenv("HOME")
config        = awful.util.getdir("config")
shared        = "/usr/share/awesome"
sharedicons   = shared .. "/icons"
sharedthemes  = shared .. "/themes"
layoutdir     = config .. "/themes/icons"
themes        = config .. "/themes"
themename     = "/dust"
themedir      = themes .. themename

theme.wallpaper = themedir .. "/background.jpg"
--}}}

theme.name          = "dust"
theme.font          = "clean 8"

theme.bg_normal     = "#22222200"
theme.bg_focus      = "#908884"
theme.bg_urgent     = "#cd7171"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#111111"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#222222"
theme.border_focus  = "#908884"
theme.border_marked = "#91231c"

theme.bg_widget        = "#333333"
theme.fg_widget        = "#908884"
theme.fg_center_widget = "#636363"
theme.fg_end_widget    = "#ffffff"
theme.fg_off_widget    = "#22211f"

theme.taglist_squares_sel    = themedir .. "/taglist14/squaref.png"
theme.taglist_squares_unsel  = themedir .. "/taglist14/square.png"

theme.tasklist_floating_icon = sharedthemes .. "/default/tasklist/floatingw.png"

theme.menu_submenu_icon      = sharedthemes .. "/default/submenu.png"
theme.menu_height   = "15"
theme.menu_width    = "100"

-- Define the image to load
theme.titlebar_close_button_normal              = sharedthemes .. "/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = sharedthemes .. "/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive     = sharedthemes .. "/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = sharedthemes .. "/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = sharedthemes .. "/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = sharedthemes .. "/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = sharedthemes .. "/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = sharedthemes .. "/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = sharedthemes .. "/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = sharedthemes .. "/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = sharedthemes .. "/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = sharedthemes .. "/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = sharedthemes .. "/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = sharedthemes .. "/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = sharedthemes .. "/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = sharedthemes .. "/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = sharedthemes .. "/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = sharedthemes .. "/default/titlebar/maximized_focus_active.png"

theme.layout_fairh                              = layoutdir .. "/block_layouts/fairhw.png"
theme.layout_fairv                              = layoutdir .. "/block_layouts/fairvw.png"
theme.layout_floating                           = layoutdir .. "/block_layouts/floatingw.png"
theme.layout_magnifier                          = layoutdir .. "/block_layouts/magnifierw.png"
theme.layout_max                                = layoutdir .. "/block_layouts/maxw.png"
theme.layout_fullscreen                         = layoutdir .. "/block_layouts/fullscreenw.png"
theme.layout_tilebottom                         = layoutdir .. "/block_layouts/tilebottomw.png"
theme.layout_tileleft                           = layoutdir .. "/block_layouts/tileleftw.png"
theme.layout_tile                               = layoutdir .. "/block_layouts/tilew.png"
theme.layout_tiletop                            = layoutdir .. "/block_layouts/tiletopw.png"
theme.layout_spiral                             = layoutdir .. "/block_layouts/spiralw.png"
theme.layout_dwindle                            = layoutdir .. "/block_layouts/dwindlew.png"
theme.layout_cascade                            = layoutdir .. "/block_layouts/cascade.png"
theme.layout_cascadetile                      = layoutdir .. "/block_layouts/cascadebrowsw.png"
theme.layout_centerwork                         = layoutdir .. "/block_layouts/centerwork.png"
theme.layout_termfair                           = layoutdir .. "/block_layouts/termfair.png"


theme.awesome_icon = themedir .. "/awesome14-dust.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
