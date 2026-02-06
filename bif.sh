#!/bin/bash

MY_LOCATION="$HOME/Documents/disney/bifrost/common-ux"
OPSDASH_LOCATION="$HOME/Documents/disney/HuluOps-Dashboard"
SESSION_NAME="bifrost"

if [ "$1" = '--ops' ]; then
  OPSDASH=true
  SPLIT_PERC=17
else
  OPSDASH=false
  SPLIT_PERC=25
fi

echo "OPSDASH is set to: $OPSDASH"

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

cd $MY_LOCATION
cd packages/ui
npm run build
yalc publish --push
cd $OPSDASH_LOCATION
yalc link @bifrost/ui
cd $MY_LOCATION

# Create a new session with one window
tmux new-session -d -s $SESSION_NAME -n workspace "source $MY_LOCATION/source.sh; exec bash"

# Split window vertically (left and right)
tmux split-window -h -t $SESSION_NAME:.0
tmux resize-pane -t $SESSION_NAME:.0 -R 25
# split the left pane horizontally (top and bottom)
tmux split-window -v -t $SESSION_NAME:.0

# Split the right pane horizontally (top, middle and bottom)
tmux split-window -v -t $SESSION_NAME:.2 -p $SPLIT_PERC

if [ $OPSDASH = true ]; then
  tmux split-window -v -t $SESSION_NAME:.2 -p $SPLIT_PERC
  tmux split-window -v -t $SESSION_NAME:.2 -p $SPLIT_PERC
  tmux split-window -v -t $SESSION_NAME:.2 -p $SPLIT_PERC
  tmux split-window -v -t $SESSION_NAME:.2 -p $SPLIT_PERC
fi

# Select the top-right pane and run claude
tmux select-pane -t $SESSION_NAME:.2
tmux send-keys -t $SESSION_NAME:.2 "cd .. && claude" C-m

# Select the middle-top-right pane and run the development server
tmux select-pane -t $SESSION_NAME:.3
if [ $OPSDASH = true ]; then
  tmux send-keys -t $SESSION_NAME:.3 "npm run dev:yalc" C-m
else
  tmux send-keys -t $SESSION_NAME:.3 "npm run dev" C-m
fi

if [ $OPSDASH = true ]; then
  # Select the top-right pane and run the lotr server
  tmux select-pane -t $SESSION_NAME:.4
  tmux send-keys -t $SESSION_NAME:.4 "cd ../../esqoi-control-alb/" C-m
  tmux send-keys -t $SESSION_NAME:.4 "docker-compose up --build" C-m

  # Select the next-right pane and run the proxy server
  tmux select-pane -t $SESSION_NAME: 5
  tmux send-keys -t $SESSION_NAME:.5 "cd ../../LoTR-API/" C-m
  tmux send-keys -t $SESSION_NAME:.5 "docker-compose up --build" C-m

  # Select the bottom-right pane and run opsdash
  tmux select-pane -t $SESSION_NAME:.6
  tmux send-keys -t $SESSION_NAME:.6 "cd $OPSDASH_LOCATION" C-m
  tmux send-keys -t $SESSION_NAME:.6 "yalc link @bifrost/ui" C-m
  tmux send-keys -t $SESSION_NAME:.6 "npm run dev" C-m

fi

# Select the left pane and open Vim
tmux select-pane -t $SESSION_NAME:.0
tmux send-keys -t $SESSION_NAME:.0 "nvim" C-m
tmux send-keys -t $SESSION_NAME:.0 "s"

if [ $OPSDASH = true ]; then
  # Select the left-bottom pane and nvim opsdash
  tmux select-pane -t $SESSION_NAME:.1
  tmux send-keys -t $SESSION_NAME:.1 "cd $OPSDASH_LOCATION && nvim" C-m
  tmux send-keys -t $SESSION_NAME:.1 "s" C-m
fi

if [ -n "$TMUX" ]; then
  # if we were in a tmux session, switch to the new session and kill the old one
  tmux switch -t $SESSION_NAME
  tmux kill-session -t $CURRENT_SESSION
else
  # Attach to the session
  tmux attach -t $SESSION_NAME
fi
