zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" zdharma/fast-syntax-highlighting \
  blockf zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start; export ZSH_AUTOSUGGEST_USE_ASYNC=1" zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab \
  MichaelAquilina/zsh-autoswitch-virtualenv \
  laggardkernel/git-ignore \
  zpm-zsh/ssh \
  lukechilds/zsh-nvm \
  Ynjxsjmh/zsh-poetry \
  maximux13/zsh-auto-source-file \
  Albatrosicks/go-task-completions \
  joshskidmore/zsh-fzf-history-search \
  akoenig/npm-run.plugin.zsh \
  zsh-users/zsh-syntax-highlighting \
  atload"typeset -g ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT='true'" kutsan/zsh-system-clipboard

zinit ice wait"2" as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

zinit ice from"gh-r" as"program" atload'eval "$(starship init zsh)"'
zinit load starship/starship


autoload -Uz compinit
compinit
zinit cdreplay -q
