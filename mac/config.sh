#!/bin/sh

# Use faster key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Disable force click
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false

# Use silent clicking
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# ===------------------------------------------------------------------------===

# Configure dock appearance
defaults write com.apple.dock 'orientation' -string 'left'
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock tilesize -int 44

# Show hard drives, etc. on the desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Remove delay to grab the path in Finder window titles
defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0"

# Show all extensions & don't warn on changes
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Prevent creation of `.DS_Store` files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# ===------------------------------------------------------------------------===

# Default to plaintext documents in TextEdit
defaults write com.apple.TextEdit "RichText" -bool "false"

# Enable the developer menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Don't open files (read: unzip archives) upon download completion
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Prevent popups when devices in DFU mode are connected
defaults write -g ignore-devices -bool true
defaults write com.apple.iTunesHelper ignore-devices -bool YES
defaults write com.apple.AMPDevicesAgent dontAutomaticallySyncIPods -bool true
defaults write com.apple.AMPDeviceDiscoveryAgent ignore-devices 1
defaults write com.apple.AMPDeviceDiscoveryAgent reveal-devices 0
defaults write com.apple.MobileDeviceUpdater Disabled -bool YES
