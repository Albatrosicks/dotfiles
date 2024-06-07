sketchybar -m --add item net right \
              --set net script="~/.config/sketchybar/plugins/net.sh" \
                                background.color=0xff3B4252 \
                                background.height=20

sketchybar -m --add item net_logo right \
              --set net_logo icon= \
                        background.color=0xffB48EAD \
                        background.height=20 \
                        background.padding_left=5

sketchybar -m --add item network_up right \
              --set network_up label.font="$FONT:Regular:7.0" \
                               icon.font="$FONT:Regular:7.0" \
                               icon= \
                               icon.highlight_color=0xff8b0a0d \
                               y_offset=5 \
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
