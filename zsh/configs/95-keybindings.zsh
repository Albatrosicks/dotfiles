bindkey -e
setopt EMACS
autoload -U select-word-style
select-word-style bash

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
