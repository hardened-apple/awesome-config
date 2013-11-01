#!/usr/bin/sh

setupnew () {
    ln -sf $1 ~/.config/awesome/rc.lua
    xrdb -load ~/xresources/base_resources
    xrdb -merge $2
}

# Define the rc locations
SHIFTYRC=/home/apple/.config/awesome/the_rcs/shifty.lua
HOLORC=/home/apple/.config/awesome/the_rcs/holo.lua
DUSTRC=/home/apple/.config/awesome/the_rcs/dust.lua
MULTICOLORRC=/home/apple/.config/awesome/the_rcs/multicolor.lua
STEAMBURNRC=/home/apple/.config/awesome/the_rcs/steamburn.lua
MUTEDRC=/home/apple/.config/awesome/the_rcs/muted.lua
MAINRC=/home/apple/.config/awesome/the_rcs/main.lua


# Define the xresources colour locations
SHIFTYCOLS=/home/apple/xresources/awesome_personal_resources
HOLOCOLS=/home/apple/xresources/holo
DUSTCOLS=/home/apple/xresources/vinyl
MULTICOLORCOLS=/home/apple/xresources/dremora
STEAMBURNCOLS=/home/apple/xresources/steamburn
MUTEDCOLS=/home/apple/xresources/awesome_muted_resources
MAINCOLS=/home/apple/xresources/awesome_personal_resources

case $1 in
    "shifty")  
        setupnew $SHIFTYRC $SHIFTYCOLS
        ;;

    "holo")
        setupnew $HOLORC $HOLOCOLS
        ;;

    "dust")  
        setupnew $DUSTRC $DUSTCOLS
        ;;

    "multicolor")  
        setupnew $MULTICOLORRC $MULTICOLORCOLS
        ;;

    "steamburn")  
        setupnew $STEAMBURNRC $STEAMBURNCOLS
        ;;

    "muted")  
        setupnew $MUTEDRC $MUTEDCOLS
        ;;

    "main")  
        setupnew $MAINRC $MAINCOLS
        ;;
esac
