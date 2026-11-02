#!/usr/bin/env sh
# Set up macOS how I like it.
# Run as the logged-in user: ./macos/set-defaults.sh (without sudo).
# System settings request sudo access; screen-lock setup prompts for your login password.
# bin/dot also runs this file during bootstrap and subsequent updates.
#
# Originally based on https://github.com/mathiasbynens/dotfiles/blob/master/.macos

set -eu

if [ "$(uname -s)" != Darwin ]
then
  printf '%s\n' 'This script requires macOS.' >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]
then
  printf '%s\n' 'Run this script as your normal user, without sudo.' >&2
  exit 1
fi

macos_major=$(sw_vers -productVersion | cut -d . -f 1)

###############################################################################
# Language and region                                                          #
###############################################################################

# General > Language & Region: prefer English (US) for menus and app interfaces.
# Language changes may require logging out or restarting individual apps.
defaults write NSGlobalDomain AppleLanguages -array 'en-US'

# Use United States conventions for dates, numbers, and currency.
defaults write NSGlobalDomain AppleLocale -string en_US

# Use US measurements rather than metric units.
defaults write NSGlobalDomain AppleMeasurementUnits -string Inches
defaults write NSGlobalDomain AppleMetricUnits -bool false

###############################################################################
# Appearance and standard dialogs                                              #
###############################################################################

# Appearance: automatically switch between light and dark with the time of day.
# Do not pin AppleInterfaceStyle: it represents the currently active appearance.
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Appearance: use graphite accents and matching text-selection highlights.
defaults write NSGlobalDomain AppleAccentColor -int -1
defaults write NSGlobalDomain AppleAquaColorVariant -int 6
defaults write NSGlobalDomain AppleHighlightColor -string '0.847059 0.847059 0.862745 Graphite'

# Appearance > Sidebar icon size: Small (1 = small, 2 = medium, 3 = large).
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Expand Save panels to show the folder browser and destination options.
# Apps may remember their own panel state or ignore these AppKit preferences.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand Print panels to show the available printer and layout options.
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Initially offer local storage for new documents, rather than iCloud.
# This does not disable iCloud Drive or override every app's last-used location.
# https://macos-defaults.com/finder/nsdocumentsavenewdocumentstocloud.html
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Allow Help Viewer windows to sit behind other apps instead of floating.
# Undocumented; applies to Help Viewer, not every app's custom help interface.
# https://macos-defaults.com/misc/devmode.html
defaults write com.apple.helpviewer DevMode -bool true

###############################################################################
# Keyboard, text editing, and trackpads                                         #
###############################################################################

# Keyboard > Keyboard navigation: let Tab focus all controls, including buttons.
# This is distinct from Accessibility > Keyboard > Full Keyboard Access.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Holding a letter repeats it rather than opening the accented-character picker.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keyboard > Text Input > Edit: enable automatic corrections and smart typography.
# Apps/editors may override these globally enabled text-input features.
# Capitalize sentences.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true

# Convert paired hyphens to dashes.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool true

# Double-space inserts a period.
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true

# Use typographic quotation marks.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true

# Correct spelling automatically.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

# Enable text completion.
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool true

# Trackpad > Point & Click: tap to click; secondary click with two fingers.
# Configure both built-in and Bluetooth trackpads. Corner value 0 disables the
# bottom-corner alternative; it does not disable the two-finger secondary click.
# These are user preferences, not login-window or other users' settings.
for trackpad_domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad
do
  # Tap with one finger to click.
  defaults write "$trackpad_domain" Clicking -bool true
  # Tap or click with two fingers for secondary click.
  defaults write "$trackpad_domain" TrackpadRightClick -bool true
  # Disable bottom-corner secondary clicking.
  defaults write "$trackpad_domain" TrackpadCornerSecondaryClick -int 0
  # Disable three-finger dragging.
  defaults write "$trackpad_domain" TrackpadThreeFingerDrag -bool false
done
# Enable secondary clicking in the host-scoped trackpad preferences as well.
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

###############################################################################
# Screenshots                                                                  #
###############################################################################

# Save captures in ~/Pictures/Screenshots; create the destination if needed.
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
# Save screenshots as PNG images.
defaults write com.apple.screencapture type -string png
# Skip the floating thumbnail so captures are saved directly.
defaults write com.apple.screencapture show-thumbnail -bool false

###############################################################################
# Finder and mounted volumes                                                   #
###############################################################################

# Finder > Settings > General: new windows open the user's home folder (PfHm).
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
# Finder > Settings > Advanced: show all filename extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Skip the confirmation dialog when changing a filename extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Show the status bar with item counts and available disk space.
defaults write com.apple.finder ShowStatusBar -bool true

# Display the full POSIX path in the window title (undocumented Finder preference).
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Show the path bar at the bottom of Finder windows.
# https://macos-defaults.com/finder/showpathbar.html
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders above files when sorting by name.
# https://macos-defaults.com/finder/_fxsortfoldersfirst.html
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default, rather than the entire Mac.
# https://macos-defaults.com/finder/fxdefaultsearchscope.html
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
# Prefer list view (Nlsv); alternatives: icons (icnv), columns (clmv), gallery (glyv).
# Existing folders can retain their individual view settings.
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv

# Hide desktop file/volume icons. The files remain accessible through Finder.
defaults write com.apple.finder CreateDesktop -bool false
if [ "$macos_major" -ge 14 ]
then
  # Desktop & Dock > Show Items > On Desktop: hide desktop items.
  defaults write com.apple.WindowManager HideDesktop -bool true
fi
# If desktop items are shown, hide internal disks and show external/removable media.
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Get Info: expand the More Info (MetaData) and Open With panes.
# Merge these choices so unrelated pane settings are not replaced.
defaults write com.apple.finder FXInfoPanesExpanded -dict-add MetaData -bool true
defaults write com.apple.finder FXInfoPanesExpanded -dict-add OpenWith -bool true

# Spring loading: hovering over a folder while dragging opens it after 0.5 seconds.
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

# Avoid Finder .DS_Store metadata on network shares and USB volumes.
# This sacrifices per-folder view state there; existing files are not removed.
# Apple documents the network key: https://support.apple.com/102064
# The USB counterpart is undocumented; verify behavior on the target release.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Open read-only disk-image volumes in Finder when mounted (`man hdiutil`).
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true

# Also open writable disk-image volumes in Finder when mounted.
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
# Open a Finder window for newly mounted removable disks.
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show ~/Library in Finder.
if [ -d "$HOME/Library" ]
then
  chflags nohidden "$HOME/Library"
fi

###############################################################################
# Dock, Mission Control, and window management                                  #
###############################################################################

# Position the Dock along the bottom edge of the screen.
defaults write com.apple.dock orientation -string bottom

# Automatically hide the Dock until the pointer reaches the screen edge.
defaults write com.apple.dock autohide -bool true

# Keep Dock icons the same size when hovering over them.
defaults write com.apple.dock magnification -bool false
# Minimized windows get separate Dock tiles rather than joining the app icon.
defaults write com.apple.dock minimize-to-application -bool false

# Set Dock icons to 36 points.
defaults write com.apple.dock tilesize -int 36

# Show an indicator beneath each running application.
defaults write com.apple.dock show-process-indicators -bool true

# Disable the Dock icon bounce when launching an application.
defaults write com.apple.dock launchanim -bool false

# Hide suggested and recently used applications from the Dock.
defaults write com.apple.dock show-recents -bool false
# Remove the delay before the hidden Dock appears.
# https://macos-defaults.com/dock/autohide-delay.html
defaults write com.apple.dock autohide-delay -float 0

# Remove the slide animation when showing or hiding the Dock.
# https://macos-defaults.com/dock/autohide-time-modifier.html
defaults write com.apple.dock autohide-time-modifier -float 0
# Enable spring loading: hover over a Dock item while dragging to open it.
# Undocumented Dock preference.
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Mission Control: group windows by application.
defaults write com.apple.dock expose-group-apps -bool true
# Keep Spaces in a stable order instead of sorting by recent use.
# https://macos-defaults.com/mission-control/mru-spaces.html
defaults write com.apple.dock mru-spaces -bool false

if [ "$macos_major" -ge 13 ]
then
  # Disable Stage Manager; use standard desktop window management.
  defaults write com.apple.WindowManager GloballyEnabled -bool false
fi
if [ "$macos_major" -ge 15 ]
then
  # Desktop & Dock > Windows: place and resize windows manually.
  # https://support.apple.com/guide/mac-help/mchl118087b0/mac
  # Do not tile windows when dragged to the left or right screen edge.
  defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
  # Do not fill the screen when dragging a window to the menu bar.
  defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
  # Do not show tiling targets when holding Option while dragging.
  defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
fi

# Desktop & Dock > Hot Corners. Modifier mask 0 means no key needs to be held.

# Top left: no action (1).
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right: open Notification Center (12).
defaults write com.apple.dock wvous-tr-corner -int 12
defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom left: open Mission Control (2).
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0

# Bottom right: start the screen saver (5).
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Accessibility                                                                #
###############################################################################

# Modern macOS can protect this domain. Report failures and finish the remaining
# setup; do not retry as root (that can target the wrong user's preferences).
# Verify these settings in the UI even if defaults reports a successful write.
write_accessibility () {
  if ! defaults write com.apple.universalaccess "$@"
  then
    printf 'Set Accessibility preference manually in System Settings: %s\n' "$1" >&2
  fi
}

# Accessibility > Display: enable translucent backgrounds.
write_accessibility reduceTransparency -bool false

# Allow standard motion effects and interface animations.
write_accessibility reduceMotion -bool false

# Accessibility > Zoom: enable Control + scroll to zoom.
# 262144 is the Control modifier mask.
# https://support.apple.com/guide/mac-help/mchl779716b8/mac
write_accessibility closeViewScrollWheelToggle -bool true
write_accessibility closeViewScrollWheelModifiersInt -int 262144

###############################################################################
# Screen locking, power, and startup sound                                      #
###############################################################################

# Lock Screen: start the screen saver after 5 minutes of inactivity (300 seconds).
defaults -currentHost write com.apple.screensaver idleTime -int 300

# Require a password immediately after the screen saver starts or display sleeps.
# A dash requests your login password interactively, keeping it out of this file.
sysadminctl -screenLock immediate -password -

# On AC power, turn the display off after 10 minutes but prevent idle system sleep.
# pmset uses minutes; sleep 0 means never. Battery settings are left unchanged.
sudo pmset -c displaysleep 10 sleep 0

# Mute the startup chime (StartupMute: %01 = muted, %00 = audible).
sudo nvram StartupMute=%01

###############################################################################
# Manual setup                                                                 #
###############################################################################

# Keyboard/Trackpad: adjust natural scrolling, repeat speed, and external-keyboard
# modifier mappings for the attached hardware.

# Safari > Settings > Advanced: review full website address, Tab navigation, and
# Show features for web developers. General: review opening safe downloads.
# Search/Privacy/AutoFill/Websites: review suggestions, tracking protection,
# password-manager integration, pop-ups, and autoplay.
# https://support.apple.com/guide/safari/ibrw1075/mac
# Mail > Settings / View: review spelling, conversation ordering, attachment
# display, and whether copied addresses include names.

# Log out/in to reload cached preferences without forcibly restarting apps.
printf '%s\n' 'Preferences written. Log out and back in, then review the manual setup notes in macos/set-defaults.sh.'
