#!/bin/bash
security find-generic-password -s "ansible-vault" -a "$USER" -w | tr -d '\n'
