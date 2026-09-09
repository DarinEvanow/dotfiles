#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
############################

# dotfiles directory
dotfiledir="${HOME}/dotfiles"

# list of files/folders to symlink in ${homedir}
files=(zshrc zprofile bashrc bash_profile aliases gitconfig)

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
for file in "${files[@]}"; do
    echo "Creating symlink to $file in home directory."
    ln -s "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

# create symlink for neovim settings
mkdir "${HOME}/.config"
ln -s "${dotfiledir}/nvim" "${HOME}/.config/nvim"

# create symlink for zellij settings (config + layouts)
ln -s "${dotfiledir}/zellij" "${HOME}/.config/zellij"

# Link the vendored Claude Code skills into Claude's global skill directories
./claude-skills/install.sh

# Run the Homebrew Script
./brew.sh

# Apply macOS system preferences (Dock, Finder, trackpad, keyboard, etc.)
./macos.sh

echo "Installation complete!"
