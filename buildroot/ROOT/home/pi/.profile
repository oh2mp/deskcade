PS1='\u@\h:\w\$ '

PATH=/usr/local/bin:$PATH

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

amixer -q cset numid=3 1

if [ -e ".asound.state" ] ; then
    alsactl --file .asound.state restore
fi

if [ "$DISPLAY" == "" ] && [ "$SSH_CLIENT" == "" ] && [ "$SSH_TTY" == "" ]; then
        clear
        advmenu >/dev/null 2>&1
fi
