if [[ -v bashlib_imported ]]; then return 0; fi
declare -r bashlib_imported='1'

bashlib_list_dir_files() {
    # usage: bashlib_list_dir_files path/to/dir array_variable
    local -n _bashlib_list_dir_files_result="$2"
    readarray -d '' _bashlib_list_dir_files_result < <(find "$1" -maxdepth 1 -type f -print0)
}

bashlib_list_dir() {
    # usage: bashlib_list_dir path/to/dir array_variable
    local -n _bashlib_list_dir_result="$2"
    readarray -d '' _bashlib_list_dir_result < <(find "$1" -maxdepth 1 -print0)
}

bashlib_xdg_config_home() {
    echo "${XDG_CONFIG_HOME:-$HOME/.config/}"
}

bashlib_xdg_state_home() {
    echo "${XDG_STATE_HOME:-$HOME/.local/state/}"
}

bashlib_cursor_pos() {
    # usage: bashlib_cursor_pos my_row_var my_col_var
    [[ $# -ge 2 ]] || { printf 'bashlib_cursor_pos requires exactly two arguments' 1>&2; return 1; }

    local -n row="$1"
    local -n col="$2"
    # we don't need to worry about mangling backslashes (-r)
    # and row/col are intentionally "unused" (i.e. they set a nameref)
    # shellcheck disable=SC2162,SC2034
    IFS=';' read -sdR -p $'\E[6n' row col
    row="${row#*[}"
}

bashlib_shlexjoin() {
    # from https://unix.stackexchange.com/a/781034/583028
    echo "${*@Q}"
}
