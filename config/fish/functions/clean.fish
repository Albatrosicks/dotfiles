function _clean_cache_folder --argument-names folder_path message
    echo -e "\e[1;32m(•_•) > $message\e[0m"

    if test -d $folder_path
        set owner (stat -f%u:%g $folder_path)
        set perm (stat -f%Mp%Lp $folder_path)
        sudo rm -rf $folder_path
        and sudo mkdir -p $folder_path
        and sudo chown $owner $folder_path
        and sudo chmod $perm $folder_path
        and echo "$message successfully cleared"
        or echo "Cannot remove $message"
    end
end

function clean_brew --argument-names force_flag
    echo -e "\e[1;32m(•_•) > Cleaning brew...\e[0m"

    if string match -q "*--force*" $force_flag
        brew cleanup -s --prune=0
    else
        brew cleanup -s
    end
    brew doctor
    brew missing
end

function clean_docker
    echo -e "\e[1;32m(•_•) > Cleaning Docker...\e[0m"
    docker images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 docker pull
end

function clean_telegram
    echo -e "\e[1;32m(•_•) > Cleaning Telegram media cache...\e[0m"

    pkill -9 Telegram 2>/dev/null; and echo 'Telegram has been closed'; or echo 'Telegram process is not running'

    set telegramfolder (find ~/Library/Group\ Containers -type d -maxdepth 1 -name "*.keepcoder.Telegram" 2>/dev/null)
    if test -n "$telegramfolder"
        set telegramaccountfolder (find "$telegramfolder/stable" -type d -maxdepth 1 -name "account-*" 2>/dev/null)
        if test -n "$telegramaccountfolder"
            _clean_cache_folder "$telegramaccountfolder/postbox/media" "Telegram media cache"
        end
    end
end

function clean_cocoapods_cache
    _clean_cache_folder "$HOME/Library/Caches/CocoaPods" "Cocoapods cache"
end

function clean_carthage_cache
    _clean_cache_folder "$HOME/Library/Caches/org.carthage.CarthageKit" "Carthage cache"
end

function clean_brew_cache
    _clean_cache_folder "$HOME/Library/Caches/Homebrew" "Homebrew cache"
end

function clean_brew_logs
    _clean_cache_folder "$HOME/Library/Logs/Homebrew" "Homebrew logs"
end

function clean_npm_cache
    _clean_cache_folder "$HOME/.npm" "npm cache"
end

function clean_yarn_cache
    _clean_cache_folder "$HOME/Library/Caches/Yarn" "yarn cache"
end

function clean_nvm_cache
    echo -e "\e[1;32m(•_•) > Cleaning nvm cache...\e[0m"
    nvm cache clear
    nvm use system >/dev/null 2>&1
end

function clean_xcode_cache
    echo -e "\e[1;32m(•_•) > Cleaning Xcode cache...\e[0m"
    pkill -9 Xcode 2>/dev/null

    _clean_cache_folder "$HOME/Library/Developer/CoreSimulator/Caches/dyld" "Xcode cache"
    _clean_cache_folder "$HOME/Library/Developer/Xcode/Archives" "Xcode archives"
    _clean_cache_folder "$HOME/Library/Developer/Xcode/DerivedData" "Xcode Derived Data"
end

function clean_browsers_cache
    echo -e "\e[1;32m(•_•) > Cleaning browser caches...\e[0m"

    pkill -9 "Google Chrome" 2>/dev/null
    _clean_cache_folder "$HOME/Library/Caches/Google/Chrome" "Google Chrome cache"

    pkill -9 Chromium 2>/dev/null
    _clean_cache_folder "$HOME/Library/Caches/Chromium" "Chromium cache"

    pkill -9 Firefox 2>/dev/null
    _clean_cache_folder "$HOME/Library/Caches/Firefox" "Firefox cache"
end

function clean_discord_cache
    pkill -9 Discord 2>/dev/null
    _clean_cache_folder "$HOME/Library/Application Support/discord" "Discord cache"
end

function clean_spotify_cache
    pkill -9 Spotify 2>/dev/null
    _clean_cache_folder "$HOME/Library/Application Support/Spotify/PersistentCache/Storage" "Spotify cache"
end

function clean_vscode_cache
    pkill -9 Electron 2>/dev/null
    _clean_cache_folder "$HOME/Library/Application Support/Code/Cache" "Visual Studio Code cache"
end

function clean --description "Clean various caches and temporary files"
    if test (count $argv) -eq 0
        clean_brew
        clean_docker
    else
        for arg in $argv
            switch $arg
                case --brew
                    clean_brew $arg
                case --docker
                    clean_docker
                case --telegram
                    clean_telegram
                case --force
                    clean_telegram
                case "*"
                    echo "Invalid parameter: $arg"
            end
        end
    end
end
