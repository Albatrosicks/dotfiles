#!/bin/bash

current_layout=$(macism)

if [ "$current_layout" == "com.apple.keylayout.ABC" ]
then
  macism com.apple.keylayout.Russian
elif [ "$current_layout"  == "com.apple.keylayout.Russian" ]
then
  macism com.apple.keylayout.ABC
else
  echo "Unknown layout: $current_layout"
fi
