# also source .bashrc, see also "Invoked as an interactive non-login shell" in the "Bash Reference Manual"
# https://www.gnu.org/software/bash/manual/bash.html#Invoked-as-an-interactive-non_002dlogin-shell
if [[ -r ~/.bashrc ]]; then
    source ~/.bashrc
fi
