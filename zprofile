motd() {
  export PATH="/opt/local/bin:$PATH"

  if [[ "$(pwd)" == "$HOME/Sources"* ]]; then
    clear && printf "\033c"
    /opt/homebrew/bin/tree -L 2 ./
  fi

  if [[ "$1" == 'startup' && $(w -h | grep "^$(whoami) *s[^ ]* *-" -c) -eq 1 && $TERMINAL_EMULATOR != 'JetBrains-JediTerm' && $TERM_PROGRAM != "vscode" ]] || [[ "$1" == '' ]]; then
    /opt/homebrew/bin/neofetch
  fi
}

motd "startup"

if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "~/.linuxbrew" ]; then
  eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
