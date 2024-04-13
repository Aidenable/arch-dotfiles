#!/usr/bin/env sh

# Author:
# https://github.com/prasanthrangan/hyprdots/blob/main/Configs/.config/hyprdots/scripts/brightnesscontrol.sh

function print_error {
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

function send_notification {
    brightness=`brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat`
    brightinfo=$(brightnessctl info | awk -F "'" '/Device/ {print $2}')
    angle="$(((($brightness + 2) / 5) * 5))"
    ico="~/.config/dunst/icons/vol/vol-${angle}.svg"
    bar=$(seq -s "." $(($brightness / 15)) | sed 's/[0-9]//g')
    notify-send -a "t2" -r 91190 -t 800 -i "${ico}" "${brightness}${bar}" "${brightinfo}"
}

function get_brightness {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i)
    if [[ $(get_brightness) -lt 10 ]] ; then
        brightnessctl set +1%
    else
        brightnessctl set +5%
    fi
    # send_notification ;;
    ;; 
d)
    if [[ $(get_brightness) -le 1 ]] ; then
        brightnessctl set 1%
    elif [[ $(get_brightness) -le 10 ]] ; then
        brightnessctl set 1%-
    else
        brightnessctl set 5%-
    fi
    # send_notification ;;
    ;;
*)
    print_error ;;
esac

