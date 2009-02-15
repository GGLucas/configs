# Applications
export PAGER='vimpager'
export EDITOR='vim'
export BROWSER='fx'

# Options
shopt -s autocd cdspell
shopt -s dirspell extglob
shopt -s cmdhist

# Aliases
alias ls='ls --color=auto -F --group-directories-first'
alias no='ls'
alias x='exec x'

# Prompt
PS1="\[\e[1;35m\]\w \[\e[1;37m\]\$ \[\e[0;37m\]"

export color=
