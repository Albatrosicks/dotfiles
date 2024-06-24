#!/bin/bash

current_layout=$(macism)

if [ "$current_layout" == "com.apple.keylayout.USInternational-PC" ]
then
  macism com.apple.keylayout.RussianWin
elif [ "$current_layout"  == "com.apple.keylayout.RussianWin" ]
then
  macism com.apple.keylayout.USInternational-PC
else
  echo "Unknown layout: $current_layout"
fi
