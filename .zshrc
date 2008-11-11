# history
HISTFILE=~/.zsh_history
HISTSIZE=9000
SAVEHIST=9000
setopt   appendhistory allexport
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
autoload colors zsh/terminfo

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof

if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

# default apps
PAGER='vimpager'
EDITOR='vim'

# prompt
PS1="${PR_BLUE}gglucas${PR_LIGHT_GREEN}:${PR_MAGENTA}%~${PR_NO_COLOR}> "
#RPS1="$terminfo[color14](%D{%d %b, %H:%M})$PR_NO_COLOR"

# vi editing
bindkey -v
bindkey ' ' magic-space
bindkey "^r" history-incremental-search-backward
bindkey "^[OA" up-line-or-search
bindkey "^[OB" down-line-or-search
bindkey "^[[A" up-line-or-search
bindkey "^K" kill-line
bindkey "^[[B" down-line-or-search

# colorful listings
zmodload -i zsh/complist
autoload -U compinit
compinit

# aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias ls='ls --color=auto -F'
alias no='ls'

alias pp='sudo pacman-color'
alias yy='yaourt'

# 'less' colors
export LESS_TERMCAP_mb="$terminfo[bold]$fg[red]"
export LESS_TERMCAP_md="$terminfo[bold]$fg[blue]"
export LESS_TERMCAP_me="$terminfo[bold]$fg[green]"
export LESS_TERMCAP_se="$terminfo[bold]$fg[green]"
export LESS_TERMCAP_so="$terminfo[bold]$fg[green]"
export LESS_TERMCAP_ue="$terminfo[bold]$fg[green]"
export LESS_TERMCAP_us="$terminfo[bold]$fg[red]"

# functions
mdc() { mkdir -p "$1" && cd "$1" }
setenv() { export $1=$2 }  # csh compatibility
pc() { awk "{print \$$1}" }
rot13 () { tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" }

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

export color=

# Make cd push the old directory onto the directory stack.
set -o AUTO_PUSHD

# don't push duplicate directories
set -o PUSHD_IGNORE_DUPS

alias dv="dirs -v"

# clear dirs from dirstack
# usage:
#    cld               - delete all entries in dirstack
#    cld entry         - delete nth entry in dirstack
#    cld entry1 entry2 - delete range of entries in dirstack
cld () {

   # if no args given, wipe out dirstack
   if [ "$#" -eq "0" ]; then
      dirs "."
      popd
      return
   fi

   # remove ranges of directory from dirstack
   if [ "$#" -eq "1" ]; then
      # if one arg given, wipe out that single dirstack entry
      num1=$1
      num2=$1
   else
      # delete ranges of directories from dirstack
      num1=$1
      num2=$2
   fi

   range=$(( $num2 - $num1 +1 ))

   dirstackindex=0
   while [[ $dirstackindex -lt $range ]]; do
      popd +$num1 > /dev/null
      dirstackindex=$(( $dirstackindex + 1 ))
   done
   dirs -v
}

# cd into a directory on the dirstack
# usage:
#    pd       - "pop" first directory off dirstack, cd into second dir
#    pd entry - cd into nth entry in dirstack
pd() {
   if [ $# -gt 0 ]; then
      cd ~+$1
      dv
   else
      cld 0
   fi
}
