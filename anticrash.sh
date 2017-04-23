#!/bin/bash
COUNTER=0
while [  $COUNTER -lt 5 ]; do
    tmux kill-session -t tGuard
    tmux new-session -d -s tGuard "./telegram-cli -s tgGuard.lua"
    tmux detach -s tGuard
  done
   echo -e "\033[38;5;600m"
   echo Bots Running!
  sleep 1000
done
