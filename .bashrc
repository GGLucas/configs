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

# Aliases
alias ls='ls --color=auto -Fh --group-directories-first'
alias no='ls'
alias s='screen -x main -p 0'
alias aur='slurpy -c -t ~/sources/ -f'
alias slide='qiv -usrtm -d 7 -B '

# Load autojump
. /etc/profile.d/autojump.bash

# Prompt
PS1="\[\e[1;35m\]\w \[\e[1;37m\]\$ \[\e[0;37m\]"

# Flatten function
flat (){
    mkdir ../__flat && find . -print0 | xargs -0 -i'{}' cp '{}' ../__flat && mv ../__flat/* . && rmdir ../__flat
}
