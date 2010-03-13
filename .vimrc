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
nmap <Esc>h <C-w>h
nmap <Esc>j <C-w>j
nmap <Esc>k <C-w>k
nmap <Esc>l <C-w>l
nmap <Esc>n <C-w>W
nmap <Esc>t <C-w>w
" }}}

" {{{ Basic shortcuts
" Handy shortcut for save
noremap <Leader>e e
noremap <silent> e :w<CR>

" Meta-o for inserting a blank line
noremap <Esc>o o<Esc>

" O mappings for not inserting the comment leader
noremap go o<Esc>S
noremap gO O<Esc>S

" To prevent annoying mispresses
vmap K k
nmap Q <Nop>

" Use ,, to work around , as leader
noremap ,, ,

" Return to visual mode after indenting
vmap < <gv
vmap > >gv

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Search for word under cursor without moving
noremap <Leader># #*
noremap <Leader>* *#

" Clear screen and remove highlighting
nnoremap <silent> <Esc><C-l> :nohl<CR><C-l>
nnoremap <silent> <C-l> :nohl<CR>

" Prompt for a filetype to set
nmap <silent> <Esc>@ :call PromptFT()<CR>

" Quickly send keys to a screen session through slime.vim
" Allows for test-execution of scripts and whatnot without leaving vim.
nmap <C-c>m :call Send_to_Screen("<C-v>")<CR>
nmap <C-c>c :call Send_to_Screen("<C-v>OA<C-v>")<CR>
nmap <C-c>r :call Send_to_Screen(input("send to screen: ")."<C-v>")<CR>
nmap <C-c>g :call Send_to_Screen(input("send to screen: "))<CR>

" }}}

" {{{ Spellcheck
nmap <Leader>ss :set nospell<CR>
nmap <Leader>se :set spell spelllang=en<CR>
nmap <Leader>sn :set spell spelllang=nl<CR>
" }}}

" {{{ Buffer Navigation
nnoremap <silent> <Esc>c :A<CR>
nnoremap <silent> <Esc>b :e .<CR>

nnoremap <silent> <Esc>w :bnext<CR>
nnoremap <silent> <Esc>v :bprev<CR>

nnoremap <silent> <Leader>g :BufferExplorer<CR>
nnoremap <silent> <Leader>f :FilesystemExplorer<CR>
nnoremap <silent> <Leader>F :FilesystemExplorerFromHere<CR>
" }}}

" {{{ Opening different plugin windows
nmap <silent> <Leader>n :call TreeOpenFocus()<CR>
nmap <silent> <Leader>N :NERDTreeToggle<CR>
nmap <silent> <Leader>t :TlistOpen<CR>
nmap <silent> <Leader>T :TlistToggle<CR>
nmap <silent> <Leader>s :SessionList<CR>
nmap <silent> <Leader>S :SessionSave<CR>

nmap <silent> <Leader>d :Bclose<CR>
nmap <silent> <Leader>bd :Bclose!<CR>

nmap <Leader>h :vert bo help 
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

" {{{ Bisect keys
nmap ↓ <Plug>BisectDown
nmap ↑ <Plug>BisectUp
nmap ← <Plug>BisectLeft
nmap → <Plug>BisectRight
nmap § <Plug>StopBisect
" }}}

" {{{ Function key shortcuts
" F5: Toggle paste mode
nnoremap <F5> :set paste!<Bar>set paste?<CR>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" F6: Toggle whether to use textwidth or not
nnoremap <F6> :call TextwidthToggle()<CR>
imap <F6> <C-O><F6>
nmap <Leader>tw <F6>

" F7: Turn search highlight off until next search
nmap <F7> :noh<CR>
imap <F7> <C-O><F7>

" F8: Toggle list mode
nmap <F8> :set list!<Bar>set list?<CR>
imap <F8> <C-O><F8>

" F9: Toggle highlighting long lines
nmap <F9> :call HighlightLongToggle()<CR>
imap <F9> <C-O><F9>
nmap <Leader>hl <F9>

" Turn autoclose on/off
noremap <silent> <Leader>an :let delimitMate_autoclose = 1 \| :DelimitMateReload<CR>
noremap <silent> <Leader>ar :let delimitMate_autoclose = 0 \| :DelimitMateReload<CR>

" }}}

" {{{ Plugin binds
inoremap <C-e> <Esc>:norm <C-y>,<C-y>n<CR>
nnoremap <C-t> <Esc>:norm <C-y>n
" }}}

" }}}

" {{{ Plugin Settings
" NERD Commenter
let NERDDefaultNesting = 1

" NERD Tree
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$', '\.class$', '\.o$']
let NERDTreeSortOrder = ['\/$', '\.[ch]$', '\.py$', '*']

" Taglist
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1

" Pydoc
let g:pydoc_highlight = 0

" Python syntax
let python_highlight_all = 1
let python_highlight_space_errors = 0

" Buffer tabs in statusline
let g:buftabs_active_highlight_group = "Visual"
let g:buftabs_in_statusline = 1
let g:buftabs_only_basename = 1

" Use fancy css for TOhtml
let html_use_css = 1

" Lusty Explorer
let g:LustyJugglerSuppressRubyWarning = 1

" delemitMate
let delimitMate_expand_space = "\<Space>\<Space>\<Left>"
let delimitMate_expand_cr = "\<CR>\<CR>\<Up>\<Tab>"
let delimitMate_apostrophes = ""
let delimitMate_quotes = "\""

" ZenCoding
let g:user_zen_settings = { 'indentation': '  ', }
let g:user_zen_leader_key = '<C-t>'

" }}}

" {{{ Vim Settings
" Color Schemes
if $TERM == 'linux'
    " Virtual Console
    colorscheme default
else
    " Oblivion
    set t_Co=256
    colorscheme oblivion
endif

" Config
" Use UTF-8 encoding
set encoding=utf-8

" Don't highlight the current line
set nocursorline

" Characters to use in list mode
set listchars=tab:▸\ ,trail:·
set list

" Enter spaces when tab is pressed:
set expandtab

" Always display statusline
set laststatus=2

" Statusline information
set statusline=%=%P\ 

" Text width
let g:textwidth=0
set textwidth=0

" Show command while typing
set showcmd

" Wrap lines
set wrap

" Use 4 spaces to represent a tab
set tabstop=4
set softtabstop=4

" Number of spaces to use for auto indent
set shiftwidth=4

" Copy indent from current line when starting a new line
set autoindent

" Makes the backspace key more powerful
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

" Automatically switch to the directory we're editing in
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
set viminfo='100,f1,<50,:50,/50,h,!

" Global match by default
set gdefault

" Format (gq) options
set formatoptions+=w

" Highlight search
set hls

" Don't fold less than 2 lines
set foldminlines=2

" Filetype
filetype on
filetype plugin on
filetype indent off

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
autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

" Read-only rtf through unrtf
autocmd BufReadPre *.rtf silent set ro
autocmd BufReadPost *.rtf silent %!unrtf --text

" Files to indent with two spaces
autocmd FileType xhtml,html,xml,sass,tex,plaintex silent setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Set correct folding
autocmd FileType c silent setlocal fdm=syntax fdn=1

" Highlight "self" in python
autocmd FileType python syn keyword Identifier self

" Highlight section as comment in TeX
autocmd FileType tex,plaintex hi link TexZone Comment

" Highlight braces with braces style
autocmd FileType xhtml,html hi link htmlEndTag BoldBraces
autocmd FileType xml hi link xmlEndTag BoldBraces
autocmd FileType javascript hi link javaScriptBraces Braces

" Set markdown syntax
autocmd BufNewFile,BufRead *.{md,mkd,mark,markdown} set ft=markdown
autocmd BufNewFile,BufRead *.tex set ft=tex

" Highlight long lines
autocmd BufRead * let w:longmatch = matchadd('MoreMsg', '\%<81v.\%>77v', -1)
autocmd BufRead * let w:toolongmatch = matchadd('Folded', '\%>80v.\+', -1)

" Highlight dirslash correctly
hi link treeDirSlash Function

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

" {{{ HighlightLongToggl(): Toggle highlighting of long lines
function! HighlightLongToggle()
    if exists('w:longmatch')
        call matchdelete(w:longmatch)
        call matchdelete(w:toolongmatch)
        unlet w:longmatch
        unlet w:toolongmatch
        echo "  don't highlight long"
    else
        let w:longmatch = matchadd('MoreMsg', '\%<81v.\%>77v', -1)
        let w:toolongmatch = matchadd('Folded', '\%>80v.\+', -1)
        echo "  highlight long"
    endif
endfunction
" }}}

" {{{ TreeOpenFocus(): Open the nerd tree or focus it.
function! TreeOpenFocus()
    let wnr = bufwinnr("NERD_tree_1")
    if wnr == -1
        :NERDTreeToggle
    else
        exec wnr."wincmd w"
    endif
endfunction
" }}}

" {{{ PromptFT(): Prompt for a new filetype to set
function! PromptFT()
    let ft=input("Filetype: ")
    exec "setlocal ft=".ft
endfunction
" }}}
" }}}
" vim:fdm=marker
