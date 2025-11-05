tmux
set -o vi
export EDITOR=vim
export VISUAL=vim
command -v bindkey &>/dev/null && bindkey -v

alias green_log='echo -e "\e[32m$1\e[0m"'
alias red_log 'echo -e "\e[32m$1\e[0m"'
alias bm='cd ~/Documents/buildman/buildman-k8 && ./tmux-session.sh'
alias nvimconf='source  ~/.config/nvim/tmux-session.sh'
alias delete-node-modules='echo "deleting node_modules ..."  && find . -name "node_modules" -type d -prune -exec rm -rf "{}" \; && echo "done!" '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# clear console
clear
# echo 'custom bash init sourced'
