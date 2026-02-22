# activate "plugin"-like utilities that modify the environment, like adding adding to PATH

# set up pyenv
export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# JetBrains Toolbox App
[[ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ]] \
    && export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

# OPAM, see note in bashrc.d/50-shell-plugins.bash
bashlib_source_if_exists "$HOME/.opam/opam-init/variables.sh" > /dev/null 2>&1 || true
