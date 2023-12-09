# To opt in to Homebrew analytics, `unset` this in ~/.zshrc.local .
# Learn more about what you are opting in to at
# https://docs.brew.sh/Analytics
export HOMEBREW_NO_ANALYTICS=1

# Enable autoupdate
export DISABLE_AUTO_UPDATE="false"

# Disable y/n prompting on update
export DISABLE_UPDATE_PROMPT="true"

# Set autoupdate period to 1h
if [[ ! -f "~/Library/LaunchAgents/com.github.domt4.homebrew-autoupdate.plist" && $(brew autoupdate status) == *"is not configured"* ]]; then
  brew autoupdate start 3600
fi
