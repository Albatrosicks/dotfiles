# load our own completion functions
fpath=($HOME/.zsh/completion /usr/local/share/zsh/site-functions $fpath)
fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.0/contrib/zsh $fpath)
fpath=(/opt/homebrew/Cellar/helix/*/share/zsh/site-functions $fpath)
fpath=(/opt/homebrew/Cellar/m-cli/*/share/zsh/site-functions $fpath)
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)
export -U fpath
