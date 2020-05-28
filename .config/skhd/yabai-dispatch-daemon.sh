#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

pipe=~/.config/skhd/.yabai-dispatch.fifo

trap "rm -f $pipe" EXIT

if ! [[ -p $pipe ]]; then
    mkfifo $pipe
fi

status_title=
status_message=

command=

echo "yabai dispatch daemon running..."

while true
do
    # Get the input, trimming leading and trailing whitespace
    input="$(cat < $pipe | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    echo ================================================================================
    echo 2>&1 "INPUT: $input"
    echo ================================================================================
    # Separates by newline or tab (see IFS at top of file)
    for line in $input; do
        echo 2>&1 "LINE: $line"

        case "$line" in
            RESET)
                # Only reset if there is something to reset. This allows
                # status messages to be more useful (by showing the last
                # completed command rather than a reset message).
                if [ -n "$command" ]; then
                    status_title='reset'
                    status_message='reset command buffer'
                    # Toss out command buffer
                    command=
                fi
                ;;
            EXECUTE)
                status_title='execute'
                # execute command and reset
                if [ -n "$command" ]; then
                    command="yabai $command"
                    set +e  # allow this command to err out
                    output="$(eval "$command" 2>&1)"
                    exit_code=$?
                    set -e  # ok, nothing to see here. zero tolerance for errors, got it.
                    status_message="$command exited with status $exit_code"$'\n\t'"$output"
                else
                    status_message='no command to run'
                fi
                command=
                ;;
            STATUS)
                # Show the last status log
                echo "Status request"
                terminal-notifier -title "yabai dispatch: $status_title" -message "$status_message"
                ;;
            *)
                command="$command $line"
                status_title="build"
                status_message="command buffer: $command"
                ;;
        esac

        echo "$status_title"
        echo "$status_message"
        echo --------------------------------------------------------------------------------
    done
done
