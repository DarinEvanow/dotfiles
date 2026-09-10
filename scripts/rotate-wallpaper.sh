#!/usr/bin/env zsh
############################
# Picks a random image from wallpapers/ and sets it as the desktop
# picture on every screen, via System Events.
#
# Run periodically (every 30 min) by the
# com.darinevanow.dotfiles.wallpaper-rotate LaunchAgent set up in
# macos.sh, to fake a slideshow - macOS's native AppleScript slideshow
# properties ("pictures folder", "picture rotation", "random order") are
# broken on modern macOS: they execute without error but don't persist.
# Setting a single picture per desktop, like this script does, is the
# one part of that API that still reliably works.
############################

wallpapers_dir="${HOME}/dotfiles/wallpapers"
images=("${wallpapers_dir}"/*.(jpg|jpeg|png)(N))

if [ ${#images[@]} -eq 0 ]; then
	echo "rotate-wallpaper.sh: no images found in ${wallpapers_dir}"
	exit 1
fi

pick="${images[RANDOM % ${#images[@]} + 1]}"

osascript <<-EOF
	tell application "System Events"
		repeat with d in desktops
			set picture of d to POSIX file "${pick}"
		end repeat
	end tell
EOF

echo "rotate-wallpaper.sh: set ${pick}"
