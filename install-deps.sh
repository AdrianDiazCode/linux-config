# Define variables for colors
RED='\e[31m'
GREEN='\e[32m'
RESETCOLOR='\e[0m' # No Color

# Example usage

echo -e "${GREEN}"
echo -e "\n Installing curl..."
echo -e "${RESETCOLOR}"
apt-get install curl
echo "curl version check: $(curl --version)"

echo -e "${GREEN}"
echo -e "\n Installing Homebrew..."
echo -e "${RESETCOLOR}"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >>~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "brew version check: $(brew -v)"

echo -e "${GREEN}"
echo -e "\n Installing xclip..."
brew install xclip

echo -e "${GREEN}"
echo -e "\n Installing Neovim..."
echo -e "${RESETCOLOR}"
brew install neovim
echo "nvim version check: $(nvim -v)"

echo -e "${GREEN}"
echo -e "\n Installing NVM..."
echo -e "${RESETCOLOR}"
brew install nvm
echo "nvm version check: $(nvm -v)"

echo -e "${GREEN}"
echo -e "\n Installing tmux..."
echo -e "${RESETCOLOR}"
brew install tmux
echo "tmux version check: $(tmux -V)"

echo -e "${GREEN}"
echo -e "\n Installing zig"
echo -e "${RESETCOLOR}"
brew install zig
echo "zig version check: $(zig version)"

echo -e "${GREEN}"
echo -e "\n Installing Git..."
echo -e "${RESETCOLOR}"
brew install git
echo "git version check: $(git -v)"

echo -e "${GREEN}"
echo -e "\n Installing fzf..."
echo -e "${RESETCOLOR}"
brew install fzf
echo "fzf version check: $(fzf --version)"

echo -e "${GREEN}"
echo -e "\n Installing lazygit..."
echo -e "${RESETCOLOR}"
brew install lazygit
echo "lazygit version check: $(lazygit --version)"

echo -e "${GREEN}"
echo -e "\n Installing ripgrep..."
echo -e "${RESETCOLOR}"
brew install ripgrep
echo "rigpgrep version check: $(rg --version)"

if command -v apt-get &>/dev/null; then
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
brew install docker-compose
echo "docker-compose version check: $(docker-compose --version)"
