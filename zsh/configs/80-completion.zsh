# load our own completion functions
fpath=($HOME/.zsh/completion /usr/local/share/zsh/site-functions $fpath)
fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.0/contrib/zsh $fpath)
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
export -U fpath

autoload -Uz compinit
compinit
