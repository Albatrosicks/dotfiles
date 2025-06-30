# Unix
alias ll="ls -al"
alias ln="ln -v"
alias mkdir="mkdir -p"
alias e="$EDITOR"
alias v="$VISUAL"

# Remove fish's alias, which breaks completions when I add another one
functions -e diff
function diff -w diff
    command diff --color=auto -U3 $argv
end

alias qq "source ~/.config/fish/config.fish"
alias cp "cp -iv"
alias rm "rm -Iv"
alias mv "mv -iv"
alias ls "ls -FGh"
alias du "du -cksh"
alias df "df -h"
# Use modern regexps for sed, i.e. "(one|two)", not "\(one\|two\)"
alias sed "sed -E"

alias mkdir "command mkdir -p"
alias prettyjson "jq ."
# xmllint is from `brew install libxml2`
alias prettyxml "xmllint --format -"
alias prettyhtml "prettier --stdin-filepath any-name-here.html"
alias prettyjavascript "prettier --stdin-filepath any-name-here.js"
# Remove EXIF data
alias exif-remove "exiftool -all  "
alias dotfiles 'cd dotfiles'

# Note that `bat` does not understand `~`, so we need `$HOME`
set -x BAT_CONFIG_PATH "$HOME/.config/bat/config"
alias cat bat
alias less bat

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# Easier navigation: ..., ...., .....
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Include custom aliases
if test -f ~/.config/fish/aliases.local.fish
    source ~/.config/fish/aliases.local.fish
end

# Docker/Finch aliases
if test -f /usr/local/bin/finch
    alias docker=finch
    alias docker-compose="finch compose"
end

# Tool aliases
alias aider='aider --config ~/.config/aider/conf.yml'
alias forget=' remove_last_history_entry'
alias lzd='docker run --rm --privileged -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/.lzd:/.config/jesseduffield/lazydocker lazyteam/lazydocker'
alias lg='lazygit'
alias intel='arch -x86_64'
alias ez='eza --icons=auto -l -h -G'
alias proj='clear && archimede -c magenta && printf "\033[3J" && ez -T -L 2'
alias rathole='rathole -c ~/.config/rathole/client.toml'
