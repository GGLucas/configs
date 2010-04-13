" 
" Lucas de Vries' .vimrc
" Nick: GGLucas
" Mail: lucas@glacicle.org
" Website: lucas.glacicle.org
"

" {{{ Key Mappings
" Leader
let mapleader=","
" {{{ Window/split navigation
nmap <Left> <C-w>h
nmap <Down> <C-w>j
nmap <Up> <C-w>k
nmap <Right> <C-w>l
nmap ☆ <C-w>w
nmap ▫ <C-w>W
" }}}
" {{{ Basic shortcuts
" Handy shortcut for save
nmap <silent> e :up<CR>

" Shortcuts for edit in the current file's directory
nmap zew :e <C-R>=expand("%:h")."/"<CR>
nmap zes :sp <C-R>=expand("%:h")."/"<CR>
nmap zev :vsp <C-R>=expand("%:h")."/"<CR>
nmap zed :lcd %:p:h<CR>

" Meta-o for inserting a blank line
nmap <Esc>o o<Esc>

" O mappings for not inserting the comment leader
nmap go o<Esc>S
nmap gO O<Esc>S
nmap gno o<Esc>I
nmap gho o<Backspace>
nmap gto o<Tab>

" To prevent annoying mispresses
xmap K k
nmap Q <Nop>

" Consistency!
nnoremap Y y$

" Map minus to end of line
nmap - $

" Mod5+Enter to next line and indent more or less
imap ァ <Return><Tab>
imap ィ <Return><Backspace>
nmap ァ gto
nmap ィ gho

" Use ,, to work around , as leader
nnoremap ,, ,

" Return to visual mode after indenting
xmap < <gv
xmap > >gv

" Swap ' and ` so it goes to the column too by default
nnoremap ` '
nnoremap ' `

" Quit all easily
nmap ZVQ :qa<CR>
nmap ZVZ :wqa<CR>

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Search for word under cursor without moving
nmap <Leader># #*
nmap <Leader>* *#

" Clear screen and remove highlighting
nnoremap <silent> <Esc><C-l> :nohl<CR><C-l>
nnoremap <silent> <C-l> :nohl<CR>

" Prompt for a filetype to set
nmap <silent> <Esc>@ :call PromptFT(1)<CR>
nmap <silent> <Esc>^ :call PromptFT(0)<CR>

" Add an ascii line under the current line
nnoremap <Leader>al- yyp^v$r-o<Esc>
nnoremap <Leader>al= yyp^v$r=o<Esc>
nnoremap <Leader>al~ yyp^v$r~o<Esc>

" Quickly send keys to a screen session through slime.vim
" Allows for test-execution of scripts and whatnot without leaving vim.
nmap <C-c>m :call Send_to_Screen("<C-v>")<CR>
nmap <C-c>c :call Send_to_Screen("<C-v>OA<C-v>")<CR>
nmap <C-c>r :call Send_to_Screen(input("send to screen: ")."<C-v>")<CR>
nmap <C-c>g :call Send_to_Screen(input("send to screen: "))<CR>

" Various ways to "decode" a block
map <silent> ,cdb <Esc>:call Base64Decode()<CR>:s/<C-v><C-m>\?<C-@>/<C-v><C-m><CR>
map ,cdl :!elinks -dump<CR>
" }}}
" {{{ Spellcheck
nmap <Leader>ss :set nospell<CR>
nmap <Leader>se :set spell spelllang=en<CR>
nmap <Leader>sn :set spell spelllang=nl<CR>
" }}}
" {{{ Buffer Navigation
nmap <silent> ∩ :A<CR>
nmap <silent> ∪ :e .<CR>

nmap <silent> ♥ :bnext<CR>
nmap <silent> √ :bprev<CR>

nmap <silent> <Leader>- <C-^>
nmap <silent> <Leader>n :LustyBufferExplorer<CR>
nmap <silent> <Leader>G :LustyFilesystemExplorer<CR>
nmap <silent> <Leader>r :LustyFilesystemExplorerFromHere<CR>
" }}}
" {{{ Opening different plugin windows
nmap <silent> <Leader>h :call TreeOpenFocus()<CR>
nmap <silent> <Leader>H :NERDTreeToggle<CR>
nmap <silent> <Leader>l :TlistOpen<CR>
nmap <silent> <Leader>L :TlistToggle<CR>
nmap <silent> <Leader>s :SessionList<CR>
nmap <silent> <Leader>S :SessionSave<CR>
nmap <silent> <Leader>T :CommandTFlush<CR>

nmap <silent> <Leader>d :Bclose<CR>
nmap <silent> <Leader>bd :Bclose!<CR>

nmap <Leader>p :vert bo help 
" }}}
" {{{ Bisect keys
nmap ↓ <Plug>BisectDown
nmap ↑ <Plug>BisectUp
nmap ← <Plug>BisectLeft
nmap → <Plug>BisectRight
nmap § <Plug>StopBisect

xmap ↓ <Plug>VisualBisectDown
xmap ↑ <Plug>VisualBisectUp
xmap ← <Plug>VisualBisectLeft
xmap → <Plug>VisualBisectRight
xmap § <Plug>VisualStopBisect
" }}}
" {{{ Function key shortcuts
" F5: Toggle paste mode
nmap <F5> :set paste!<Bar>set paste?<CR>
imap <F5> <C-O><F5>
set pastetoggle=<F5>
nmap <Leader>cp <F5>

" F6: Toggle whether to use textwidth or not
nmap <F6> :call TextwidthToggle()<CR>
imap <F6> <C-O><F6>
nmap <Leader>ctw <F6>

" F7: Turn search highlight off until next search
nmap <F7> :noh<CR>
imap <F7> <C-O><F7>

" F8: Toggle list mode
nmap <F8> :set list!<Bar>set list?<CR>
imap <F8> <C-O><F8>

" F9: Toggle highlighting long lines
nmap <F9> :call HighlightLongToggle()<CR>
imap <F9> <C-O><F9>
nmap <Leader>chl <F9>

" }}}
" {{{ Plugin binds
imap <C-e> <Esc>:norm <C-y>,<C-y>n<CR>

nmap <Leader>gL :GitLog HEAD<CR>
nmap <Leader>gC :GitCommit -s -a<CR>
nmap <Leader>gt :GitCommit -s<CR>
nmap <Leader>gS :GitAdd<Space>
nmap <Leader>gb :GitBlame<CR>
nmap <Leader>gP :GitPull origin master<CR>
nmap <Leader>gr :GitPush<CR>

nmap <silent> <Leader>sc :call Pep8()<CR>
nmap <silent> <Leader>sv :cclose<CR>
nmap <silent> <Leader>v :cnext<CR>
nmap <silent> <Leader>V :cprev<CR>

map <Leader>_ <Plug>(operator-replace)

nmap <silent> <Leader>an :let delimitMate_autoclose = 1 \| :DelimitMateReload<CR>
nmap <silent> <Leader>ar :let delimitMate_autoclose = 0 \| :DelimitMateReload<CR>
" }}}
" {{{ Extra motions
nmap <silent> <Leader>diw di,w
nmap <silent> <Leader>ciw ci,w

nmap w <Plug>(smartword-w)
nmap b <Plug>(smartword-w)
nmap <Leader>e <Plug>(smartword-w)
nmap ge <Plug>(smartword-ge)
" }}}
" {{{ Original binds
nmap <Leader>/e e
nmap <Leader>/w w
nmap <Leader>/b b
nmap <Leader>/ge ge
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
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
let Tlist_Enable_Fold_Column = 0

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

" Command-T
let g:CommandTMaxHeight = 10
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTScanDotDirectories = 1

" snipMate
let g:snips_author = "Lucas de Vries"
let g:snips_mail = "lucas@glacicle.org"

" delemitMate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1

" superTab
let g:SuperTabDefaultCompletionType = "<c-n>"

" ZenCoding
let g:user_zen_settings = {'indentation': '  ',}
let g:user_zen_leader_key = '<C-t>'

" Don't load python plugins without python
if !has('python')
    au FileType python let b:did_pyflakes_plugin = 1
endif

" Don't load ruby plugins without ruby
if !has('ruby')
    let g:command_t_loaded = 1
    let g:loaded_lustyexplorer = 1
endif
" }}}
" {{{ Vim Settings
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
set statusline=%=%c\ %P\ 

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
"set autochdir

" Show matching
set showmatch

" Remember history
set history=100

" Scrolloff
set scrolloff=3

" Shortmess
set shortmess=aAtI

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
set formatoptions=tcn12

" Don't show so many completions
set pumheight=8

" Use wildmenu
set wildmenu

" File patterns to ignore in completions
set wildignore=*.o,*.pyc,.git,.svn

" Highlight search
set hls

" Don't fold less than 2 lines
set foldminlines=2

" Syntax highlighting
syntax on

" Filetype
filetype on
filetype plugin on
filetype indent off

" Color Schemes
if $TERM == 'linux'
    " Virtual Console
    colorscheme delek
else
    " Color terminal
    set t_Co=256
    colorscheme leo

    " Some highlighting customisations
    hi VertSplit ctermfg=17 ctermbg=17
    hi Comment ctermfg=243
    hi CursorLine ctermbg=235
    hi String ctermbg=NONE
    hi Special ctermbg=NONE
endif

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

" Python extra highlighting
autocmd FileType python filetype indent on
autocmd FileType python syn keyword Identifier self
autocmd FileType python syn keyword Type True False None

" Javascript extra highlighting
autocmd FileType javascript syn keyword javascriptIdentifier "let"

" Highlight section as comment in TeX
autocmd FileType tex,plaintex hi link TexZone Comment

" Highlight braces with braces style
autocmd FileType xhtml,html hi link htmlEndTag BoldBraces
autocmd FileType xml hi link xmlEndTag BoldBraces
autocmd FileType javascript hi link javaScriptBraces Braces

" Highlight subject better
autocmd FileType mail hi link mailHeader Comment
autocmd FileType mail hi link mailSubject Function
autocmd FileType mail silent call HighlightLongToggle()

" Don't jump on git commit
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
autocmd FileType git setlocal nomodeline

" Syntax recognition
autocmd BufNewFile,BufRead *.{md,mkd,mark,markdown} set ft=markdown
autocmd BufNewFile,BufRead *.tex set ft=tex
autocmd BufNewFile,BufRead COMMIT_EDITMSG set ft=gitcommit

" Highlight long lines
autocmd BufRead * let w:longmatch = matchadd('MoreMsg', '\%<81v.\%>77v', -1)
autocmd BufRead * let w:toolongmatch = matchadd('Folded', '\%>80v.\+', -1)

" Clear any erroneous select-mode mappings
"autocmd VimEnter silent smapc

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
function! PromptFT(show)
    let def = ""

    if a:show == 1
        let def = &ft
    endif

    let ft = input("Filetype: ", def)
    if ft != ""
        exec "setlocal ft=".ft
    end
endfunction
" }}}
" {{{ Base64Decode(): Decode a base64 block
function! Base64Decode()
    ruby require "base64"
    norm gv
    '<,'>rubydo $_=Base64.decode64 $_
    norm gvgJ0
endfunction
" }}}
" {{{ Base64Decode(): Decode a base64 block
function! Base64Decode()
    ruby require "base64"
    norm gv
    '<,'>rubydo $_=Base64.decode64 $_
    norm gvgJ0
endfunction
" }}}

" }}}

" vim:fdm=marker
