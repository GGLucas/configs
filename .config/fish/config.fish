#!/bin/fish
set --export -U EDITOR vim
set --export PS1 '\[\033[01;32m\]gglucas\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]> '
set --export BROWSER swtrunk
set fish_greeting ''

#function fish_title
#	echo $PWD ' (' $_ ')' 
#end

function x
    exec startx
end

function prs
    ps -eo pmem,pcpu,args | sort -k 1 -r | less
end

set SHELL (which fish)

set -x LESS_TERMCAP_mb (set_color red --bold)
set -x LESS_TERMCAP_md (set_color blue --bold)
set -x LESS_TERMCAP_me (set_color green --bold)
set -x LESS_TERMCAP_se (set_color green --bold)                         
set -x LESS_TERMCAP_so (set_color green --bold)                              
set -x LESS_TERMCAP_ue (set_color green --bold)
set -x LESS_TERMCAP_us (set_color red --bold)

if test -a /opt/arch32
    function fish_prompt
        echo (set_color blue --bold)'gglucas'
        echo (set_color green --bold)':'
        echo (set_color purple --bold) 
        pwd
        echo (set_color $fish_color_normal --bold)'> '
    end
else
    function fish_prompt
        echo (set_color red --bold)'l32-'
        echo (set_color blue --bold)'gglucas'
        echo (set_color green --bold)':'
        echo (set_color purple --bold) 
        pwd
        echo (set_color $fish_color_normal --bold)'> '
    end
end


function make
    make -j3 $argv
end

function rmspaces
    ls | while read FILE
        mv -v "$FILE" (echo $FILE | tr ' ' '_' )
    end
end

function a
    cd ~
    clear
end

function 3
    a
end

function start
    exec screen -S (tty | sed 's/\//_/g')
end


