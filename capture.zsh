#!/bin/zsh

zmodload zsh/zpty

zpty z ZDOTDIR=. zsh -i

# wait for ok from shell
zpty -rt z
zpty -w z "$1"$'\t'

integer tog=0
# read from the pty, and parse linewise
while zpty -r z; do :; done | while IFS= read -r line; do
    if [[ $line == *$'\0\r' ]]; then
        (( tog++ )) && return 0 || continue
    fi
    echo -E - $line
done

return 2
