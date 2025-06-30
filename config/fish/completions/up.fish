# completions/up.fish
complete -c up -f

complete -c up -l dotfiles -d "Update dotfiles config"
complete -c up -l brew -d "Update brew packages"
complete -c up -l appstore -d "Update AppStore apps"
complete -c up -l fish -d "Update fish plugins"
complete -c up -l go -d "Update Go binaries"
complete -c up -l cargo -d "Update Cargo binaries"
complete -c up -l rust -d "Update Cargo binaries"
complete -c up -l pipx -d "Update pipx packages"
complete -c up -l duti -d "Process duti config"
