# in interactive shells, also source bashrc
if [[ $- = *i* ]] && [[ -r ~/.bashrc ]]; then
    source ~/.bashrc
fi
