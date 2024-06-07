#!/bin/bash

network_down=(
  label.font="$FONT:Semibold:7"
  label=Download
  icon.drawing=off
  width=0
  padding_right=15
  y_offset=6
  update_freq=4
  mach_helper="$HELPER"
)

network_up=(
  label.font="$FONT:Semibold:7"
  label=Upload
  icon.drawing=off
  width=0
  padding_right=15
  y_offset=6
  update_freq=4
  mach_helper="$HELPER"
)

sketchybar --add item network.down right             \
           --set network.down "${network_down[@]}"   \
                                                    \
           --add item network.up right               \
           --set network.up "${network_up[@]}"
