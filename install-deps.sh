# Define variables for colors
RED='\e[31m'
GREEN='\e[32m'
RESETCOLOR='\e[0m' # No Color

# Detect OS
if [[ "$(uname)" == "Darwin" ]]; then
  OS="mac"
else
  OS="linux"
fi

# Install a package using the appropriate package manager for the OS
install_pkg() {
  local pkg="$1"
  if [[ "$OS" == "mac" ]]; then
    brew install "$pkg"
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y "$pkg"
  else
    echo "No supported package manager found for: $pkg"
    return 1
  fi
}

echo -e "${GREEN}"
echo -e "\n Installing curl..."
echo -e "${RESETCOLOR}"
install_pkg curl
echo "curl version check: $(curl --version)"

# Install Homebrew on Mac only
if [[ "$OS" == "mac" ]]; then
  echo -e "${GREEN}"
  echo -e "\n Installing Homebrew..."
  echo -e "${RESETCOLOR}"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>~/.bashrc
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "brew version check: $(brew -v)"
fi

echo -e "${GREEN}"
echo -e "\n Installing xclip..."
echo -e "${RESETCOLOR}"
install_pkg xclip

echo -e "${GREEN}"
echo -e "\n Installing Neovim..."
echo -e "${RESETCOLOR}"
if [[ "$OS" == "mac" ]]; then
  brew install neovim
else
  NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": *"\K[^"]*')
  curl -Lo nvim.tar.gz "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
  tar xf nvim.tar.gz
  sudo mv nvim-linux-x86_64 /usr/local/nvim
  sudo ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim
  rm nvim.tar.gz
fi
echo "nvim version check: $(nvim -v)"

echo -e "${GREEN}"
echo -e "\n Installing NVM..."
echo -e "${RESETCOLOR}"
if [[ "$OS" == "mac" ]]; then
  brew install nvm
else
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
echo "nvm version check: $(nvm -v)"

echo -e "${GREEN}"
echo -e "\n Installing tmux..."
echo -e "${RESETCOLOR}"
install_pkg tmux
echo "tmux version check: $(tmux -V)"

echo -e "${GREEN}"
echo -e "\n Installing zig"
echo -e "${RESETCOLOR}"
if [[ "$OS" == "mac" ]]; then
  brew install zig
else
  ZIG_VERSION=$(curl -s "https://ziglang.org/download/index.json" | grep -Po '"x86_64-linux".*?"tarball": *"\K[^"]*' | head -1 | grep -Po '[0-9]+\.[0-9]+\.[0-9]+')
  curl -Lo zig.tar.xz "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz"
  tar xf zig.tar.xz
  sudo mv "zig-linux-x86_64-${ZIG_VERSION}" /usr/local/zig
  sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig
  rm zig.tar.xz
fi
echo "zig version check: $(zig version)"

echo -e "${GREEN}"
echo -e "\n Installing Git..."
echo -e "${RESETCOLOR}"
install_pkg git
echo "git version check: $(git -v)"

echo -e "${GREEN}"
echo -e "\n Installing fzf..."
echo -e "${RESETCOLOR}"
install_pkg fzf
echo "fzf version check: $(fzf --version)"

echo -e "${GREEN}"
echo -e "\n Installing lazygit..."
echo -e "${RESETCOLOR}"
if [[ "$OS" == "mac" ]]; then
  brew install lazygit
else
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
  rm lazygit lazygit.tar.gz
fi
echo "lazygit version check: $(lazygit --version)"

echo -e "${GREEN}"
echo -e "\n Installing ripgrep..."
echo -e "${RESETCOLOR}"
install_pkg ripgrep
echo "ripgrep version check: $(rg --version)"

if [[ "$OS" == "linux" ]] && command -v apt-get &>/dev/null; then
  echo -e "${GREEN}"
  echo -e "\n Installing docker..."
  echo -e "${RESETCOLOR}"
  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo groupadd docker
  sudo usermod -aG docker $USER
  echo "docker version check: $(docker --version)"
fi

echo -e "${GREEN}"
echo -e "\n Installing docker-compose..."
echo -e "${RESETCOLOR}"
if [[ "$OS" == "mac" ]]; then
  brew install docker-compose
else
  # docker-compose-plugin is included with Docker on Linux; install standalone as fallback
  if ! command -v docker-compose &>/dev/null; then
    sudo apt-get install -y docker-compose
  fi
fi
echo "docker-compose version check: $(docker-compose --version)"
