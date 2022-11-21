#!/bin/bash

# Check if Homebrew is installed
if [ ! -f "`which brew`" ]; then
  echo 'Installing homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo 'Updating homebrew'
  brew update
fi
brew tap homebrew/bundle  # Install Homebrew Bundle

# Check if iTerm2 is installed
if [ ! brew ls --versions iterm2 ]; then
  echo 'Installing iTerm2'
  brew install --cask iterm2
else
  echo 'Updating iTerm2'
  brew upgrade --cask iterm2
fi

# Check if NVM is installed
if [ ! brew ls --versions nvm ]; then
  echo 'Installing NVM'
  brew install nvm
else
  echo 'Updating nvm'
  brew upgrade nvm
fi

# Check if oh-my-zsh is installed
OMZDIR="$HOME/.oh-my-zsh"
if [ ! -d "$OMZDIR" ]; then
  echo 'Installing oh-my-zsh'
  /bin/sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo 'Updating oh-my-zsh'
  upgrade_oh_my_zsh
fi

# Change default shell
if [! $0 = "-zsh"]; then
  echo 'Changing default shell to zsh'
  chsh -s /bin/zsh
else
  echo 'Already using zsh'
fi