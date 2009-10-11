" 
" Lucas de Vries' .vimrc
" Nick: GGLucas
" Mail: lucas@glacicle.com
" Website: lucas.glacicle.com
"

" {{{ Key Mappings
" Leader
let mapleader=","

" {{{ Window/split navigation
nmap <C-H> <C-w>h
nmap <C-J> <C-w>j
nmap <C-K> <C-w>k
nmap <C-L> <C-w>l
" }}}

" {{{ Basic shortcuts
" Handy shortcut for save
nmap <silent> e :w<CR>

" To prevent annoying mispresses
vmap K k
nmap Q <Nop>

" Return to visual mode after indenting
vmap < <gv
vmap > >gv

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Quickly send keys to a screen session through slime.vim
" Allows for test-execution of scripts and whatnot without leaving vim.
nmap <C-c>m :call Send_to_Screen("<C-v>")<CR>
nmap <C-c>c :call Send_to_Screen("<C-v>OA<C-v>")<CR>
nmap <C-c>r :call Send_to_Screen(input("send to screen: ")."<C-v>")<CR>
nmap <C-c>g :call Send_to_Screen(input("send to screen: "))<CR>

" {{{ Call ToHTML
nmap <silent> <Leader>html :TOhtml<CR>
            \ :%s/^body { .* }$/body { font-family: monospace;
            \ color: #ffffff; background-color: #2E3436; }/g<CR>:
            \ %s/^pre { .* }$/pre { font-family: monospace;
            \ color: #ffffff; background-color: #2E3436; }/g<CR><F7>

vmap <silent> <Leader>html :TOhtml<CR>
            \ :%s/^body { .* }$/body { font-family: monospace;
            \ color: #ffffff; background-color: #2E3436; }/g<CR>:
            \ %s/^pre { .* }$/pre { font-family: monospace;
            \ color: #ffffff; background-color: #2E3436; }/g<CR><F7>
" }}}
" }}}

" {{{ Spellcheck
nmap <Leader>hh :set nospell<CR>
nmap <Leader>he :set spell spelllang=en<CR>
nmap <Leader>hn :set spell spelllang=nl<CR>
" }}}

" {{{ Buffer Navigation
nmap <silent> gb :bprev<CR>
nmap <silent> gn :bnext<CR>
nmap <silent> gl :e .<CR>

nmap <silent> ,g :FuzzyFinderBuffer<CR>
nmap <silent> ,f :FuzzyFinderFile<CR>

noremap <silent> <Esc>w :bnext<CR>
noremap <silent> <Esc>v :bprev<CR>
" }}}

" {{{ Opening different plugin windows
nmap <silent> ;p :NERDTree<CR>
nmap <silent> ;. :MyBuf<CR>
nmap <silent> ;; :MyBufDestroy<CR>;p;.
" }}}

" {{{ Command line cursor keys
cnoremap <C-H> <Left>
cnoremap <C-L> <Right>
cnoremap <C-X> <Delete>
cnoremap <C-J> <Down>
cnoremap <C-K> <Up>
cnoremap <Esc>j <Down>
cnoremap <Esc>k <Up>
cnoremap <Esc>c <C-c>:
" }}}

" {{{ Function key shortcuts
" F5: Paste toggle
nnoremap <F5> :set paste!<Bar>set paste?<CR>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" F6: Textwidth Toggle
nnoremap <F6> :call TextwidthToggle()<CR>
imap <F6> <C-O><F6>

" F7: Search highlight toggle
nmap <F7> :noh<CR>
imap <F7> <C-O><F7>

" F8: Toggle list mode
nmap <F8> :set list!<Bar>set list?<CR>
imap <F8> <C-O><F8>
" }}}
" }}}

" {{{ Plugin Settings
" NERD Commenter
let NERDDefaultNesting = 1
let NERDShutUp = 1

" NERD Tree
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$', '\.class$', '\.o$']

" Pydoc
let g:pydoc_highlight = 0

" Python syntax
let python_highlight_all = 1
let python_highlight_space_errors = 0

" }}}

" {{{ Vim Settings
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
" Use UTF-8 encoding
set encoding=utf-8

" Don't highlight the current line
set nocursorline

" Characters to use in list mode
set listchars=eol:$,tab:>-,trail:·

" Enter spaces when tab is pressed:
set expandtab

" Always display statusline
set laststatus=2

" Text width
let g:textwidth=0
set textwidth=0

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

" Use actual block mode for visual block
set virtualedit=block

" Viminfo
set viminfo='1000,f1,<500,:500,/500,h

" Global match by default
set gdefault

" Format (gq) options
set formatoptions+=w

" Highlight search
set hls

" Don't fold less than 2 lines
set foldminlines=2

" Use fancy css for TOhtml
let html_use_css=1

" Filetype
filetype plugin on
filetype indent on

" Syntax highlighting
syntax on
" }}}

" {{{ Autocommands
" Read-only .doc through antiword
autocmd BufReadPre *.doc silent set ro
autocmd BufReadPost *.doc silent %!antiword "%"

" Read-only odt/odp through odt2txt
autocmd BufReadPre *.odt,*.odp silent set ro
autocmd BufReadPost *.odt,*.odp silent %!odt2txt "%"

" Read-only pdf through pdftotext
autocmd BufReadPre *.pdf silent set ro
autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -csw78

" Read-only rtf through unrtf
autocmd BufReadPre *.rtf silent set ro
autocmd BufReadPost *.rtf silent %!unrtf --text

" HTML Indent
autocmd BufEnter *.html silent setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufEnter *.html silent filetype indent off
autocmd BufEnter *.html silent setlocal ai

" SASS Indent
autocmd BufEnter *.sass silent setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufEnter *.sass silent filetype indent off
autocmd BufEnter *.sass silent setlocal ai

" Don't show space errors
autocmd BufEnter *.py hi pythonSpaceError ctermbg=black

" Highlight long lines
augroup hiLong
autocmd BufRead * let w:m1=matchadd('StatusLine', '\%<81v.\%>77v', -1)
autocmd BufRead * let w:m2=matchadd('IncSearch', '\%>80v.\+', -1)
augroup END

" Jump to last known cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" }}}

" {{{ Functions
" {{{ TextwidthToggle(): Change textwidth, 0<->78
function! TextwidthToggle()
    if g:textwidth == 0
        let g:textwidth = 78
        set textwidth=78
    else
        let g:textwidth = 0
        set textwidth=0
    endif

    set textwidth?
endfunction
" }}}
" }}}
