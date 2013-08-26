-- muted-dream-tree, awesome3 theme, by him

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
themename     = "/muted-dream-tree"
themedir      = themes .. themename

theme.wallpaper    = themedir .. "/background.png"
--}}}

theme.font          = "terminus 8"
theme.name          = "muted"

theme.useless_gap_width  = "3"

theme.bg_normal     = "#22231F"
theme.bg_focus      = "#22231F"
theme.bg_urgent     = "#000000"
theme.bg_minimize   = "#000000"

theme.fg_normal     = "#6F7567"
theme.fg_focus      = "#DFDFB3"
theme.fg_urgent     = "#000000"
theme.fg_minimize   = "#000000"

theme.border_width  = "0"
theme.border_normal = "#000000"
theme.border_focus  = "#000000"
theme.border_marked = "#000000"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel    = sharedthemes .. "/default/taglist/squarefw.png"
theme.taglist_squares_unsel  = sharedthemes .. "/default/taglist/squarew.png"

theme.tasklist_floating_icon = sharedthemes .. "/default/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = sharedthemes .. "/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal               = sharedthemes .. "/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus                = sharedthemes .. "/default/titlebar/close_focus.png"

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

-- You can use your own layout icons like this:
theme.layout_fairh               = layoutdir .. "/block_layouts/fairhw.png"
theme.layout_fairv               = layoutdir .. "/block_layouts/fairvw.png"
theme.layout_floating            = layoutdir .. "/block_layouts/floatingw.png"
theme.layout_magnifier           = layoutdir .. "/block_layouts/magnifierw.png"
theme.layout_max                 = layoutdir .. "/block_layouts/maxw.png"
theme.layout_fullscreen          = layoutdir .. "/block_layouts/fullscreenw.png"
theme.layout_tilebottom          = layoutdir .. "/block_layouts/tilebottomw.png"
theme.layout_tileleft            = layoutdir .. "/block_layouts/tileleftw.png"
theme.layout_tile                = layoutdir .. "/block_layouts/tilew.png"
theme.layout_tiletop             = layoutdir .. "/block_layouts/tiletopw.png"
theme.layout_spiral              = layoutdir .. "/block_layouts/spiralw.png"
theme.layout_dwindle             = layoutdir .. "/block_layouts/dwindlew.png"
theme.layout_cascade             = layoutdir .. "/block_layouts/cascade.png"
theme.layout_cascadetile         = layoutdir .. "/block_layouts/cascadebrowse.png"
theme.layout_centerwork          = layoutdir .. "/block_layouts/centerwork.png"
theme.layout_termfair            = layoutdir .. "/block_layouts/termfair.png"
-- theme.layout_tilegaps            = layoutdir .. "/block_layouts/tilegaps.png"
-- theme.layout_tilegapsbottom      = layoutdir .. "/block_layouts/tilegapsbottom.png"
-- theme.layout_tilegapstop         = layoutdir .. "/block_layouts/cascade.png"
-- theme.layout_fairgaps            = layoutdir .. "/block_layouts/cascade.png"
-- theme.layout_fairgapshorizontal  = layoutdir .. "/block_layouts/cascade.png"
-- theme.layout_spiralgaps          = layoutdir .. "/block_layouts/cascade.png"

theme.awesome_icon = sharedicons .. "/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
