#!/bin/bash

# Script to check qutebrowser version and update QtWebEngineCore framework
# to enable proprietary codec support

# Paths
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/$(basename "$0")"
LOG_FILE="$HOME/Library/Logs/qutebrowser-codec-updater.log"
PLIST_FILE="$HOME/Library/LaunchAgents/com.user.qutebrowser.codec.updater.plist"

# Function to limit log file size to 100 lines
limit_log_file() {
  if [ -f "$LOG_FILE" ]; then
    # Count current lines in log file
    local line_count=$(wc -l < "$LOG_FILE")

    # If more than 100 lines, keep only the last 100
    if [ "$line_count" -gt 100 ]; then
      echo "Rotating log file, keeping last 100 lines"
      # Create temporary file with last 100 lines
      tail -n 100 "$LOG_FILE" > "${LOG_FILE}.tmp"
      # Replace original file
      mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
  fi
}

# Run log rotation before adding new entries
limit_log_file

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
  echo "$1"
}

# Check if running as LaunchAgent or from CLI
install_as_launch_agent() {
  if [ ! -f "$PLIST_FILE" ]; then
    log_message "Installing script as LaunchAgent..."

    # Create LaunchAgent directory if it doesn't exist
    mkdir -p "$HOME/Library/LaunchAgents"

    # Create plist file
    cat > "$PLIST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.qutebrowser.codec.updater</string>
    <key>ProgramArguments</key>
    <array>
        <string>${SCRIPT_PATH}</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>StartInterval</key>
    <integer>86400</integer>
    <key>StandardErrorPath</key>
    <string>${HOME}/Library/Logs/qutebrowser-codec-updater-error.log</string>
    <key>StandardOutPath</key>
    <string>${HOME}/Library/Logs/qutebrowser-codec-updater-output.log</string>
</dict>
</plist>
EOF

    # Load the LaunchAgent
    launchctl load "$PLIST_FILE"

    log_message "LaunchAgent installed and loaded. Script will run at boot and daily."
    osascript -e 'display notification "qutebrowser codec updater has been installed as a LaunchAgent" with title "qutebrowser codec updater"'
  fi
}

# Check if script is being run directly (not via LaunchAgent)
if [[ "$PPID" != "1" ]]; then
  install_as_launch_agent
fi

log_message "Starting qutebrowser codec update check"

# Get installed qutebrowser version
QUTE_VERSION_OUTPUT=$(/Applications/qutebrowser.app/Contents/MacOS/qutebrowser --version 2>/dev/null)
if [ $? -ne 0 ]; then
  log_message "Failed to get qutebrowser version"
  exit 1
fi

# Extract version number
QUTE_VERSION=$(echo "$QUTE_VERSION_OUTPUT" | grep "qutebrowser v" | cut -d " " -f 2)
log_message "Current qutebrowser version: $QUTE_VERSION"

# Extract Qt version from qutebrowser
QUTE_QT_VERSION=$(echo "$QUTE_VERSION_OUTPUT" | grep "Qt:" | cut -d " " -f 2)
log_message "Qt version in qutebrowser: $QUTE_QT_VERSION"

# Check for stored previous version
VERSION_FILE="$HOME/.qutebrowser/last_patched_version"
if [ -f "$VERSION_FILE" ]; then
  LAST_VERSION=$(cat "$VERSION_FILE")
  log_message "Last patched version: $LAST_VERSION"
else
  LAST_VERSION=""
  log_message "No previous version recorded"
fi

# Get Homebrew Qt version
if ! command -v brew &> /dev/null; then
  log_message "Homebrew is not installed"
  exit 1
fi

BREW_QT_PATH=$(brew --prefix qt)
if [ ! -d "$BREW_QT_PATH" ]; then
  log_message "Qt is not installed via Homebrew"
  exit 1
fi

BREW_QT_VERSION=$(brew info qt --json | grep -o '"installed":.*,"linked"' | grep -o '"[0-9.]*"' | tr -d '"')
log_message "Homebrew Qt version: $BREW_QT_VERSION"

# Check if version changed (meaning qutebrowser was updated)
if [ "$QUTE_VERSION" == "$LAST_VERSION" ]; then
  log_message "No qutebrowser update detected, skipping"
  exit 0
fi

# Check if Qt versions are compatible
QUTE_QT_MAJOR=$(echo "$QUTE_QT_VERSION" | cut -d. -f1)
BREW_QT_MAJOR=$(echo "$BREW_QT_VERSION" | cut -d. -f1)

if [ "$QUTE_QT_MAJOR" != "$BREW_QT_MAJOR" ]; then
  log_message "Qt version mismatch: qutebrowser uses Qt $QUTE_QT_VERSION but Homebrew has Qt $BREW_QT_VERSION"
  exit 1
fi

# Check if qutebrowser is running
if pgrep -x "qutebrowser" > /dev/null; then
  log_message "qutebrowser is currently running"
  osascript -e 'display notification "Please restart qutebrowser to apply codec support" with title "qutebrowser codec updater"'
fi

# Perform the QtWebEngineCore framework replacement
QUTE_FRAMEWORK_PATH="/Applications/qutebrowser.app/Contents/Frameworks/PyQt6/Qt6/lib/QtWebEngineCore.framework"
BREW_FRAMEWORK_PATH="$BREW_QT_PATH/lib/QtWebEngineCore.framework"

if [ ! -d "$BREW_FRAMEWORK_PATH" ]; then
  log_message "Cannot find QtWebEngineCore.framework in Homebrew Qt"
  exit 1
fi

# Backup original framework if it's the first time
BACKUP_PATH="/Applications/qutebrowser.app/Contents/Frameworks/PyQt6/Qt6/lib/QtWebEngineCore.framework.original"
if [ ! -d "$BACKUP_PATH" ] && [ -d "$QUTE_FRAMEWORK_PATH" ]; then
  log_message "Creating backup of original framework"
  cp -R "$QUTE_FRAMEWORK_PATH" "$BACKUP_PATH"
fi

# Remove existing framework and copy the one with codec support
log_message "Removing existing QtWebEngineCore.framework"
rm -rf "$QUTE_FRAMEWORK_PATH"

log_message "Copying QtWebEngineCore.framework from Homebrew"
cp -R "$BREW_FRAMEWORK_PATH" "$QUTE_FRAMEWORK_PATH"

if [ $? -eq 0 ]; then
  log_message "Successfully replaced QtWebEngineCore.framework"
  # Update the version file
  mkdir -p "$HOME/.qutebrowser"
  echo "$QUTE_VERSION" > "$VERSION_FILE"

  # Notify user
  osascript -e 'display notification "Proprietary codec support has been enabled for qutebrowser" with title "qutebrowser codec updater"'
else
  log_message "Failed to replace QtWebEngineCore.framework"
  osascript -e 'display notification "Failed to enable proprietary codec support" with title "qutebrowser codec updater" subtitle "Check logs for details"'
  exit 1
fi

log_message "Finished qutebrowser codec update process"
exit 0

