#!/usr/bin/env zsh

# Instll Homebrew if it's not installed
if ! command -v brew &>/dev/null; then
	echo "Homebrew is not installed. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Attempt to set up Homebrew PATH automatically for this session
	if [ -x "/opt/homebrew/bin/brew" ]; then
		# For Apple Silicon Macs
		echo "Configuring Homebrew in PATH for Apple Silicon Mac..."
		export PATH="/opt/homebrew/bin:$PATH"
	fi
else
	echo "Homebrew is already installed. Skipping..."
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
	echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
	exit 1
fi

# Update Homebrew and upgrade any already installed formulae
brew update
brew upgrade
brew upgrade --cask
brew cleanup

# Define an array of packages to install using Homebrew
packages=(
	"zsh"
	"git"
        "gh"
        "node"
        "deno"
	"zellij"
	"atuin"
        "neovim"
        "ripgrep"
        "fd"
        "antigen"
        "jandedobbeleer/oh-my-posh/oh-my-posh"
)

# Loop over the array to install each package
for package in "${packages[@]}"; do
  if brew list --formula | grep -q "^$package\$"; then
    echo "$package is already installed. Skipping..."
  else
    echo "Installing $package..."
    brew install "$package"
  fi
done

# Add the Homebrew zsh to allowed shells
echo "Changing default shell to Homebrew zsh"
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells >/dev/null

# Change the default shell to Homebrew zsh
chsh -s "$(brew --prefix)/bin/zsh"

# Git config name
echo "Please enter your FULL NAME for Git configuration:"
read git_user_name

# Git config email
echo "Please enter your EMAIL for git configuration:"
read git_user_email

# Set git credentials
$(brew --prefix)/bin/git config --global user.name "$git_user_name"
$(brew --prefix)/bin/git config --global user.email "$git_user_email"

# Define an array of applications to install using Homebrew Cask
apps=(
  "firefox"
  "1password"
  "obsidian"
  "mochi"
  "iterm2"
  "rectangle"
  "flux"
  "alfred"
  "spotify"
  "discord"
)

# Loop over the array to install each applications
for app in "${apps[@]}"; do
  if brew list --cask | grep -q "^$app\$"; then
    echo "$app is already installed. Skipping..."
  else
    echo "Installing $app..."
    brew install --cask "$app"
  fi
done

# Install Jetbrains Mono Nerdfont
# Tap the Homebrew font cask reposity if not already tapped
brew tap | grep -q "^homebrew/cask-fonts$" || brew tap homebrew/cask-fonts

# Define the font name
font_name="font-jetbrains-mono-nerd-font"

# Check if the font is already installed
if brew list --cask | grep -q "^$font_name\$"; then
  echo "$font_name is already installed. Skipping..."
else
  echo "Installing $font_name..."
  brew install --cask "$font_name"
fi

# Once font is installed, import terminal profile
echo "Import your iterm2 settings..."
echo "iTerm2 -> Settings -> Profiles -> Other Actions -> Import JSON Profiles"
echo "Import from ${HOME}/dotfiles/settings/iterm2_profile.json"
echo "Press enter to continue..."
read

# Update and clean up again for safe measure
brew update
brew upgrade
brew upgrade --cask
brew cleanup

echo "Sign in to Firefox. Press enter to continue..."
read

echo "Sign in to 1Password. Press enter to continue..."
read

echo "Sign in to Google. Press enter to continue..."
read

echo "Sign in to Github. Press enter to continue..."
read

echo "Sign in to Github CLI..."
gh auth login

echo "Sign in to Obsidian. Press enter to continue..."
read

echo "Sign in to Mochi. Press enter to continue..."
read

echo "Sign in to Spotify. Press enter to continue..."
read

echo "Sign in to Discord. Press enter to continue..."
read

echo "Run Alfred. Press enter to continue..."
read

echo "Run Rectangle. Press enter to continue..."
read

echo "Run Flux. Press enter to continue..."
read
