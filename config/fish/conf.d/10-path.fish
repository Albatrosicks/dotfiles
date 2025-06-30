# Set Homebrew prefix
if test (uname) = Darwin
    if test (uname -m) = arm64
        set BREW_PREFIX /opt/homebrew
    else
        set BREW_PREFIX /usr/local
    end
else
    set BREW_PREFIX "/home/linuxbrew/.linuxbrew"
end

# Set GOPATH
set -gx GOPATH ~/go

# Build PATH with proper precedence (first entries have highest priority)
set -gx PATH \
    $BREW_PREFIX/bin \
    $BREW_PREFIX/sbin \
    $BREW_PREFIX/opt/coreutils/libexec/gnubin \
    $BREW_PREFIX/opt/gnu-tar/libexec/gnubin \
    $BREW_PREFIX/opt/make/libexec/gnubin \
    $BREW_PREFIX/opt/gawk/libexec/gnubin \
    $BREW_PREFIX/opt/python/libexec/bin \
    ~/.cargo/bin \
    $GOPATH/bin \
    ~/.local/bin \
    $HOME/.asdf/shims \
    /usr/local/bin \
    /usr/sbin \
    /sbin \
    /usr/bin \
    /bin
