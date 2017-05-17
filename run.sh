#!/bin/bash
while true; do
  tmux new-session -s tgGuard "./telegram-cli -s tgGuard.lua"
done
