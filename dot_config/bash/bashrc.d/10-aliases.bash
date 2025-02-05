# make_completion_wrapper, adapted from https://ubuntuforums.org/showthread.php?t=733397
# License: Whatever
# Wraps a completion function. Usage:
# make_completion_wrapper <actual completion function> <name of new func.>
#                         <command name> <supplied arguments>
# eg.:
#   alias agi='apt-get install'
#   make_completion_wrapper _apt_get _apt_get_install "${BASH_ALIASES[agi]}"
# defines a function called _apt_get_install (that's $2) that will complete
# the 'agi' alias.
# Install with:
#   complete -F _apt_get_install agi
# Find the name of the actual completion function:
#   complete -p apt
#
function make_completion_wrapper() {
    local comp_function_name="$1"
    local function_name="$2"
    local extra_args="$3"

    if [[ ! $function_name =~ ^[_a-zA-Z]+$ ]]; then
        printf 'bad function name: %q' "$function_name" 1>&2
        return 1
    fi

    source /dev/stdin <<EOFUNC
function $function_name {
    local extra_args=( $extra_args )
    (( COMP_CWORD += \${#extra_args[@]} - 1 ))
    COMP_WORDS=( "\${extra_args[@]}" "\${COMP_WORDS[@]:1}" )
    _completion_loader "\${extra_args[@]}"
    $comp_function_name
}
EOFUNC
}

function make_alias_with_completion() {
    local alias_name="$1"
    # shellcheck disable=SC2139
    alias "$alias_name"="$2"
    local comp_func="_alias_$alias_name"
    make_completion_wrapper "$3" "$comp_func" "$2"
    shift 3
    complete "$@" -F "$comp_func" "$alias_name"
}

make_alias_with_completion userctl "systemctl --user" _systemctl

complete -F _comp_command runbg
complete  -o bashdefault -o default -F _fzf_path_completion open

alias ll="ls -alF"
alias la="ls -A"
alias sl="echo \
'    _____
 ___ |[]|_n__n_I_c
|___||__|###|____}
 O-O--O-O+++--O-O'"
