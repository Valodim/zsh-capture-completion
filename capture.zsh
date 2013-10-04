#!/bin/zsh

zmodload zsh/zpty

here=( ${0:a:h} )
zpty z ZDOTDIR=$here zsh -i

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
