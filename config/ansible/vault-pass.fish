#!/usr/bin/env fish
security find-generic-password -s "ansible-vault" -a "$USER" -w | string trim
