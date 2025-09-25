tmux source ~/linux-config/.tmux.conf
tmux

command -v bindkey &>/dev/null && bindkey -v

alias bm='cd ~/Documents/buildman/buildman-k8 && source source.sh && source tmux-session.sh'
alias nvimconf='source  ~/.config/nvim/tmux-session.sh'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
