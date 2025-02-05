source "${XDG_CONFIG_HOME:-$HOME/.config/}/bash/lib.bash"
declare -a bash_profile_d
bashlib_list_dir_files "$(bashlib_xdg_config_home)/bash/bash_profile.d" bash_profile_d
for rc in "${bash_profile_d[@]}"; do source "$rc"; done
unset bash_profile_d
