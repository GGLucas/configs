" Sparkup
" Installation:
" 1. Put it in ~/.vim/scripts
" 2. Add this to ~/.vimrc:
"     autocmd FileType html source ~/.vim/scripts/sparkup.vim
"
imap <silent> <C-e> <Esc>:.!sparkup<Cr>:call SparkupNext()<Cr>
nmap <silent> <C-e> :.!sparkup<Cr>:call SparkupNext()<Cr>

imap <silent> <C-t> <Esc>:call SparkupNext()<Cr>
nmap <silent> <C-t> :call SparkupNext()<Cr>

function! SparkupNext()
    " 1: empty tag, 2: empty attribute, 3: empty line
    let n = search('><\/\|\(""\)\|^\s*$', 'Wp')
    if n == 3
        startinsert!
    else
        execute 'normal l'
        startinsert
    endif
endfunction
