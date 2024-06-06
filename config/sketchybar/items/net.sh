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

network_sys=(
  width=0
  graph.color=$RED
  graph.fill_color=$RED
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

network_user=(
  graph.color=$BLUE
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

sketchybar --add item network.down right             \
           --set network.down "${network_down[@]}"   \
                                                    \
           --add item network.up right               \
           --set network.up "${network_up[@]}"       \
                                                    \
           --add graph network.sys right 75          \
           --set network.sys "${network_sys[@]}"     \
                                                    \
           --add graph network.user right 75         \
           --set network.user "${network_user[@]}"
