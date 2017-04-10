#!/bin/bash
COUNTER=0
while [  $COUNTER -lt 5 ]; do
./tg -s tgGuard.lua
sleep 1
#let COUNTER=COUNTER+1 
done
