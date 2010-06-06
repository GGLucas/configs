"
" Lucas de Vries' .vimrc
" Nick: GGLucas
" Mail: lucas@glacicle.org
" Website: lucas.glacicle.org
"

" {{{ Key mappings
"" {{{ Convenience shortcuts
""" {{{ Mapleader
let mapleader=","
""" }}}
""" {{{ File actions
" Handy shortcut for save
nmap <silent> e :up<CR>

" Put current path in commandline
cmap ∩ <C-R>=expand("%:h")."/"<CR>

" Prompt for filetype to set
nmap <Leader>@ :call PromptFT(0)<CR>
nmap <Leader>? :call PromptFT(1)<CR>

" Close everything
nmap ZN :wqa<CR>
""" }}}
""" {{{ Window navigation
nmap <Left> <C-w>h
nmap <Down> <C-w>j
nmap <Up> <C-w>k
nmap <Right> <C-w>l
nmap ☆ <C-w>w
nmap ▫ <C-w>W
nmap ,sp :vsp<CR>
nmap ,on :on<CR>
""" }}}
""" {{{ Buffer navigation
nmap <silent> ∩ :A<CR>
nmap <silent> ∪ :e .<CR>
nmap <silent> <Leader>- <C-^>

nmap <silent> ♥ :bnext<CR>
nmap <silent> √ :bprev<CR>
""" }}}
""" {{{ Editing shortcuts
" Creating new lines without comment leader
nmap go o<Esc>S
nmap gO O<Esc>S

" Return to visual mode after indenting
xmap < <gv
xmap > >gv

" Consistency!
nnoremap Y y$

" Minus to eol, since underscore is bol
nmap - $

" Use ,, for regular , (since it's the leader)
nnoremap ,, ,

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Clear screen and remove highlighting
nnoremap <silent> <C-l> :nohl<CR>

" Camel case word edit
nmap <silent> <Leader>ciw ci,w

" Toggle textwidth
nmap <Leader>/ :call TextwidthToggle()<CR>

" Toggle line numbers
nmap <Leader>c :call NuToggle()<CR>
""" }}}
""" {{{ Spellcheck
nmap <Leader>ss :set nospell<CR>
nmap <Leader>se :set spell spelllang=en<CR>
nmap <Leader>sn :set spell spelllang=nl<CR>
""" }}}
""" {{{ Quickfix window
nmap <silent> <Leader>vp :call Pep8()<CR>
nmap <silent> <Leader>vc :cclose<CR>
nmap <silent> <Leader>vn :cnext<CR>
nmap <silent> <Leader>vN :cprev<CR>
""" }}}
""" {{{ Remove inconvenient binds
xmap K k
nmap Q <Nop>
""" }}}
"" }}}
"" {{{ Plugin bindings
""" {{{ Bisect
nmap ↓ <Plug>BisectDown
nmap ↑ <Plug>BisectUp
nmap ← <Plug>BisectLeft
nmap → <Plug>BisectRight
nmap Æ <Plug>StopBisect

xmap ↓ <Plug>VisualBisectDown
xmap ↑ <Plug>VisualBisectUp
xmap ← <Plug>VisualBisectLeft
xmap → <Plug>VisualBisectRight
xmap Æ <Plug>VisualStopBisect
""" }}}
""" {{{ Command-T
nmap <silent> <Leader>T :CommandTFlush<CR>
""" }}}
""" {{{ Lusty Explorer
nmap <silent> <Leader>n :LustyBufferExplorer<CR>
nmap <silent> <Leader>G :LustyFilesystemExplorer<CR>
nmap <silent> <Leader>r :LustyFilesystemExplorerFromHere<CR>
""" }}}
""" {{{ Taglist
nmap <silent> <Leader>l :TlistOpen<CR>
nmap <silent> <Leader>L :TlistToggle<CR>
""" }}}
""" {{{ NERD Tree
nmap <silent> <Leader>h :call TreeOpenFocus()<CR>
nmap <silent> <Leader>H :NERDTreeToggle<CR>
""" }}}
""" {{{ BClose
nmap <silent> <Leader>d :Bclose<CR>
nmap <silent> <Leader>D :Bclose!<CR>
""" }}}
""" {{{ Operator-Replace
map <Leader>_ <Plug>(operator-replace)
""" }}}
""" {{{ Git extras
nmap <Leader>gL :GitLog HEAD<CR>
nmap <Leader>gC :GitCommit -s -a<CR>
nmap <Leader>gt :GitCommit -s<CR>
nmap <Leader>gS :GitAdd<Space>
nmap <Leader>gb :GitBlame<CR>
nmap <Leader>gP :GitPull origin master<CR>
nmap <Leader>gr :GitPush<CR>
""" }}}
"" }}}
" }}}
"" {{{ Configuration
"" {{{ Plugin configuration
""" {{{ NERD Commenter
let NERDDefaultNesting = 1
""" }}}
""" {{{ NERD Tree
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$', '\.class$', '\.o$', '\.pyo$']
let NERDTreeSortOrder = ['\/$', '\.[ch]$', '\.py$', '*']
""" }}}
""" {{{ Taglist
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
let Tlist_Enable_Fold_Column = 0
""" }}}
""" {{{ Python syntax
let python_highlight_all = 1
let python_highlight_space_errors = 0
""" }}}
""" {{{ Command-T
let g:CommandTMaxHeight = 10
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTScanDotDirectories = 1
""" }}}
""" {{{ snipMate
let g:snips_author = "Lucas de Vries"
let g:snips_mail = "lucas@glacicle.org"
""" }}}
""" {{{ delimitMate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
""" }}}
""" {{{ superTab
let g:SuperTabDefaultCompletionType = "<c-n>"
""" }}}
""" {{{ ZenCoding
let g:user_zen_settings = {'indentation': '  ',}
let g:user_zen_leader_key = '<C-t>'
""" }}}
""" {{{ Don't load ruby
if !has('ruby')
    let g:command_t_loaded = 1
    let g:loaded_lustyexplorer = 1
endif
""" }}}
"" }}}
"" {{{ Vim settings
""" {{{ General
" Use UTF-8 encoding
set encoding=utf-8

" Allow hidden buffers with changes
set hidden

" Put swapfiles in central directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Data to store in the viminfo file
set viminfo='100,f1,<50,:50,/50,h,!

" File patterns to ignore in completions
set wildignore=*.o,*.pyc,*.pyo,.git,.svn

" Don't use filetype indent
filetype on
filetype plugin on
filetype indent off
""" }}}
""" {{{ Mappings
""" }}}
""" {{{ Display
" Characters to use in list mode
set listchars=tab:│\ ,trail:·
set list

" Always display statusline
set laststatus=2

" Show chain while typing
set showcmd

" Show search match while typing
set incsearch

" Show line and column number
set number
set ruler

" Show matching brackets when typed
set showmatch

" Number of lines from the edge to scroll
set scrolloff=3

" Display shorter messages
set shortmess=aAtI

" Don't show so many completions
set pumheight=8

" Highlight matches on a search
set hls

" Don't fold less than 2 lines
set foldminlines=2

" Highlight syntax
syntax on
""" }}}
""" {{{ Editing
" Text width
let g:textwidth=0
set textwidth=0

" Use actual block mode for visual block
set virtualedit=block

" Global match by default
set gdefault

" Smart case insensitive search
set ignorecase
set smartcase
""" }}}
""" {{{ Formatting
" Enter spaces when tab is pressed:
set expandtab

" Use 4 spaces to represent a tab
set tabstop=4
set softtabstop=4

" Number of spaces to use for auto indent
set shiftwidth=4

" Copy indent from current line when starting a new line
set autoindent

" Don't go mad reindenting
set cinkeys="0{,0},0)"

" Allow backspacing over more items
set backspace=indent,eol,start

" Options for formatting blocks (gq)
set formatoptions=tcn12
""" }}}
""" {{{ Colors
" Color Schemes
if $TERM == 'linux'
    " Virtual Console
    colorscheme delek
else
    " Color terminal
    set t_Co=256
    colorscheme customleo
endif
""" }}}
"" }}}
" }}}
" {{{ Autocommands
"" {{{ Filetype filters
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
"" }}}
"" {{{ Filetype detection
autocmd BufReadPre Cakefile silent set filetype=yaml
autocmd BufNewFile,BufRead *.{md,mkd,mark,markdown} set ft=markdown
autocmd BufNewFile,BufRead *.tex set ft=tex
autocmd BufNewFile,BufRead *.go set ft=go
autocmd BufNewFile,BufRead COMMIT_EDITMSG set ft=gitcommit
"" }}}
"" {{{ Filetype settings
" Files to indent with two spaces
autocmd FileType xhtml,html,xml,sass,tex,plaintex,yaml silent setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Set correct folding for C
autocmd FileType c silent setlocal fdm=syntax fdn=1
autocmd FileType c set cindent

" Git: Don't jump to last position, no modeline
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
autocmd FileType git setlocal nomodeline

" Files to set default textwidth
autocmd FileType mail,tex set textwidth=78
autocmd FileType mail,tex let g:textwidth=78
"" }}}
"" {{{ Filetype highlighting
" Python keywords
autocmd FileType python syn keyword Identifier self
autocmd FileType python syn keyword Type True False None

" Javascript let and braces
autocmd FileType javascript syn keyword javascriptIdentifier "let"
autocmd FileType javascript hi link javaScriptBraces Braces

" TeX zone
autocmd FileType tex,plaintex hi link TexZone Comment

" Mail header highlighting
autocmd FileType mail hi link mailHeader Comment
autocmd FileType mail hi link mailSubject Function
"" }}}
"" {{{ Other
" Rainbow Parenthesis
command Rainbow so ~/.vim/plugin/RainbowParenthsis.vim
autocmd BufReadPost * Rainbow

" Jump to last known cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif
"" }}}
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
" {{{ NuToggle(): Toggle between abs/rel nu
let g:nu = 0
function! NuToggle()
    if g:nu == 0
        let g:nu = 1
        set rnu
    else
        let g:nu = 0
        set nu
    endif
endfunction
" }}}
"" {{{ TreeOpenFocus(): Open the nerd tree or focus it.
function! TreeOpenFocus()
    let wnr = bufwinnr("NERD_tree_1")
    if wnr == -1
        :NERDTreeToggle
    else
        exec wnr."wincmd w"
    endif
endfunction
"" }}}
" {{{ PromptFT(): Prompt for a new filetype to set
function! PromptFT(show)
    let def = ""

    if a:show == 1
        let def = &ft
    endif

    let ft = input("Filetype: ", def)
    if ft != ""
        exec "setlocal ft=".ft
        Rainbow
    end
endfunction
" }}}
" }}}

" vim:fdm=marker
