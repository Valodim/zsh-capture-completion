# no prompt!
PROMPT=

# load completion system
autoload compinit
compinit

# never run a command
bindkey '^M' undefined

# send a line with null-byte at the end before and after completions are output
null-line () {
    echo -E - $'\0'
}
compprefuncs=( null-line )
comppostfuncs=( null-line )

# we use zparseopts
zmodload zsh/zutil

# override compadd (this our hook)
compadd () {

    typeset -a tmp; 

    # check if any of -O, -A or -D are given
    zparseopts -E -a tmp O A D
    if (( $#tmp )); then
        # if that is the case, just delegate and leave
        builtin compadd "$@"
        return $?
    fi

    # ok, this concerns us!
    # echo -E - got this: "$@"

    # capture completions by injecting -A parameter into the compadd call
    builtin compadd -A tmp "$@"
    (( $#tmp )) && print -l -- $tmp

    return

    # TODO capture descriptions (sorta complicated to get right :\)
    if (( $@[(I)-d] )); then # kind of a hack, $+@[(r)-d] doesn't work because of line noise overload
        tmp=${@[(i)-d]}
        echo -E 'descriptions: ' ${(e):-\$$@[tmp+1]}
    fi

}
