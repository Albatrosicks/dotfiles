zinit load gangleri/pipenv

zinit load lukechilds/zsh-better-npm-completion
zinit load greymd/docker-zsh-completion
zinit load srijanshetty/zsh-pip-completion
zinit load esc/conda-zsh-completion
zinit load MichaelAquilina/zsh-autoswitch-virtualenv
zinit load laggardkernel/git-ignore
zinit load zpm-zsh/ssh
zinit load lukechilds/zsh-nvm
zinit load Ynjxsjmh/zsh-poetry
zinit load maximux13/zsh-auto-source-file
zinit load Albatrosicks/go-task-completions
zinit ice src"contrib/completion/hx.zsh"
zinit load helix-editor/helix
zinit ice src"completion/zsh/_m"
zinit load rgcr/m-cli
zinit load joshskidmore/zsh-fzf-history-search

# initilize broken complitions (doesn't work before plugin manager)
zinit load akoenig/npm-run.plugin.zsh

zinit load zsh-users/zsh-completions
zinit load Aloxaf/fzf-tab
zinit load zsh-users/zsh-syntax-highlighting

autoload -Uz compinit
compinit
zinit cdreplay -q
