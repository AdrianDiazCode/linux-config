# clone the linux-config repo in the home directory

git clone git@github.com:AdrianDiazCode/linux-config.git ~/linux-config

# Add this to the .tmux.conf located in your home dir:
source-file ~/linux-config/tmux.conf

# Source boot commands from your .bashrc or .zsh, etc
source ~/linux-config/bash-init.sh

# Install Dependencies
bash ~/linux-config/install-deps.sh

# install the fonts inside the font folder (procedure depends on your OS)

# Install docker desktop and activate the docker daemon service

## For Linux:

# Start and enable Docker service
sudo systemctl start docker  # Linux only
sudo systemctl enable docker # Linux only

## For macOS:

# Install Docker Desktop from Homebrew Cask (if not already installed)
brew install --cask docker

# Note: On macOS, Docker Desktop must be running for Docker commands to work
