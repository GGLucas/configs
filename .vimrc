set nocompatible

" Maps
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

" Plugin vars
let NERDDefaultNesting = 1
let NERDShutUp = 1

" Color Scheme
colorscheme darkspectrum

highlight Pmenu ctermbg=139 ctermfg=0
highlight PmenuSel ctermbg=11 ctermfg=0
highlight PmenuSbar ctermbg=248 ctermfg=0
highlight Statement cterm=bold

" Color scheme for vc
if $TERM == 'linux'
    colorscheme default
else
    set t_Co=256
endif

" Config
" enter spaces when tab is pressed:
set expandtab

" do not break lines when line lenght increases
set textwidth=72

" user 4 spaces to represent a tab
set tabstop=4
set softtabstop=4

" number of space to use for auto indent
" you can use >> or << keys to indent current line or selection
" in normal mode.
set shiftwidth=4

" Copy indent from current line when starting a new line.
set autoindent

" makes backspace key more powerful.
set backspace=indent,eol,start

" shows the match while typing
set incsearch

" case insensitive search
set ignorecase

" show line and column number
set number

" allow hidden buffers with changes
set hidden

" show some autocomplete options in status bar
set wildmenu

" show matching
set showmatch

" indent folds
set foldmethod=marker

" remember history
set history=50
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100

" other
set wrap
set gdefault

" syntax highlight
syntax on
