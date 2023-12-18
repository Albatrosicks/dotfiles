source "$HOME/.config/sketchybar/icons.sh"

sketchybar -m --add       item              headphones  right                                       \
              --set       headphones        icon=$HEADSET                                           \
                                            label.drawing=off                                       \
                                            icon.padding_right=0                                    \
                                            icon.padding_left=10                                    \
                                            script="$PLUGIN_DIR/ble_headset.sh"                     \
                                            popup.horizontal=on                                     \
                                            popup.align=center                                      \
                                            popup.height=28                                         \
                                            popup.y_offset=4                                        \
                                            update_freq=3                                           \
              --subscribe headphones        mouse.entered mouse.exited                              \
                                            mouse.exited.global                                     \
                                                                                                    \
              --add       item              headset_name popup.headphones                           \
              --set       headset_name      script="$PLUGIN_DIR/ble_headset.sh"                     \
                                            label.color=$CYAN                                       \
                                            label.padding_right=12                                  \
                                            label.padding_left=12                                   \
                                            label.drawing=off                                       \
                                            icon.drawing=off
status_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add bracket status brew github.bell wifi battery keyboard volume_icon headphones \
           --set status "${status_bracket[@]}"
