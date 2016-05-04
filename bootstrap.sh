#!/usr/bin/env bash

# Reset the sudo timestamp by asking for the sudo password
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Miniconda
if [ ! $(which conda) ]; then
    installer=Miniconda3-latest-MacOSX-x86_64.sh
    curl --progress-bar https://repo.continuum.io/miniconda/$installer --output $installer
    bash $installer -b
    rm $installer
    conda update --yes --all
    conda install anaconda --yes
fi

# Install Homebrew
if [ ! $(which docker) ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install everything in the Brewfile
brew tap homebrew/bundle
brew bundle

# Configure the system
source configure.sh

# Install subl as a command line tool
sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl

# Install Package Control for Sublime Text
pc=Package\ Control.sublime-package
src=https://packagecontrol.io
dest=~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
curl --progress-bar "$src/${pc/ /%20}" --output "$dest/$pc"

# Install Sublime Text preferences and Package Control packages
cp preferences/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null
cp preferences/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Package\ Control.sublime-settings 2> /dev/null

# Copy the .bash_profile to the user's home folder
cp .bash_* ~

# Use a modified version of the Monokai theme by default in Terminal.app
SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
osascript <<EOD

tell application "Terminal"

    local allOpenedWindows
    local initialOpenedWindows
    local windowID
    set themeName to "Monokai"

    (* Store the IDs of all the open terminal windows. *)
    set initialOpenedWindows to id of every window

    (* Open the custom theme so that it gets added to the list
       of available terminal themes (note: this will open two
       additional terminal windows). *)
    do shell script "open '$SCRIPT/preferences/" & themeName & ".terminal'"

    (* Wait a little bit to ensure that the custom theme is added. *)
    delay 1

    (* Set the custom theme as the default terminal theme. *)
    set default settings to settings set themeName

end tell

EOD

# Expand save as dialog by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -boolean true

# Disable smart quotes and dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set locale (language and text formats, timezone)
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
sudo systemsetup -settimezone "Europe/Brussels" > /dev/null

# Finder: set the home folder as the default location for new windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder: enable AirDrop over Ethernet and on unsupported Macs
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Finder: show the ~/Library folder
chflags nohidden ~/Library

# Finder: show the /Volumes folder
sudo chflags nohidden /Volumes

# Dock: automatically instantly hide and show
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide -bool true

# Safari: allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Safari: enable the Develop menu and the Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
