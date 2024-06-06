sketchybar -m --add item topmem_app right \
              --set topmem_app label.font="$FONT:Regular:7.0" \
                                    y_offset=5 \
                                    update_freq=1 \
                                    script="~/.config/sketchybar/plugins/topmem.sh" \ 
\
              --add item ram_percentage right \
              --set ram_percentage label.font="$FONT:Regular:7.0" \
                                    y_offset=-4 \
                                    update_freq=1 \
                                    script="~/.config/sketchybar/plugins/ram.sh"
