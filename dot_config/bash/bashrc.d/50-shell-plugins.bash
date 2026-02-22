# activate "plugin"-like utilities that modify the behaviour of the shell,
# like adding completions, key bindings, PWD-based tweaks, etc.

# set up fzf key bindings and fuzzy completion
eval "$(bashlib_run_if_command_exists fzf --bash)"

# set up https://mise.jdx.dev/
eval "$(bashlib_run_if_command_exists mise activate bash)"

# initialize OPAM, the OCaml package manager
# the default is to call ~/.opam/opam-init/init.sh, which conflates environment
# setup (-> .profile) with shell "plugin" setup, so the environment setup has been split out
# we also skip the stdin-is-tty check, since we guard for that already
bashlib_source_if_exists "$HOME/.opam/opam-init/complete.sh" > /dev/null 2>&1 || true
bashlib_source_if_exists "$HOME/.opam/opam-init/env_hook.sh" > /dev/null 2>&1 || true

# set up pyenv
eval "$(bashlib_run_if_command_exists pyenv init - bash)"
