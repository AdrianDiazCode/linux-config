#!/bin/bash

MY_LOCATION="$HOME/Documents/disney/HuluOps-Dashboard"
SESSION_NAME="opsdash"
cd $MY_LOCATION

# if within a tmux session, kill it
if [ -n "$TMUX" ]; then
  # save the current session to a variable
  CURRENT_SESSION=$(tmux display-message -p '#S')
fi

if [ "$CURRENT_SESSION" = "$SESSION_NAME" ]; then
  exit 0
fi

# Check if the session exists
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? -eq 0 ]; then
  tmux attach -t $SESSION_NAME
  exit 0
fi

# Create a new session with one window
tmux new-session -d -s $SESSION_NAME -n workspace "source $MY_LOCATION/source.sh; exec bash"

# Split window vertically (left and right)
tmux split-window -h -t $SESSION_NAME:.0
tmux resize-pane -t $SESSION_NAME:.0 -R 25

# Split the right pane horizontally (top and bottom)
tmux split-window -v -t $SESSION_NAME:.1

# Split the right pane again
tmux split-window -v -t $SESSION_NAME:.2

# Split the right pane again
tmux split-window -v -t $SESSION_NAME:.2

# Select the top-right pane and run the lotr server
tmux select-pane -t $SESSION_NAME:.1
tmux send-keys -t $SESSION_NAME:.1 "cd ../esqoi-control-alb/" C-m
tmux send-keys -t $SESSION_NAME:.1 "docker-compose up --build" C-m

# Select the next-right pane and run the proxy server
tmux select-pane -t $SESSION_NAME:.2
tmux send-keys -t $SESSION_NAME:.2 "cd ../LoTR-API/" C-m
tmux send-keys -t $SESSION_NAME:.2 "docker-compose up --build" C-m

# Select the next-right pane and run the development server
tmux select-pane -t $SESSION_NAME:.3
tmux send-keys -t $SESSION_NAME:.3 "npm run dev" C-m

# Select the left pane and open Vim
tmux select-pane -t $SESSION_NAME:.0
tmux send-keys -t $SESSION_NAME:.0 "nvim" C-m
tmux send-keys -t $SESSION_NAME:.0 "s"

if [ -n "$TMUX" ]; then
  # if we were in a tmux session, switch to the new session and kill the old one
  tmux switch -t $SESSION_NAME
  tmux kill-session -t $CURRENT_SESSION
else
  # Attach to the session
  tmux attach -t $SESSION_NAME
fi
