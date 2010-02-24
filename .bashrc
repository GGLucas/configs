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

# Shortcuts
slide() { qiv -usrtm -d 7 -B $1 & }

# Watch list shortcuts
w()   { ani watch: $@; }
lo()  { ani log: $@; }
wh()  { ani hist: +w; }
an()  { ani list: +w =anime; }
anh() { ani hist: =anime; }
tn()  { ani list: +w =tv; }
tnh() { ani hist: =tv; }

# Fallback to grep if ack is not found
[[ ! -x ~/bin/ack ]] && alias ack="grep"

# Tofu organiser shortcuts
orgn()     { tofu org next feed="$1"${@#$1} && tofu org; }
org()      { tofu org $@; }
miscn()    { tofu misc next feed="$1"${@#$1} && tofu misc; }
misc()     { tofu misc $@; }
projn()    { tofu proj next feed="$1"${@#$1} && tofu proj; }
proj()     { tofu proj $@; }
todosync() { unison -batch ~/.tofu ssh://root@glacicle.org//root/todo; }

# Shortcut functions
x(){ cd ~; xinit $@; }

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

# Download package from abs
absd() {
    abs $1/$2
    cp -R /var/abs/$1/$2 /mnt/data-5/others/packages/abs
    cd /mnt/data-5/others/packages/abs/$2
}

# Download package from our
aurd() {
    slurpy -c -t /mnt/data-5/others/packages/aur -f -d $*
    cd /mnt/data-5/others/packages/aur/$1
}

# Flatten function
flat() {
    mkdir ../__flat;
    find . -print0 | xargs -0 -i'{}' cp '{}' ../__flat;
    mv ../__flat/* . && rmdir ../__flat
}

# Resquash everything but usr
squashall() {
    sudo resquash lib
    sudo resquash lib64
    sudo resquash bin
    sudo resquash sbin
}

# Weekly schedule shortcuts
## Display daily schedule
day() {
    week=$(date +%-V)
    flags="";
    [[ $((week%2)) -eq 0 ]] && flags="$flags\e[1;32m2" || flags="$flags\e[1;31m-";
    [[ $((week%3)) -eq 0 ]] && flags="$flags\e[1;32m3" || flags="$flags\e[1;31m-";
    [[ $((week%4)) -eq 0 ]] && flags="$flags\e[1;32m4" || flags="$flags\e[1;31m-";

    echo -e "\e[0;36m#############"
    echo -e "#  \e[1;35mWeek \e[1;34m$week\e[0;36m  #"
    echo -e "#    $flags\e[0;36m    #"
    echo -e "#############\e[0;37m"

    # Schedule
    [[ "$1" == "" ]] && day=$(date +%a) || day=$1;
    shift
    tofu ${day,,} $@;
}

## Add new item
dayn() {
    day="${1,,}"
    feed="$2"
    shift 2
    tofu $day next feed="$feed" $@ && tofu $day;
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
