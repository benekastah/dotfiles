#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

pipe=~/.config/skhd/.yabai-dispatch.fifo

if ! [ -e "$pipe" ]; then
    # Start daemon
    nohup ~/.config/skhd/yabai-dispatch-daemon.sh < /dev/null 2>&1 >> ~/.config/skhd/.yabai-dispatch-daemon.log &
    # hopefully prevent race conditions
    sleep 0.2
fi


IFS=';' read -ra chunks <<< "$@"
for chunk in "${chunks[@]}"; do
    echo "$chunk" > $pipe
done
