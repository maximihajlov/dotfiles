#!/bin/bash

IS_MACOS=$(uname -s | grep -i Darwin)

IS_ARCH=$(pacman -V &> /dev/null && echo 1 || echo 0)

if [ $IS_MACOS ]; then
    echo "It's macOS, installing Homebrew if not installed"
    if !command -v brew &> /dev/null
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

# ------------------- #

echo "Upgrading all packages"
if [ $IS_MACOS ]; then
    brew upgrade
elif [ $IS_ARCH ]; then
    sudo pacman -Syu
fi


# ------------------- #

COMMON=(
    "fish"
    "starship"
    "vim"
    "docker"
    "docker-compose"
    "code"
    "nodejs"
    "github-cli"
)

echo "Installing common packages"
if [ $IS_MACOS ]; then
  brew install ${COMMON[@]}
elif [ $IS_ARCH ]; then
  echo "${COMMON[@]}"
  sudo pacman -S ${COMMON[@]}
fi

# ------------------- #
echo "Setting up fish shell with starship prompt"

chsh -s /usr/bin/fish
mkdir -p ~/.config/fish
mkdir ~/bin

echo "
eval \$(/opt/homebrew/bin/brew shellenv)

export PATH=\"\$HOME/bin:\$PATH\"

if status --is-interactive
  starship init fish | source
end
" > ~/.config/fish/config.fish

# ------------------- #

MAC_CASKS=( # Homebrew GUI apps
    "google-chrome"
    "docker" # Docker Desktop (proprietary)
    "jetbrains-toolbox"
    "iterm2"
    "maccy"
    "spotify"
    "telegram"
)

if [ $IS_MACOS ]; then
  brew install --cask ${MAC_CASKS[@]}
fi

echo "Installing JetBrains Mono font"
if [ $IS_MACOS ]; then
  brew tap homebrew/cask-fonts
  brew install --cask font-jetbrains-mono
elif [ $IS_ARCH ]; then
  sudo pacman -S ttf-jetbrains-mono
fi

echo "Don't forget to use JetBrains Mono font in your terminal emulator"
