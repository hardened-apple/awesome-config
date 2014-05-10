#!/usr/bin/sh

subtle_start () {
    xrdb -load ~/xresources/base_resources
    xrdb -merge ~/xresources/$1
    feh --bg-fill ~/.config/wallpapers/$2
    xmodmap ~/xmodmaps/xmodmap_super
    exec subtle >> ~/.cache/subtle/stdout 2>> ~/.cache/subtle/stderr
}

pek_start() {
    xrdb -load ~/xresources/base_resources
    xrdb -merge ~/xresources/$1
    feh --bg-fill ~/.config/wallpapers/$2 &
    exec pekwm --config ~/.config/pekwm/$3
}

setupnewawesome () {
    ln -sf $1 ~/.config/awesome/rc.lua
    xrdb -load ~/xresources/base_resources
    xrdb -merge $2
}

# Define the rc locations
HOLORC=~/.config/awesome/the_rcs/holo.lua
DUSTRC=~/.config/awesome/the_rcs/dust.lua
MULTICOLORRC=~/.config/awesome/the_rcs/multicolor.lua
STEAMBURNRC=~/.config/awesome/the_rcs/steamburn.lua
MUTEDRC=~/.config/awesome/the_rcs/muted.lua
MAINRC=~/.config/awesome/the_rcs/main.lua


# Define the xresources colour locations
HOLOCOLS=~/xresources/holo
DUSTCOLS=~/xresources/vinyl
MULTICOLORCOLS=~/xresources/dremora
STEAMBURNCOLS=~/xresources/steamburn
MUTEDCOLS=~/xresources/awesome_muted_resources
MAINCOLS=~/xresources/awesome_personal_resources

case $1 in
    "pek_woman")
        pek_start standard_but_calmer multiimage_woman.jpg config
        ;;

    "pek_build")
        pek_start standard_but_calmer skippin___skool_by_ether.jpg config
        ;;

     "pek_pier")
        pek_start awesome_personal_resources pier_house.jpg windmill
        ;;

    "pek_windmill")
        pek_start vinyl windmill_sillhouette.jpg windmill
        ;;

    "subtle_new")
        subtle_start awesome_personal_resources earthrise_1.jpg
        ;;

    "subtle_orig")
        subtle_start subtle_initial_resources block_colours_woman_sunglasses.jpg
        ;;


    "holo")
        setupnewawesome $HOLORC $HOLOCOLS
        ;;

    "dust")  
        setupnewawesome $DUSTRC $DUSTCOLS
        ;;

    "multicolor")  
        setupnewawesome $MULTICOLORRC $MULTICOLORCOLS
        ;;

    "steamburn")  
        setupnewawesome $STEAMBURNRC $STEAMBURNCOLS
        ;;

    "muted")  
        setupnewawesome $MUTEDRC $MUTEDCOLS
        ;;

    "main")  
        setupnewawesome $MAINRC $MAINCOLS
        ;;
esac
