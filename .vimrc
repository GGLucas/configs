" Leader
let mapleader=","

" Use UTF-8 encoding
set encoding=utf-8

" Window/split navigation
nmap <C-H> <C-w>h
nmap <C-J> <C-w>j
nmap <C-K> <C-w>k
nmap <C-L> <C-w>l

" Previous completion
imap <S-Tab> <C-d>

" Handy shortcut for save
nmap e :w<CR>

" Fold methods
nmap <Leader>fd :set fdm=marker<CR>
nmap <Leader>ff :set fdm=indent<CR>

" Text width
nmap <Leader>tw :set textwidth=0<CR>

" Spellcheck
nmap <Leader>hh :set nospell<CR>
nmap <Leader>he :set spell spelllang=en<CR>
nmap <Leader>hn :set spell spelllang=nl<CR>

" Buffer Navigation
nmap <silent> gb :bprevious<CR>
nmap <silent> gn :bnext<CR>
nmap <silent> gl :Ex<CR>

" To prevent K mispresses right after V
vmap K k

" Command line cursor keys
cnoremap <C-H> <Left>
cnoremap <C-J> <Up>
cnoremap <C-K> <Down>
cnoremap <C-L> <Right>
cnoremap <C-X> <Delete>
cnoremap <Esc>h <S-Left>
cnoremap <Esc>l <S-Right>

" NERD Commenter
let NERDDefaultNesting = 1
let NERDShutUp = 1

" Color Scheme
colorscheme darkspectrum

" Extra highlights
highlight Pmenu ctermbg=139 ctermfg=0
highlight PmenuSel ctermbg=11 ctermfg=0
highlight PmenuSbar ctermbg=248 ctermfg=0
highlight Statement cterm=bold

" Lusty Explorer
nmap <silent> <Leader>y :CMiniBufExplorer<CR>:FilesystemExplorer<CR>
nmap <silent> <Leader>d :CMiniBufExplorer<CR>:FilesystemExplorerFromHere<CR>
nmap <silent> <Leader>g :CMiniBufExplorer<CR>:BufferExplorer<CR>

" Minibufexpl
let g:miniBufExplorerMoreThanOne=2

" Color scheme for vc
if $TERM == 'linux'
    colorscheme default
else
    set t_Co=256
endif

" Config
" Enter spaces when tab is pressed:
set expandtab

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Text width
set textwidth=76

" Use 4 spaces to represent a tab
set tabstop=4
set softtabstop=4

" Number of spaces to use for auto indent
set shiftwidth=4

" Copy indent from current line when starting a new line.
set autoindent

" Makes the backspace key more powerful.
set backspace=indent,eol,start

" Shows the match while typing
set incsearch

" Case insensitive search
set ignorecase

" Show line and column number
set number
set ruler

" Allow hidden buffers with changes
set hidden

" Show some autocomplete options in status bar
set wildmenu
set wildmode=list:longest,full

" Autocd
set autochdir

" Show matching
set showmatch

" Fold methods
set foldmethod=indent

" Remember history
set history=100

" Scrolloff
set scrolloff=3

" Shortmess
set shortmess=atI

" Swap files
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Viminfo
set viminfo='1000,f1,<500,:500,/500,h

" Filetype
filetype plugin on
filetype indent on

" Global match by default
set gdefault

" Syntax highlighting
syntax on
