# completions/up.fish
complete -c up -f

complete -c up -l dotfiles -d "Update dotfiles config"
complete -c up -l brew -d "Update brew packages"
complete -c up -l appstore -d "Update AppStore apps"
complete -c up -l fish -d "Update fish plugins"
complete -c up -l uv-tool -d "Update uv tool packages"
complete -c up -l verbose -d "Update with advanced output"
