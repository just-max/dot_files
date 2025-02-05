declare -g __bash_prompt_faint
__bash_prompt_faint=$(tput dim)

declare -g __bash_prompt_error
__bash_prompt_error="$(tput setaf 1)$(tput bold)"

declare -g __bash_prompt_info
__bash_prompt_info="$__bash_prompt_faint"

declare -g __bash_prompt_underline
__bash_prompt_underline=$(tput smul)

declare -g __bash_prompt_rev
__bash_prompt_rev="$(tput rev)"

declare -g __bash_prompt_reset
__bash_prompt_reset="$(tput sgr0)"

function __bash_prompt_join() {
  local sep1="$1"; shift

  local sep=''
  for s in "$@"; do
    if [[ $s = '' ]]; then continue; fi
    printf %s%s "$sep" "$s"
    sep="$sep1"
  done
}

function __bash_prompt_right() {
  printf '%*s' $(( COLUMNS + ${#__bash_prompt_underline} )) "$__bash_prompt_underline$1"
}

function __bash_prompt_newline() {
  local -n nl_out="$2"
  # shellcheck disable=SC2034
  [[ $1 -ne 1 ]] && nl_out='\n' || nl_out=''
}

function __bash_prompt_newline_hint() {
  if [[ $1 -ne 1 ]]; then
    printf '%s%s%s' "$__bash_prompt_rev" '\ No newline at end of output' "$__bash_prompt_reset"
  fi
}

function __bash_prompt_status() {
  if [[ $1 -eq 0 ]]; then
    local style="$__bash_prompt_info"
  else
    local style="$__bash_prompt_error"
  fi
  printf %s%d%s "$style" "$1" "$__bash_prompt_reset"
}

function __bash_prompt_workdir() {
  if [[ $1 = / ]]; then
    printf %s "$1"
    return
  fi

  local sub_home="${1/#"$HOME"/"~"}"
  local -a components
  IFS=/ read -r -a components <<< "$sub_home"

  local uline=''
  if [[ $1 =~ [[:space:]] ]]; then uline="$__bash_prompt_underline"; fi

  local component_limit=3
  if [[ ${#components[@]} -gt $(( 2 * component_limit )) ]]; then
    components=(
      "${components[@]: 0: $component_limit}"
      "..."
      "${components[@]: -$component_limit: $component_limit}"
    )
  fi

  printf %s "$__bash_prompt_faint$uline"
  for (( i = 0; i < ${#components[@]} - 1; i += 1 )); do
    printf %s/ "${components[$i]}"
  done
  printf %s "$__bash_prompt_reset"

  printf %s "$uline"
  printf %s "${components[-1]}"
  printf %s "$__bash_prompt_reset"
}

function __bash_prompt_git() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then return 0; fi

  cached_count="$(git diff --cached --numstat | wc -l)"
  changed_count="$(git diff --numstat | wc -l)"

  local cached=$'\e[38;2;88;166;255m'
  local changed=$'\e[38;2;183;97;0m'

  local git_status=()
  if [[ $cached_count -gt 0 ]]; then
    git_status+=( "$(printf %s%d+%s "$cached" "$cached_count" "$__bash_prompt_reset")" )
  fi
  if [[ $changed_count -gt 0 ]]; then
    git_status+=( "$(printf %s%d*%s "$changed" "$changed_count" "$__bash_prompt_reset")" )
  fi

  if git rev-parse --verify --quiet 'HEAD^{commit}' >/dev/null; then
    # covers the cases where HEAD exists
    current_ref=$(git name-rev --name-only HEAD)
  else
    # before the first commit, show the branch name
    current_ref="*$(git branch --show-current)"
  fi
  printf %sgit:%s%s "$__bash_prompt_faint" "$__bash_prompt_reset" "$current_ref"

  if [[ ${#git_status[@]} -gt 0 ]]; then
    local sep="${__bash_prompt_faint}/"
    printf '%s(%s%s)%s' "$__bash_prompt_faint" \
      "$(__bash_prompt_join "$sep" "${git_status[@]}")" \
      "$__bash_prompt_faint" "$__bash_prompt_reset"
  fi
}

# function __time() {
#   t0="$EPOCHREALTIME"
#   "$@"
#   t1="$EPOCHREALTIME"
#   printf "%s (%.3fms)\n" "$1" "$(bc <<< "($t1 - $t0) * 1000")" >&2
# }

function __bash_prompt_set_prompt() {
  local exit_code=$?

  # shellcheck disable=SC2034
  local r cols nl
  bashlib_cursor_pos r cols
  __bash_prompt_newline "$cols" nl

  # shellcheck disable=SC2016
  local components=(
    '"$'"(__bash_prompt_newline_hint $cols)\""
    '"$'"(__bash_prompt_status $exit_code)\""
    '"$(__bash_prompt_workdir "$(pwd)")"'
    '"$(__bash_prompt_git)"'
  )

  # TODO: nicer window title
  declare -g PS1="$nl"'\['
  # shellcheck disable=SC2025
  PS1="$PS1"'\e]0;\u@\h:\w\a'
  PS1="$PS1"'$(tput sc; __bash_prompt_right \#; tput rc)'
  PS1="$PS1"'\]'
  PS1="$PS1"'$(__bash_prompt_join " " '"${components[*]}"')'
  PS1="$PS1"'\n$ '
}

declare -g PROMPT_COMMAND='__bash_prompt_set_prompt'
