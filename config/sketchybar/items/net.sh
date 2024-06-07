#!/bin/bash

net_top=(
  label.font="$FONT:Semibold:7"
  label=NET
  icon.drawing=off
  width=0
  padding_right=15
  y_offset=6
)

net_percent=(
  label.font="$FONT:Heavy:12"
  label=NET
  y_offset=-4
  padding_right=15
  width=55
  icon.drawing=off
  update_freq=4
  mach_helper="$HELPER"
)

net_in=(
  width=0
  graph.color=$BLUE
  graph.fill_color=$BLUE
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

net_out=(
  graph.color=$RED
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

sketchybar --add item net.top right              \
           --set net.top "${net_top[@]}"         \
                                                 \
           --add item net.percent right          \
           --set net.percent "${net_percent[@]}" \
                                                 \
           --add graph net.in right 75           \
           --set net.in "${net_in[@]}"           \
                                                 \
           --add graph net.out right 75          \
           --set net.out "${net_out[@]}"
