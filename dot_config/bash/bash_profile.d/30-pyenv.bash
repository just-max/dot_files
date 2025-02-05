# set up pyenv
export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
