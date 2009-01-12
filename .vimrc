" Leader
let mapleader=","

" Use UTF-8 encoding
set encoding=utf-8

" Window/split navigation
nmap <C-H> <C-w>h
nmap <C-J> <C-w>j
nmap <C-K> <C-w>k
nmap <C-L> <C-w>l

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
nmap <silent> gl :e .<CR>

" Opening different plugin windows
nmap <silent> ;p :NERDTree<CR>
nmap <silent> ;. :MyBuf<CR>
nmap <silent> ;; :MyBufDestroy<CR>;p;.

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

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Function key shortcuts
"" F4: Textwidth On
nnoremap <F4> :set textwidth=78<CR>
imap <F4> <C-O><F4>

"" F5: Paste toggle
nnoremap <F5> :set paste!<Bar>set paste?<CR>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

"" F6: Textwidth Off
nnoremap <F6> :set textwidth=0<CR>
imap <F6> <C-O><F6>

"" F7: Search highlight toggle
nmap <F7> :set hls!<Bar>set hls?<CR>

" NERD Commenter
let NERDDefaultNesting = 1
let NERDShutUp = 1

" NERD Tree
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$', '\.class$']

" Pydoc
let g:pydoc_highlight = 0

" Python syntax
let python_highlight_all = 1
let python_highlight_space_errors = 0

" Django projects
source ~/.vim/plugin/django_projects.vim
let g:django_terminal_program = "urxvtc -e"

call g:DjangoInstall('doremi', '/data/web/doremi/', 'settings', 'manage.py', ['/data/web/doremi', '/data/web'], '')

" Color Schemes
if $TERM == 'linux'
    " Virtual Console
    colorscheme default
else
    " Regular
    set t_Co=256
    colorscheme oblivion
endif

" Config
" Enter spaces when tab is pressed:
set expandtab

" Text width
set textwidth=78

" Wrap lines
set wrap

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
set smartcase

" Show line and column number
set number
set ruler

" Allow hidden buffers with changes
set hidden

" Autocd
set autochdir

" Show matching
set showmatch

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

" Read-only .doc through antiword
autocmd BufReadPre *.doc set ro
autocmd BufReadPost *.doc %!antiword "%"

" Read-only odt/odp through odt2txt
autocmd BufReadPre *.odt,*.odp set ro
autocmd BufReadPost *.odt,*.odp %!odt2txt "%"

" Read-only pdf through pdftotext
autocmd BufReadPre *.pdf set ro
autocmd BufReadPost *.pdf %!pdftotext "%" -

" Autocommands
autocmd BufEnter *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufEnter *.html filetype indent off
autocmd BufEnter *.html setlocal ai

autocmd BufEnter *.ccss setlocal syn=ccss
