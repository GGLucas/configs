imap <C-a> <Esc>
nmap <C-a> <Esc>

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
nmap gl :Ex<CR> 
nmap gd :tabclose<CR>
nmap e :w<CR>

set nocompatible

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab autoindent
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


let g:EnhCommentifyFirstLineMode = "yes"
let g:EnhCommentifyUserBindings  = "yes"

nmap <silent> <Leader>ehc <Plug>Comment
nmap <silent> <Leader>ehd <Plug>DeComment
nmap <silent> <Leader>eht <Plug>Traditional
nmap <silent> <Leader>ehf <Plug>FirstLine
vmap <silent> <Leader>ehc <Plug>VisualComment
vmap <silent> <Leader>ehd <Plug>VisualDeComment
vmap <silent> <Leader>eht <Plug>VisualTraditional
vmap <silent> <Leader>ehf <Plug>VisualFirstLine
exe "imap <silent> <Leader>ehc \<c-o><Plug>Comment"
exe "imap <silent> <Leader>ehd \<c-o><Plug>DeComment"
exe "imap <silent> <Leader>eht \<c-o><Plug>Traditional"
exe "imap <silent> <Leader>ehf \<c-o><Plug>FirstLine"

