# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# Homebrew binaries should have priority - add early in PATH
if [[ -d "/opt/homebrew/bin/" ]]; then
  PATH="/opt/homebrew/bin:$PATH"
fi

# Add GNU versions of system utilities to override macOS versions
# These are installed by homebrew but placed in special locations
if [[ -d "/opt/homebrew/opt/coreutils/libexec/gnubin/" ]]; then
  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi

if [[ -d "/opt/homebrew/opt/gnu-tar/libexec/gnubin/" ]]; then
  PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
fi

if [[ -d "/opt/homebrew/opt/make/libexec/gnubin/" ]]; then
  PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
fi

if [[ -d "/opt/homebrew/opt/gawk/libexec/gnubin/" ]]; then
  PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
fi

# Create gcc symlink if gcc-15 exists but gcc doesn't
if [[ -e "/opt/homebrew/bin/gcc-15" ]] && [[ ! -e "/opt/homebrew/bin/gcc" ]]; then
  ln -sf /opt/homebrew/bin/gcc-15 /opt/homebrew/bin/gcc
fi

# Try loading ASDF from the regular home dir location
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
  . "$HOME/.asdf/asdf.sh"
elif which brew >/dev/null; then
  . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# Language-specific paths
if [[ -d "$HOME/.deno/bin/" ]]; then
  PATH="$HOME/.deno/bin:$PATH"
fi

if [[ -d "$HOME/go/bin/" ]]; then
  PATH="$HOME/go/bin:$PATH"
fi

if [[ -d "$HOME/.cargo/bin/" ]]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# Local binaries
PATH="$HOME/.local/bin:$PATH"

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

# Fix LIBRARY_PATH to use gcc-15 directly
export -U LIBRARY_PATH="$(brew --prefix gcc)/lib/gcc/$(gcc-15 -dumpversion 2>/dev/null || echo "15"):$LIBRARY_PATH"
export -U PATH
