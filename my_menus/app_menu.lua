-- automatically generated file. Do not edit (see /usr/share/doc/menu/html)

-- This line is what makes it accessible to other modules - uncomment until have made it how I want
module("my_menus.app_menu")

menu = {}


menu["Applications_Web_Browsing"] = {
    {"Firefox","/usr/bin/firefox"},
}

menu["GVim"] = {
    {"GVim","/usr/bin/gvim"},
}


menu["Applications"] = {
    { "Web Browsers", menu["Applications_Web_Browsing"] },
    { "Text Editors", menu["GVim"] },
    --{ "Torrenting", menu["Applications_Torrenting"] },
    --{ "Image Viewing", menu["Applications_Image_Viewing"] },
}


-- This was here to add another stepin case I want it at some point
-- at the moment it's superfluous and  I'll remove it
--My_menu["Applications"] = {
    --{ "Networking", My_menu["Applications_Networking"] },
    --want to add a bittorrent client here later
--}


    --Want to add an option to open this file in the editor from menu command
    --{ "Menu Config", "
    -- terminal .. " -e " .. editor .. "

