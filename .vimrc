imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>

nmap <C-H> <C-w>h
nmap <C-J> <C-w>j
nmap <C-K> <C-w>k
nmap <C-L> <C-w>l

imap <S-Tab> <C-d>

nmap gb :bprevious<CR>
nmap gn :bnext<CR>
nmap gj <C-f>
nmap gk <C-b>
nmap gl :Ex<CR> 
nmap e :w<CR>
nmap <Leader>cd :colorscheme default<CR>
nmap <Leader>fd :set fdm=marker<CR>
nmap <Leader>ff :set fdm=indent<CR>

vmap K k

set nocompatible

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set nobackup
set showmatch
set modeline
syntax on

nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>
set number
colorscheme darkspectrum

highlight Pmenu ctermbg=139 ctermfg=0
highlight PmenuSel ctermbg=11 ctermfg=0
highlight PmenuSbar ctermbg=248 ctermfg=0
highlight Statement cterm=bold

if $SHELL =~ 'bin/fish'
    set shell=/bin/sh
endif

let NERDDefaultNesting = 1
let NERDShutUp = 1
"set vb t_vb=""
"autocmd VimEnter * set vb t_vb=

if $TERM == 'linux'
    colorscheme default
else
    set t_Co=256
endif
