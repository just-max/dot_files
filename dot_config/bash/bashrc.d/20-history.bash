
# ignore duplicates: ignore when the same command is entered multiple times in a row
# ignore space: ignore lines starting with space
HISTCONTROL=ignoredups:ignorespace

# when a shell exits, append to rather than overwrite the history file
shopt -s histappend

# see here for changes to history https://stackoverflow.com/a/19533853/3915973
# as well as the HIST* variables in man bash
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# explicitly unset these, we want unlimited size!
HISTSIZE=
HISTFILESIZE=

# use a different file for history, as some programs still truncate the default
HISTFILE="$(bashlib_xdg_state_home)"/bash/history
mkdir -p "$(dirname "$HISTFILE")"

# add a timestamp to history entries
HISTTIMEFORMAT="[%F %T] "

# fix systemd's broken PS0 (https://github.com/systemd/systemd/commit/dadbb34919abd3fefeb5b8ccc9794da9398a2503#r171679974)
if [[ $PS0 =~ \\033\\\\$ ]]; then PS0="$PS0"'\\'; fi

# shellcheck disable=SC2016
PS0="$PS0"'$(history -a)'
PROMPT_COMMAND+=( 'history -n' )
