# load our own completion functions
fpath=($HOME/.zsh/completion /usr/local/share/zsh/site-functions $fpath)
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
_zcompcache="${ZDOTDIR:-$HOME}/.zcompcache"
# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_files=($_zcompdump(Nmh-20))
if (( $#_comp_files )); then
  compinit -i -C -d "$_zcompdump"
else
  compinit -i -d "$_zcompdump"
  # Keep $_zcompdump younger than cache time even if it isn't regenerated.
  touch "$_zcompdump"
fi
# disable zsh bundled function mtools command mcd
# which causes a conflict.
compdef -d mcd

#
# Cleanup
#

unset _cache_dir _comp_files _zcompdump _zcompcache
