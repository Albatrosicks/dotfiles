sketchybar -m --add item ram_label right \
              --set ram_label label.font="FuraCode Nerd Font:Regular:7.0" \
                               label=RAM \
                               y_offset=5 \
                               width=0 \
\
              --add item ram_percentage right \
              --set ram_percentage label.font="FuraCode Nerd Font:Regular:7.0" \
                                    y_offset=-4 \
                                    update_freq=1 \
                                    script="~/.config/sketchybar/plugins/ram.sh"
