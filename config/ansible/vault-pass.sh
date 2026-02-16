#!/usr/bin/env bash

[[ -n $(logname >/dev/null 2>&1) ]] && logged_in_user=$(logname) || logged_in_user=$(whoami)


if [[ ! $(uname) = "Darwin" ]]; then
	echo "This script is for macOS only."
	exit 1
fi

security find-generic-password \
  -a $logged_in_user \
  -s ansible-vault -w
