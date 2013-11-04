#!/usr/bin/sh

setupnew () {
    ln -sf $1 ~/.config/awesome/rc.lua
    xrdb -load ~/xresources/base_resources
    xrdb -merge $2
}

# Define the rc locations
SHIFTYRC=~/.config/awesome/the_rcs/shifty.lua
HOLORC=~/.config/awesome/the_rcs/holo.lua
DUSTRC=~/.config/awesome/the_rcs/dust.lua
MULTICOLORRC=~/.config/awesome/the_rcs/multicolor.lua
STEAMBURNRC=~/.config/awesome/the_rcs/steamburn.lua
MUTEDRC=~/.config/awesome/the_rcs/muted.lua
MAINRC=~/.config/awesome/the_rcs/main.lua


# Define the xresources colour locations
SHIFTYCOLS=~/xresources/awesome_personal_resources
HOLOCOLS=~/xresources/holo
DUSTCOLS=~/xresources/vinyl
MULTICOLORCOLS=~/xresources/dremora
STEAMBURNCOLS=~/xresources/steamburn
MUTEDCOLS=~/xresources/awesome_muted_resources
MAINCOLS=~/xresources/awesome_personal_resources

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
