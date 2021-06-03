#!/bin/bash

## Author : Aditya Shakya
## Github : adi1090x
# Custom Rofi Script

SDIR="$HOME/.config/polybar/scripts"

# Launch Rofi
MENU="$(rofi -no-lazy-grab -sep "|" -dmenu -i -p 'style' \
-hide-scrollbar true \
-bw 0 \
-lines 5 \
-line-padding 10 \
-padding 20 \
-width 30 \
-xoffset 8 -yoffset 32 \
-location 1 \
-columns 2 \
-show-icons -icon-theme "Papirus" \
-theme $HOME/.config/rofi/menu.rasi \
<<< "♥ amber|♥ blue|♥ blue-grey|♥ brown|♥ cyan|♥ deep-orange|♥ deep-purple|♥ green|♥ grey|♥ indigo|♥ blue-light|♥ green-light|♥ lime|♥ orange|♥ pink|♥ purple|♥ red|♥ teal|♥ yellow|♥ amber-dark|♥ blue-dark|♥ blue-grey-dark|♥ brown-dark|♥ cyan-dark|♥ deep-orange-dark|♥ deep-purple-dark|♥ green-dark|♥ grey-dark|♥ indigo-dark|♥ blue-light-dark|♥ green-light-dark|♥ lime-dark|♥ orange-dark|♥ pink-dark|♥ purple-dark|♥ red-dark|♥ teal-dark|♥ yellow-dark")"
case "$MENU" in
				## Light Colors
				*amber) $SDIR/colors-light.sh -amber ;;
				*blue) $SDIR/colors-light.sh -blue ;;
				*blue-grey) $SDIR/colors-light.sh -blue-grey ;;
				*brown) $SDIR/colors-light.sh -brown ;;
				*cyan) $SDIR/colors-light.sh -cyan ;;
				*deep-orange) $SDIR/colors-light.sh -deep-orange ;;
				*deep-purple) $SDIR/colors-light.sh -deep-purple ;;
				*green) $SDIR/colors-light.sh -green ;;
				*grey) $SDIR/colors-light.sh -grey ;;
				*indigo) $SDIR/colors-light.sh -indigo ;;
				*blue-light) $SDIR/colors-light.sh -light-blue ;;
				*green-light) $SDIR/colors-light.sh -light-green ;;
				*lime) $SDIR/colors-light.sh -lime ;;
				*orange) $SDIR/colors-light.sh -orange ;;
				*pink) $SDIR/colors-light.sh -pink ;;
				*purple) $SDIR/colors-light.sh -purple ;;
				*red) $SDIR/colors-light.sh -red ;;
				*teal) $SDIR/colors-light.sh -teal ;;
				*yellow) $SDIR/colors-light.sh -yellow ;;
				## Dark Colors
				*amber-dark) $SDIR/colors-dark.sh -amber ;;
				*blue-dark) $SDIR/colors-dark.sh -blue ;;
				*blue-grey-dark) $SDIR/colors-dark.sh -blue-grey ;;
				*brown-dark) $SDIR/colors-dark.sh -brown ;;
				*cyan-dark) $SDIR/colors-dark.sh -cyan ;;
				*deep-orange-dark) $SDIR/colors-dark.sh -deep-orange ;;
				*deep-purple-dark) $SDIR/colors-dark.sh -deep-purple ;;
				*green-dark) $SDIR/colors-dark.sh -green ;;
				*grey-dark) $SDIR/colors-dark.sh -grey ;;
				*indigo-dark) $SDIR/colors-dark.sh -indigo ;;
				*blue-light-dark) $SDIR/colors-dark.sh -light-blue ;;
				*green-light-dark) $SDIR/colors-dark.sh -light-green ;;
				*lime-dark) $SDIR/colors-dark.sh -lime ;;
				*orange-dark) $SDIR/colors-dark.sh -orange ;;
				*pink-dark) $SDIR/colors-dark.sh -pink ;;
				*purple-dark) $SDIR/colors-dark.sh -purple ;;
				*red-dark) $SDIR/colors-dark.sh -red ;;
				*teal-dark) $SDIR/colors-dark.sh -teal ;;
				*yellow-dark) $SDIR/colors-dark.sh -yellow
esac
