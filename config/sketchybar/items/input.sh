#!/usr/bin/env sh

sketchybar --add alias "TextInputMenuAgent" right \
	--set "TextInputMenuAgent" icon.padding_left=-18 \
	--add event keyboard_change "AppleSelectedInputSourcesChangedNotification" \
	label.padding_right=-18 \
	alias.color=0xfff0f0f0 \
	background.padding_left=-1 \
	background.padding_right=-1 \
	--subscribe keyboard keyboard_change

