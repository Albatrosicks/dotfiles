sketchybar -m --add item net right \
              --set net script="~/.config/sketchybar/plugins/net.sh" \
                                background.color=0xff3B4252 \
                                background.height=20

sketchybar -m --add item network_up right \
              --set network_up label.font="$FONT:Regular:7.0" \
                               icon.font="$FONT:Regular:7.0" \
                               icon= \
                               icon.highlight_color=0xff8b0a0d \
                               y_offset=5 \
                               width=0 \
                               update_freq=1 \
                               script="~/.config/sketchybar/plugins/network.sh"
