sketchybar -m --add item topmem right \
              --set topmem label.font="$FONT:Semibold:7.0" \
                               y_offset=6 \
                               width=0 \
                               script="~/.config/sketchybar/plugins/topmem.sh" \
\
              --add item ram_percentage right \
              --set ram_percentage label.font="$FONT:Heavy:12.0" \
                                    y_offset=-4 \
                                    update_freq=1 \
                                    mach_helper="$HELPER"
                                    script="~/.config/sketchybar/plugins/ram.sh"
