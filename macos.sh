#!/usr/bin/env bash
set -euo pipefail

# Close any open System Settings panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Settings" to quit' >/dev/null 2>&1 || true

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' >/dev/null 2>&1 || true

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false

# Don’t write .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don’t offer new disks for Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Don’t open Photos when plugging in devices
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1        # Fast key repeat (lower is faster, 1 is very fast)
defaults write NSGlobalDomain InitialKeyRepeat -int 10 # Delay before repeat starts

# Disable press-and-hold for special characters, enable key repeat instead
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 32

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Don’t show recent apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Reset Dock (remove all apps)
defaults write com.apple.dock persistent-apps -array

# Add specific apps to the Dock
dock_add() {
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

dock_add "/System/Applications/Mail.app"
dock_add "/Applications/Firefox.app"
dock_add "/Applications/Ghostty.app"
dock_add "/Applications/Visual Studio Code.app"
dock_add "/Applications/Slack.app"
dock_add "/Applications/Spotify.app"

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Change indexing order and disable some search results
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
	'{"enabled" = 0;"name" = "DIRECTORIES";}' \
	'{"enabled" = 0;"name" = "PDF";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \

# Exclude folders from indexing (System Settings → Spotlight → Search Privacy).
# Needs Full Disk Access for the terminal running this script.
spotlight_plist=/System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist
spotlight_excluded() {
	sudo /usr/libexec/PlistBuddy -c "Print :Exclusions" "$spotlight_plist" 2>/dev/null | sed 's/^ *//' | grep -qxF "$1"
}
# PlistBuddy exits 0 even when it can't write, so re-read to confirm.
spotlight_exclude() {
	spotlight_excluded "$1" && return
	sudo /usr/libexec/PlistBuddy -c "Print :Exclusions" "$spotlight_plist" &>/dev/null || sudo /usr/libexec/PlistBuddy -c "Add :Exclusions array" "$spotlight_plist" &>/dev/null
	sudo /usr/libexec/PlistBuddy -c "Add :Exclusions: string $1" "$spotlight_plist" &>/dev/null
	spotlight_excluded "$1"
}

spotlight_excludes=(
	# Code and agent worktrees
	"$HOME/.claude"
	"$HOME/conductor"
	"$HOME/dev"
	"$HOME/Downloads"

	# Package managers and toolchains
	"$HOME/.bun"
	"$HOME/.cache"
	"$HOME/.npm"
	"$HOME/.nvm"
	"$HOME/Library/pnpm"

	# App data (Electron caches, app databases)
	"$HOME/Library/Application Support"
)
for dir in "${spotlight_excludes[@]}"; do
	spotlight_exclude "$dir" || echo "Couldn't exclude $dir from Spotlight (Full Disk Access?)" >&2
done
sudo killall mds >/dev/null 2>&1 || true

###############################################################################
# Siri suggestions & Apple Intelligence                                       #
###############################################################################

# Don't auto-enable Apple Intelligence after OS updates
defaults write com.apple.CloudSubscriptionFeatures.optIn auto_opt_in -bool false

# Disable "Learn from this App" and suggestions for every installed app
app_ids=()
while IFS= read -r app; do
	id=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Contents/Info.plist" 2>/dev/null) && app_ids+=("$id")
done < <(find /Applications /System/Applications /System/Applications/Utilities ~/Applications -maxdepth 2 -name '*.app' 2>/dev/null)
IFS=$'\n' app_ids=($(printf '%s\n' "${app_ids[@]}" | sort -u)); unset IFS
defaults write com.apple.suggestions SiriCanLearnFromAppBlacklist -array "${app_ids[@]}"
defaults write com.apple.suggestions AppCanShowSiriSuggestionsBlacklist -array "${app_ids[@]}"

###############################################################################
# Finder                                                                      #
###############################################################################

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Column view, Recents as the new-window target
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder NewWindowTarget -string "PfAF"

# POSIX path in the Finder title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Unhide ~/Library
chflags nohidden "$HOME/Library"

###############################################################################
# Desktop & Screen Saver                                                      #
###############################################################################

# Don’t click wallpaper to reveal the desktop (Sonoma+)
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Hide desktop items; use Rectangle instead of Apple tiling
defaults write com.apple.WindowManager HideDesktop -bool true
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Screenshots: no floating thumbnail
defaults write com.apple.screencapture show-thumbnail -bool false

###############################################################################
# Security                                                                    #
###############################################################################

# Touch ID for sudo (survives OS updates; see sudo_local.template)
if [[ -f /etc/pam.d/sudo_local.template ]] && { [[ ! -f /etc/pam.d/sudo_local ]] || ! grep -q '^auth.*pam_tid\.so' /etc/pam.d/sudo_local; }; then
	sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local >/dev/null
fi

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "cfprefsd" "Dock" "Finder" "suggestd" "SystemUIServer" "WindowManager"; do
	killall "${app}" &> /dev/null || true
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
