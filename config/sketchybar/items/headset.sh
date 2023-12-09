#!/bin/bash

sketchybar --add alias "Control Center,Sound" e \
           --set   "Control Center,Sound" update_freq=4 \
                                          icon.drawing=off \
                                          label.drawing=off \
                                          background.padding_left=-4 \
                                          background.padding_right=-4 \
                                          click_script="$POPUP_CLICK_SCRIPT" \
                                          popup.horizontal=on \
                                          popup.align=right \
                                          popup.background.image.scale=0.5 \
                                          popup.background.color=$TRANSPARENT
