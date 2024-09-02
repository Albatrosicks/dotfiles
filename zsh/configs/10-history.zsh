setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096
HISTORY_IGNORE="(ls|cd|pwd|exit|ll|history|ez|eza|export)"

export ERL_AFLAGS="-kernel shell_history enabled"
