# Applications
PAGER='vimpager'
EDITOR='vim'

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
alias mkdir='nocorrect mkdir'
alias ls='ls --color=auto -F'
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
PS1="${PR_BLUE}gglucas${PR_LIGHT_GREEN}:${PR_MAGENTA}%~${PR_NO_COLOR}> "

# Functions
websync()
{
    source ~/.rsync_locs
    for name in $@; do
        eval "r=\$RSYNC_$name"
        echo Syncing $name
        echo "rsync -tavz --progress $r"
        echo --------------------
        eval "rsync -tavz --progress $r"
    done
}

convert_mkv()
{
    for e in *.$1; do
        b=$(basename $e .$1).mkv

        if [[ -a $b ]]; then;
            echo $b Exists;
        else
            mkvmerge -o $b $e;
        fi;
    done;
}

jr()
{
    /opt/jdk1.7.0/bin/javac $1.java
    /opt/jdk1.7.0/bin/java $1
}

unzipsep()
{
    for a in *.zip; do o=$(basename $a .zip); mkdir $o; mv $a $o/; cd $o/; unzip $a; cd ..; done;
}
