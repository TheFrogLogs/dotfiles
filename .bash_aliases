# -*- mode: sh -*-

mega() {

    n=$((${1}-2))
    
    for i in $(seq 0 $n); do
	tmux split -h
	tmux select-layout tiled
    done

    tmux select-pane -t 0
    
    for i in $(seq 0 $1); do
        tmux send-keys -t $i ${2} Enter
    done
}

prepareForGoogle() {
    echo "$@" | sed -e "s/ /+/g"
}

wake() {
    declare args=" -o StrictHostKeyChecking=accept-new -T ";
    ssh $@ $args "xset dpms force on ; sudo killall i3lock "`
        `"; notify-send 'Access Granted' 'A remote session has unlocked this device.'";
}



megac() {
    tmux setw synchronize-panes
    $@
    tmux setw synchronize-panes
}

fs2() {
    declare args=($@);

    tmux new-window
    
    # This is ugly. We need a better way to determine the 
    # arguments apart. The second arg (search query) should 
    # be wrapped in quotes but this is a dumb hack if we're
    # too lazy to type them. PLEASE TYPE THEM THIS IS DUMB.
    # eg `fsearch 2 "this is the search string"`
    if [[ "$(echo "$1" | grep -oP "\d+")" == "$1" ]]; then
        declare panes=$1;
        unset args[0];
    else
        # Set default if you're too lazy to give the pane 
        # number and too lazy to wrap the query in quotes.
        # THIS IS DUMB.
        declare panes=1;
    fi
        
    declare query="${args[*]}";
    declare query="$(echo "$query" | sed -e "s/ /+/g")";
    declare results="$(lynx -dump www.google.com/search?q=$query)";
    declare urls=($(echo "$results" | \
        grep -oP "(?<=url\?q=)https?.+?(?=&)" | \
        grep -v "google.com"));

    # Make new array with only the unique urls in case there's more 
    # than one of the same url.
    declare unique=()
    for i in ${urls[*]}; do
        if ! [[ "$(echo ${unique[*]} | grep -oP "$i")" ]]; then
            unique+=($i);
        fi
    done
    # Overwrite url array with unique urls.
    urls=(${unique[*]});

    # Skip 0 for the current pane. Minus 1 for index starting at 0.
    for i in $(seq 1 $((panes-1))); do 
        tmux split -v
	tmux select-layout tiled
    done
    
        #previous location of select-layout tiled
    
    tmux select-pane -t 0

    # Minus 1 for index starting at 0.
    for i in $(seq 0 $((panes-1))); do
        tmux send-keys -t $i "links \"${urls[$i]}\"" Enter;
    done
}

disup() {
    cd ~/Downloads
    n=$(ls -d -- *.deb | cut -c 13-14 | sort -n | tail -n 1)
    sudo dpkg -i discord*$n.deb
}

fs() {
    tmux new-window
    n=$((${1}-2))

    url=($(flynd ${@: -1} | pcregrep -M "https[^ ]*_*")) 

    for i in $(seq 0 $n); do
	tmux split -v
	tmux select-layout tiled
    done

    tmux select-pane -t 0

    
    for i in $(seq 0 $1); do
        tmux send-keys -t $i "links \"${url[$i]}\"" Enter 
    done
}

alias gip='git push'
alias gil='git log'
alias gia='git add --all'
alias gic='git commit'
alias br='brightnessctl set'


alias update='sudo apt update && sudo apt upgrade -y'
alias vic='vim ~/.config/i3/config'
alias kj='cht.sh'
alias la='ls -AX --color --classify --group-directories-first'
alias lla='ls -lAshLX --color --classify --group-directories-first'

alias ts='tmux set -g status'
alias movie='ssh -o StrictHostKeyChecking=no watch.ascii.theater'
alias t='tmux'
alias tl='tmux list-sessions'
tk() {
    tmux kill-session -t  $@
}
alias tks='tmux kill-session'
alias ta='tmux attach'
alias clock='tty-clock -B -c -t -S'


alias les='less -~KMQR-'

# Yes, I'm that lazy.
alias c='clear'
alias e='exit'
alias sba='source ~/.bash_aliases; exec bash'
alias vba='vim ~/.bash_aliases'
alias eba='emacs -nw ~/.bash_aliases'

alias ghist='history | grep'
alias rd='tuir'
alias irc='irssi'

# Requires qcd file.
source ~/bin/qcd-SOURCEME.sh;


lac() {
    declare -i total=$(la ${1:-$pwd} | wc -l);
    declare -i f_num=$(find ${1:-$pwd} -maxdepth 1 -type f | wc -l);
    declare -i dir_num=$(find ${1:-$pwd} -maxdepth 1 -type d | wc -l);

    echo "$dir_num director$(
        if (( DIRECTORY_COUNT != 1 )); then
            echo "ies"
        else
            echo "y"
        fi
    ), $f_num file$(
        if (( $f_num != 1 )); then
            echo "s"
        fi
    ), $total total";
}

alias em='emacs -nw'

get() {
	sudo apt install -y $@
}	

lk() {
	q="$(echo "$@" | sed -e "s/ /+/g")"; # input is q, echo input and pipe ot sed, substitute + 
	links www.google.com/search?q=$q
}

flynd() {
	q="$(echo "$@" | sed -e "s/ /+/g")";
	lynx -dump www.google.com/search?q=$q
}	

flyn() {
	q="$(echo "$@" | sed -e "s/ /+/g")";
	lynx -accept-all-cookies  www.google.com/search?q=$q
}	

gg() {
	q="$(echo "$@" | sed -e "s/ /+/g")";
	links www.google.com/search?q=$q
}

lkj() {
	q="$(echo "$@" | sed -e "s/ /+/g")";
	links www.google.com/search?q=$q
}

