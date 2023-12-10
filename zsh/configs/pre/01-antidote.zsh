source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
ZSH="$(antidote home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
export NVM_COMPLETION=true
export NVM_AUTO_USE=true
export NVM_LAZY_LOAD=true
if [ -f "$HOME/.zsh_plugins.zsh" ]; then
  antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
else
  source $HOME/.zsh_plugins.zsh
fi
