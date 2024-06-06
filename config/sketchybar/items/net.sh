sketchybar -m --add item network_up right \
              --set network_up label.font="$FONT:Regular:7.0" \
                               icon.font="$FONT:Regular:7.0" \
                               icon= \
                               icon.highlight_color=0xff8b0a0d \
                               y_offset=6 \
                               width=0 \
                               update_freq=1 \
                               script="~/.config/sketchybar/plugins/network.sh" \
\
              --add item network_down right \
              --set network_down label.font="$FONT:Regular:7.0" \
                                 icon.font="$FONT:Regular:7.0" \
                                 icon= \
                                 icon.highlight_color=0xff10528c \
                                 y_offset=-4 \
                                 update_freq=1
