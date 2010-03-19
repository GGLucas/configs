# Applications
export PAGER='vimpager'
export EDITOR='vim'
export BROWSER='fx'

# History control
export HISTCONTROL="ignoreboth"
export HISTFILESIZE=500000

# Set prompt
setprompt(){
    # Capture last return code
    local rts=$?

    # Get path with tilde for home
    if [[ "$PWD" == "$HOME" ]]; then
        local dir="~"
    elif [[ "${PWD:0:${#HOME}}" == "$HOME" ]]; then
        local dir="~${PWD:${#HOME}}"
    else
        local dir=$PWD
    fi

    # Truncate path if it's long
    if [[ ${#dir} -gt 19 ]]; then
        local offset=$((${#dir}-18))
        dir="+${dir:$offset:18}"
    fi

    # Path color indicates host
    case "$HOSTNAME" in
        "ayu") local dircol="\[\e[1;35m\]"; ;; # Desktop
        "misuzu") local dircol="\[\e[1;32m\]"; ;; # Laptop
        "glacicle.com") local dircol="\[\e[1;31m\]"; ;; # Server
        *) local dircol="\[\e[1;37m\]"; ;; # Other
    esac

    # Marker char indicates root or user
    [[ $UID -eq 0 ]] && local marker='#' || local marker='$'

    # Marker color indicates successful execution
    [[ $rts -eq 0 ]] && local colormarker="\[\e[1;37m\]$marker" \
                     || local colormarker="\[\e[1;31m\]$marker"

    # Set PS1
    PS1="${dircol}${dir} ${colormarker}\[\e[0;37m\] "
}
PROMPT_COMMAND="setprompt &> /dev/null"

# Check for current bash version
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s autocd cdspell
    shopt -s dirspell globstar
fi

# General options
shopt -s cmdhist nocaseglob
shopt -s histappend extglob

## Bindings in interactive shells
case "$-" in *i*)
    # Remove annoying fc map
    bind -m vi -r v

    # Walk through completions with ^T
    bind "\\C-t: menu-complete"

    # Clear screen with ^L
    bind "\\C-l: clear-screen"

    # Add pager pipe with <A-w>
    bind '"\ew":" | $PAGER \C-m"'

    # Background & ignore with <A-b>
    bind '"\eb":" &> /dev/null &\C-m"'

    # Search
    bind '"\e\\":" | ack "'

    # Display status
    bind '"\ez":"; ns\C-m"'

    # Reset
    bind '"\er":"reset ; clear \C-m"'

    # Clear
    bind '"\ec":"cd ; clear \C-m"'
    bind '"\el":"clear \C-m"'
;; esac;

# Load autojump
if [[ -f /etc/profile.d/autojump.bash ]]; then
    . /etc/profile.d/autojump.bash
fi

# Complete only directories on cd
complete -d cd

# Aliases
# Ls
alias ls='ls --color=auto -Fh --group-directories-first'
alias ll='ls -lah'
alias no='ls'
alias na='ll'

# Abbreviations
alias prf='export WINEPREFIX=$(pwd)'
alias i='makepkg -fi'
alias a='git add'
alias d='git diff'
alias p='git push origin master'
alias pu='git pull origin master'
alias pg='$PAGER'
alias r='rolldice'
alias v='vim'
alias vv='sudo vim'
alias t='todo'
alias td='todo --database ~/.todo.daily'

# Fallback to grep if ack is not found
[[ ! -x ~/bin/ack ]] && alias ack="grep"

# Shortcut functions
slide() { qiv -usrtm -d 7 -B $1 & }
x(){ cd ~; xinit $@; }
tm() { tmux -2 attach -t $1; }
tmn() { tmux -2 respawn -t $1; }

# Watch list shortcuts
w()   { ani watch: $@; }
lo()  { ani log: $@; }
wh()  { ani hist: +w; }
an()  { ani list: +w =anime; }
anh() { ani hist: =anime; }
tn()  { ani list: +w =tv; }
tnh() { ani hist: =tv; }

# Daemon shortcuts
dr() { for d in $@; do sudo /etc/rc.d/$d restart; done; }
ds() { for d in $@; do sudo /etc/rc.d/$d start; done; }
dt() { for d in $@; do sudo /etc/rc.d/$d stop; done; }

# Local server start and stop
sstart() { ds httpd mysqld; }
sstop()  { dt httpd mysqld; }

# Notify command exit status
ns() {
    cmd=$(history 1 | head -n 1 | sed "s|^[^\s]* ||" | sed "s|; ns.*$||")
    status=$?

    [[ $? == 0 ]] && notify-send --always "$cmd" "Successfully finished." \
                  || notify-send --critical "$cmd" "Returned with error code $?"
}

# Wrapper for tvtime
tvtime() {
    sudo modprobe -a saa7134_alsa saa7134
    while [[ ! -e /dev/video0 ]]; do sleep 0.5; done;
    sudo /usr/bin/tvtime
    cp ~/.tvtime/tvtime.xml.orig ~/.tvtime/tvtime.xml
    sudo modprobe -r saa7134_alsa
}

# Commit git -a or path
c() {
    [[ $@ ]] && git commit $@ || git commit -a
}

# Root where packages are stored
PACKAGE_ROOT=/mnt/data-5/others/packages

# Download package from abs
absd() {
    abs $1/$2
    cp -R /var/abs/$1/$2 $PACKAGE_ROOT/abs
    cd $PACKAGE_ROOT/abs/$2
}

# Download package from aur
aurd() {
    if wget http://aur.archlinux.org/packages/$1/$1.tar.gz \
             -O $PACKAGE_ROOT/aur/$1.tar.gz;
    then
        cd $PACKAGE_ROOT/aur
        tar xvf $1.tar.gz || return 1
        rm $1.tar.gz
        cd $1
    fi
}

# Go to a package directory
ga() { cd $PACKAGE_ROOT/$1/$2; }

# Flatten function
flat() {
    mkdir ../__flat;
    find . -print0 | xargs -0 -i'{}' cp '{}' ../__flat;
    mv ../__flat/* . && rmdir ../__flat
}

## Map function for bash.
# Courtesy downdiagonal on reddit.
# http://www.reddit.com/r/linux/comments/akt3j
map() {
    local command i rep
    if [ $# -lt 2 ] || [[ ! "$@" =~ :[[:space:]] ]];then
        echo "Invalid syntax." >&2; return 1
    fi
    until [[ $1 =~ : ]]; do
        command="$command $1"; shift
    done
    command="$command ${1%:}"; shift
    for i in "$@"; do
        if [[ $command =~ \{\} ]]; then
            rep="${command//\{\}/\"$i\"}"
            eval "${rep//\\/\\\\}"
        else
            eval "${command//\\/\\\\} \"${i//\\/\\\\}\""
        fi
    done
}
