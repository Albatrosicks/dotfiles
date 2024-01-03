# load our own completion functions
fpath=($HOME/.zsh/completion /usr/local/share/zsh/site-functions $fpath)
fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.0/contrib/zsh $fpath)
export -U fpath
