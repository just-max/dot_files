# -> normally, non-interactive shells should never source .bashrc
# -> when SSH is invoked as `ssh <target> <shell command/code>`, is starts a non-interactive
#    shell on the remote host, with the expectation that this form is being used to run a
#    one-off, non-interactive program on the remote (this is a reasonable thing to do)
# -> bash, however, bypasses this by detecting whether it is being run by sshd (or rshd...),
#    and nevertheless sources .bashrc (as it would for an interactive, non-login shell)
# -> therefore it has become dogma (e.g. on Ubuntu) to check for this case, and bail from bashrc,
#    negating bash's subversion and restoring the canonical behaviour of SSH
# -> this is Good, and we shall adopt this practice
case $- in
    *i*) ;;
      *) return;;
esac

source "${XDG_CONFIG_HOME:-$HOME/.config/}/bash/lib.bash"
declare -a bashrc_d
bashlib_list_dir_files "$(bashlib_xdg_config_home)/bash/bashrc.d" bashrc_d
for rc in "${bashrc_d[@]}"; do source "$rc"; done
unset bashrc_d
