#!/usr/bin/env zsh
############################
# Sets macOS system preferences (Dock, Finder, trackpad, keyboard, etc.)
# to my preferred defaults, so a fresh Mac doesn't need to be clicked
# through System Settings by hand.
#
# Safe to re-run any time. Some settings only take effect after
# relaunching the affected app (handled at the bottom) or logging out.
#
# macOS-only: every command below (defaults, osascript, chflags, killall
# of Mac-specific apps) is specific to Darwin. On any other OS this just
# prints a message and exits cleanly instead of failing partway through.
############################

if [[ "$(uname)" != "Darwin" ]]; then
	echo "macos.sh: not running on macOS, skipping."
	exit 0
fi

echo "Setting macOS system defaults..."

# Close any System Settings panes, to prevent them from overriding
# the settings we're about to change.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

###############################################################################
# General UI/UX                                                             #
###############################################################################

# Disable the "Are you sure you want to open this application?" quarantine
# dialog for apps downloaded from the internet.
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Save to disk (not to iCloud) by default in the Save dialog.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic capitalization, smart dashes, period substitution,
# smart quotes, and auto-correct - they get in the way when typing code.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Trackpad, keyboard                                                        #
###############################################################################

# Enable tap-to-click.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set a fast key repeat rate.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for keys in favor of key repeat, useful in editors.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# Screenshots                                                               #
###############################################################################

# Save screenshots to ~/Desktop/Screenshots (created if missing) instead of
# cluttering the Desktop directly.
mkdir -p "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture location "${HOME}/Desktop/Screenshots"

# Save screenshots as PNG.
defaults write com.apple.screencapture type -string "png"

# Disable the shadow around screenshots of windows.
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                    #
###############################################################################

# Show all filename extensions and hidden files.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar and status bar.
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name.
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default, not "This Mac".
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show ~/Library and /Volumes.
chflags nohidden "${HOME}/Library" 2>/dev/null
sudo chflags nohidden /Volumes 2>/dev/null

###############################################################################
# Dock                                                                      #
###############################################################################

# Auto-hide the Dock and remove the auto-hide delay.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Set a small icon size and don't magnify.
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock magnification -bool false

# Minimize windows into their application's icon.
defaults write com.apple.dock minimize-to-application -bool true

# Don't show recent applications in the Dock.
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Wallpaper                                                                 #
###############################################################################

# Rotate through wallpapers/ (paintings) as the desktop picture. macOS's
# native AppleScript slideshow properties ("pictures folder", "picture
# rotation", "random order") are broken on modern macOS - confirmed on
# Sequoia 15.6.1, they execute without error but don't persist - so
# instead this installs a LaunchAgent that runs scripts/rotate-wallpaper.sh
# every 30 minutes to pick a random image and set it via System Events,
# the one part of that API that still reliably works.
#
# First run may prompt for Automation permission (System Settings >
# Privacy & Security > Automation > osascript/zsh > System Events) -
# approve it, then re-run this script (or wait for the next interval).
agent_label="com.darinevanow.dotfiles.wallpaper-rotate"
agent_src="${HOME}/dotfiles/launchagents/${agent_label}.plist"
agent_dst="${HOME}/Library/LaunchAgents/${agent_label}.plist"

if [ -f "${agent_src}" ]; then
	mkdir -p "${HOME}/Library/LaunchAgents"
	ln -sf "${agent_src}" "${agent_dst}"
	launchctl bootout "gui/$(id -u)" "${agent_dst}" 2>/dev/null
	launchctl bootstrap "gui/$(id -u)" "${agent_dst}"
else
	echo "macos.sh: ${agent_src} not found, skipping wallpaper rotation LaunchAgent."
fi

###############################################################################
# Restart affected applications                                             #
###############################################################################

for app in "Dock" "Finder" "SystemUIServer"; do
	killall "${app}" &>/dev/null
done

echo "Done. Some changes may require a logout/restart to fully apply."
