function update_configs
    echo -e "\e[1;32m(•_•) > Updating dotfiles config...\e[0m"
    set prev_dir (pwd)
    set username (whoami)

    cd "/Users/$username/dotfiles"; or return
    git pull; and rcup
    cd $prev_dir; or return
end

function update_qutebrowser_codecs
    test -d "/Applications/qutebrowser.app"; or return

    set qute_version (/Applications/qutebrowser.app/Contents/MacOS/qutebrowser --version 2>/dev/null | grep "qutebrowser v" | cut -d " " -f 2)
    set version_file "$HOME/.qutebrowser/last_patched_version"

    if test -f $version_file
        set last_version (cat $version_file)
    else
        set last_version ""
        mkdir -p "$HOME/.qutebrowser"
    end

    test "$qute_version" != "$last_version"; or return

    set brew_qt_path (brew --prefix qt 2>/dev/null)
    test -d "$brew_qt_path"; or return

    set qute_framework_path "/Applications/qutebrowser.app/Contents/Frameworks/PyQt6/Qt6/lib/QtWebEngineCore.framework"
    set brew_framework_path "$brew_qt_path/lib/QtWebEngineCore.framework"

    if test -d "$brew_framework_path"
        echo "Updating qutebrowser codecs..."
        rm -rf "$qute_framework_path"
        cp -R "$brew_framework_path" "$qute_framework_path"
        echo $qute_version >$version_file
    end
end

function update_brew
    echo -e "\e[1;32m(•_•) > Updating brew...\e[0m"

    command -q xcodebuild; and xcodebuild -license accept 2>/dev/null; or true

    set -gx HOMEBREW_NO_ENV_HINTS 1
    set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
    set -gx HOMEBREW_NO_INSTALL_CLEANUP 1
    set -gx ACCEPT_EULA Y

    brew update

    set outdated (brew outdated --quiet)
    if test -n "$outdated"
        echo $outdated | while read -l pkg
            brew fetch $pkg >/dev/null 2>&1; or true
        end

        brew upgrade
        update_qutebrowser_codecs
    else
        echo "No outdated packages found."
    end
end

function update_appstore_apps
    echo -e "\e[1;32m(•_•) > Updating AppStore applications...\e[0m"
    mas upgrade
end

function update_fish_plugins
    echo -e "\e[1;32m(•_•) > Updating fish plugins...\e[0m"
    if command -q fisher
        fisher update
    end
end

function update_pipx
    echo -e "\e[1;32m(•_•) > Updating pipx...\e[0m"
    pipx upgrade-all
end

function update_go_binaries
    echo -e "\e[1;32m(•_•) > Updating Go binaries...\e[0m"

    if not command -q go
        echo "Go not installed, skipping..."
        return
    end

    # Get list of installed Go binaries
    set go_bin_path (go env GOPATH 2>/dev/null; or echo ~/go)/bin
    set go_binaries (ls $go_bin_path 2>/dev/null; or echo "")

    # Define Go tools with their import paths
    set -l go_tools \
        "air:github.com/cosmtrek/air@latest" \
        "archimede:github.com/nicolasgere/archimede@latest" \
        "dlv:github.com/go-delve/delve/cmd/dlv@latest" \
        "goimports:golang.org/x/tools/cmd/goimports@latest" \
        "sqls:github.com/lighttiger2505/sqls@latest" \
        "staticcheck:honnef.co/go/tools/cmd/staticcheck@latest" \
        "templ:github.com/a-h/templ/cmd/templ@latest" \
        "golangci-lint:github.com/golangci/golangci-lint/cmd/golangci-lint@latest" \
        "godoc:golang.org/x/tools/cmd/godoc@latest" \
        "gomodifytags:github.com/fatih/gomodifytags@latest" \
        "impl:github.com/josharian/impl@latest" \
        "gotests:github.com/cweill/gotests/gotests@latest"

    for tool_entry in $go_tools
        set tool_info (string split ":" $tool_entry)
        set tool_name $tool_info[1]
        set tool_path $tool_info[2]

        if contains $tool_name $go_binaries
            echo "Updating $tool_name..."
            go install $tool_path
        else
            echo "Installing $tool_name..."
            go install $tool_path
        end
    end

    echo "Go binaries update completed."
end

function update_cargo_binaries
    echo -e "\e[1;32m(•_•) > Updating Cargo binaries...\e[0m"

    if not command -q cargo
        echo "Cargo not installed, skipping..."
        return
    end

    # Check if cargo-update is installed
    if not cargo install --list | grep -q cargo-update
        echo "Installing cargo-update for managing updates..."
        cargo install cargo-update
    end

    # Update all installed cargo binaries
    cargo install-update --all
end

function process_duti
    echo -e "\e[1;32m(•_•) > Processing duti config...\e[0m"
    # Apply Zed as default editor for text/code UTIs using duti — fish version

    set -l ZED_APP_NAME Zed
    set -l ZED_BUNDLE_ID (osascript -e "id of app \"$ZED_APP_NAME\"")
    test $status -eq 0 -a -n "$ZED_BUNDLE_ID"; or echo "Could not find $ZED_APP_NAME. Make sure it’s installed (e.g., /Applications/Zed.app)."
    echo "✅ Using $ZED_APP_NAME with bundle ID: $ZED_BUNDLE_ID"

    # --- UTI list (deduped to cover text & code) ---
    set -l UTIS \
        com.apple.traditional-mac-plain-text \
        public.text \
        public.plain-text \
        public.utf8-plain-text \
        public.utf16-plain-text \
        public.utf16-external-plain-text \
        public.source-code \
        public.script \
        public.shell-script \
        public.unix-executable \
        public.json \
        public.xml \
        public.yaml \
        org.yaml.yaml \
        com.apple.property-list \
        public.html \
        public.css \
        public.javascript \
        com.netscape.javascript-source \
        public.typescript-script \
        public.c-source \
        public.c-header \
        public.c-plus-plus-source \
        public.c-plus-plus-header \
        public.objective-c-source \
        public.objective-c-plus-plus-source \
        com.sun.java-source \
        public.java-source \
        public.swift-source \
        public.rust-source \
        org.gnu.assembly \
        public.assembly-source \
        org.gnu.emacs.lisp \
        public.python-script \
        public.ruby-script \
        public.perl-script \
        public.php-script \
        public.csh-script \
        com.apple.applescript.text \
        public.markdown \
        net.daringfireball.markdown \
        dyn.ah62d4rv4ge8044pq \
        public.makefile \
        org.gnu.gnu-make \
        public.ini-settings \
        com.microsoft.windows-ini \
        com.sun.java-properties \
        public.log \
        com.macromates.textmate.language \
        com.macromates.textmate.preferences \
        com.macromates.textmate.snippet \
        com.macromates.textmate.theme

    # --- Apply UTIs to Zed ---
    for uti in $UTIS
        echo "🔧 Setting $uti to open with $ZED_APP_NAME..."
        duti -s $ZED_BUNDLE_ID $uti all
        if test $status -ne 0
            echo "⚠️  Failed to set $uti — continuing..."
        end
    end

    # --- Extension mapping: .mdx -> Zed (duti uses extension without the dot) ---
    echo "🔧 Setting .mdx extension to open with $ZED_APP_NAME..."
    duti -s $ZED_BUNDLE_ID mdx all
    test $status -eq 0; or echo "⚠️  Failed to set .mdx"

    echo "🎉 Done! $ZED_APP_NAME is now the default editor for text/code files."
end

function up --description "Update system components"
    if test (count $argv) -eq 0
        update_configs
        update_brew
        update_appstore_apps
        update_fish_plugins
        update_go_binaries
        update_cargo_binaries
        update_pipx
        process_duti
    else
        for arg in $argv
            switch $arg
                case --dotfiles
                    update_configs
                case --brew
                    update_brew
                case --appstore
                    update_appstore_apps
                case --fish
                    update_fish_plugins
                case --go
                    update_go_binaries
                case --cargo --rust
                    update_cargo_binaries
                case --pipx
                    update_pipx
                case --duti
                    process_duti
                case "*"
                    echo "Invalid parameter: $arg"
            end
        end
    end
end
