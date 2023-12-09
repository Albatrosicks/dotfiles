# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# Try loading ASDF from the regular home dir location
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
elif which brew >/dev/null; then
  . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

if [ -d "$HOME/.deno/bin/deno" ]; then
  PATH="$HOME/.deno/bin:$PATH"
fi

if [ -d "/opt/homebrew/opt/ruby/bin/ruby" ]; then
  PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
  PATH="$HOME/go/bin:$PATH"
fi

if [ -d "/opt/homebrew/opt/python/bin" ]; then
  PATH="/opt/homebrew/opt/python/bin:$PATH"
fi

if [ -d "/opt/homebrew/opt/node/bin" ]; then
  PATH="/opt/homebrew/opt/node/bin:$PATH"
fi

if [ -d "/opt/homebrew/opt/npm/bin" ]; then
  PATH="/opt/homebrew/opt/npm/bin:$PATH"
fi

if [ -d "/opt/homebrew/opt/yarn/bin" ]; then
  PATH="/opt/homebrew/opt/yarn/bin:$PATH"
fi

if [ -d "/opt/homebrew/opt/pipx/bin" ]; then
  PATH="/opt/homebrew/opt/pipx/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

PATH="$HOME/.local/bin:$PATH"

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

export -U PATH
