source "${XDG_CONFIG_HOME:-$HOME/.config/}/bash/lib.bash"
declare -a bashrc_d
bashlib_list_dir_files "$(bashlib_xdg_config_home)/bash/bashrc.d" bashrc_d
for rc in "${bashrc_d[@]}"; do source "$rc"; done
unset bashrc_d
