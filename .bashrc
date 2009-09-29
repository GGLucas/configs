# Applications
export PAGER='vimpager'
export EDITOR='vim'
export BROWSER='fx'

# Options
shopt -s autocd cdspell
shopt -s dirspell extglob
shopt -s cmdhist nocaseglob

# History control
export HISTCONTROL="ignoreboth"
export HISTFILESIZE=500000

# Walk through completions with ^T
bind "\\C-t: menu-complete"

# Clear screen with ^L
bind "\\C-l: clear-screen"

# Remove annoying fc map
bind -m vi -r v

# Aliases
# Ls
alias ls='ls --color=auto -Fh --group-directories-first'
alias ll='ls -lah'
alias no='ls'
alias na='ll'

# Abbreviations
alias i='makepkg -fi'
alias a='git add'
alias d='git diff'
alias p='git push origin master'
alias pu='git pull origin master'

alias v='vim'
alias vv='sudo vim'

# Shortcuts
alias aur='slurpy -c -t ~/sources/ -f'
alias slide='qiv -usrtm -d 7 -B '
alias vg='viewglob -t off -s windows'

# Shortcut functions
x(){ cd ~; exec xinit $@; }

# Daemon shortcuts
dr(){ sudo /etc/rc.d/$1 restart; }
ds(){ sudo /etc/rc.d/$1 start; }
dt(){ sudo /etc/rc.d/$1 stop; }

# Load autojump
. /etc/profile.d/autojump.bash

# Prompt
PS1="\[\e[1;35m\]\w \[\e[1;37m\]\$ \[\e[0;37m\]"

# Commit git -a or path
c (){
    [[ $@ ]] && git commit $@ || git commit -a
}

# Flatten function
flat (){
    mkdir ../__flat;
    find . -print0 | xargs -0 -i'{}' cp '{}' ../__flat;
    mv ../__flat/* . && rmdir ../__flat
}
