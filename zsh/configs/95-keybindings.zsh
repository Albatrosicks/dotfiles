autoload -Uz match-words-by-style

# Определение функции для перемещения по словам и спецсимволам
forward-word-match() {
    zle -f match
    autoload -Uz match-words-by-style
    match-words-by-style -w shell -m default
}

# Функция для перемещения назад по словам и спецсимволам
backward-word-match() {
    zle -f match
    autoload -Uz match-words-by-style
    match-words-by-style -w shell -m default -b
}
zle -N forward-word-match
zle -N backward-word-match

bindkey -e
setopt EMACS

# handy keybindings
bindkey "^K"      kill-whole-line                      # ctrl-k
bindkey "^R"      history-incremental-search-backward  # ctrl-r
bindkey "^A"      beginning-of-line                    # ctrl-a
bindkey "^E"      end-of-line                          # ctrl-e
bindkey "^P"      history-search-backward              # ctrl-p
bindkey "^Y"      accept-and-hold                      # ctrl-y
bindkey "^N"      insert-last-word                     # ctrl-n
bindkey "^D"      delete-char                          # ctrl-d
bindkey "^F"      forward-char                         # ctrl-f
bindkey "^B"      backward-char                        # ctrl-b
bindkey "^[[1;4F" forward-word-match
bindkey "^[[1;4B" backward-word-match
