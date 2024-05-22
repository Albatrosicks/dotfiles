zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" zdharma/fast-syntax-highlighting \
  blockf zsh-users/zsh-completions \
  greymd/docker-zsh-completion \
  srijanshetty/zsh-pip-completion \
  esc/conda-zsh-completion \
  zpm-zsh/ssh \
  Ynjxsjmh/zsh-poetry \
  Albatrosicks/go-task-completions \
  lukechilds/zsh-nvm \
  lukechilds/zsh-better-npm-completion \
  atload"!_zsh_autosuggest_start; export ZSH_AUTOSUGGEST_USE_ASYNC=1" zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab \
  MichaelAquilina/zsh-autoswitch-virtualenv \
  MichaelAquilina/zsh-you-should-use \
  laggardkernel/git-ignore \
  maximux13/zsh-auto-source-file \
  joshskidmore/zsh-fzf-history-search \
  akoenig/npm-run.plugin.zsh \
  zsh-users/zsh-syntax-highlighting \
  atload"typeset -g ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT='true'" kutsan/zsh-system-clipboard

zinit ice wait"2" as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

autoload -Uz compinit
compinit
zinit cdreplay -q

eval "$(starship init zsh)"
