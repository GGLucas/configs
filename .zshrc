# Applications
export PAGER='vimpager'
export EDITOR='vim'

# Options
setopt   appendhistory allexport
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
autoload colors zsh/terminfo

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof

# History
HISTFILE=~/.zsh_history
HISTSIZE=9000
SAVEHIST=9000

# Vi editing
bindkey -v
bindkey ' ' magic-space
bindkey "^r" history-incremental-search-backward
bindkey "^_" up-line-or-search

# Aliases
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias ser="nocorrect ser"
alias mkdir='nocorrect mkdir'
alias ls='ls --color=auto -F --group-directories-first'
alias no='ls'

# Colours
if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

# Prompt
PS1="${PR_MAGENTA}%~${PR_LIGHT_WHITE} $ ${PR_NO_COLOR}"

export color=
