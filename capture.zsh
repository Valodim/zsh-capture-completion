#!/bin/zsh

zmodload zsh/zpty

inc=( ${0:a:h}/capture-include.zsh )
zpty z zsh -f -i

# wait for ok from shell
zpty -rt z
zpty -w z "source $inc"
zpty -w z "$*"$'\t'

integer tog=0
# read from the pty, and parse linewise
while zpty -r z; do :; done | while IFS= read -r line; do
    if [[ $line == *$'\0\r' ]]; then
        (( tog++ )) && return 0 || continue
    fi
    # display between toggles
    (( tog )) && echo -E - $line
done

return 2
