# # load /etc/profile
# if [ -r /etc/profile ]; then source /etc/profile; fi

# load ~/.profile
if [ -r "$HOME"/.profile ]; then source "$HOME"/.profile; fi
