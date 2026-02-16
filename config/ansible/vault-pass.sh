#!/usr/bin/env bash

# $USER
[[ -n $(logname >/dev/null 2>&1) ]] && logged_in_user=$(logname) || logged_in_user=$(whoami)

# check os
if [[ ! $(uname) = "Darwin" ]]; then
	echo "This script is for macOS only."
	exit 1
fi

add_keychain_password() {
	local mypass
	read -s -p "Enter ansible vault password: " mypass
	security add-generic-password \
		-a "$logged_in_user" \
		-s "ansible-vault" \
		-w "$mypass" \
		-T "/usr/bin/security"
}

check_app_password() {
	app_password=$(security find-generic-password \
		-a "$logged_in_user" \
		-s "ansible-vault" -w 2>&1 >/dev/null)
	rc=$(echo $?)
	if [[ $rc -ne 0 ]]; then
		echo "No password found in keychain. "
		add_keychain_password
	fi
}

print_vault_password() {
	security find-generic-password \
		-a $logged_in_user \
		-s ansible-vault -w 2>/dev/null | tr -d '\n'
}

main() {
	check_app_password
	print_vault_password
}
main

exit 0
