" My Version of MiniBufExpl,
" the one from vim.org was bloated and riddled with
" bugs, so I created a tiny new version that does
" exactly what I need, and nothing more.
" 
" This hasn't been tested more than me using it,
" so don't expect anything.
"
" ~ Lucas de Vries [GGLucas] <lucas@glacicle.com>
"

if exists('loaded_mybufexplorer') || v:version < 700
    finish
endif

let loaded_mybufexplorer = 1
let g:MyBufWin = -1
let g:bufName = "-MyBufExplorer-"

command! MyBuf call <SID>Create()
command! MyBufUpdate call <SID>Update(-1)
command! MyBufDestroy call <SID>Destroy()

augroup MyBufExplorer
autocmd MyBufExplorer VimEnter * call <SID>Create()

function! <SID>Create()
    autocmd MyBufExplorer BufDelete * silent call <SID>Update(expand('<abuf>'))
    autocmd MyBufExplorer BufEnter * silent call <SID>Update(-1)

    exec "to sp ".g:bufName
    let g:MyBufWin = <SID>FindWindow(g:bufName)

    exec g:MyBufWin." wincmd w"

    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal wrap

    setlocal foldcolumn=0
    setlocal nonumber

    syn clear
    syn match MBENormal             '\[[^\]]*\]'
    syn match MBEChanged            '\[[^\]]*\]+'
    syn match MBEVisibleNormal      '\[[^\]]*\]\*+\='
    syn match MBEVisibleChanged     '\[[^\]]*\]\*+'
    
    hi def link MBENormal         Comment
    hi def link MBEChanged        String
    hi def link MBEVisibleNormal  Special
    hi def link MBEVisibleChanged Special

    set nobuflisted
    set noequalalways
    set nomousefocus

    call <SID>Update(-1)
endfunction

function! <SID>Destroy()
    autocmd! MyBufExplorer

    exec g:MyBufWin." wincmd w"
    silent! close
    wincmd p

    let g:MyBufWin = -1
endfunction

function! <SID>Update(ignore)
    if g:MyBufWin == -1 
        return
    endif

    exec g:MyBufWin." wincmd w"

    if bufname('%') != g:bufName
        return
    endif

    let l:width  = winwidth('.')
    exec "setlocal textwidth=".l:width

    setlocal modifiable
     
    call <SID>Write(a:ignore)
    call <SID>Resize()

    setlocal nomodifiable

    exec "wincmd p"

    if bufname('%') == g:bufName
        norm ZQ
    endif

endfunction

function! <SID>Write(ignore)
    let l:nbufs = bufnr('$')
    let l:i = 0
    let l:filenames = ''

    while (l:i <= l:nbufs)
        let l:i = l:i + 1

        if (getbufvar(l:i, '&buflisted') == 1)
            let l:name = bufname(l:i)
            if (strlen(l:name) && l:name != g:bufName && l:i != a:ignore)
                let l:shortBufName = fnamemodify(l:name, ":t")                  
                let l:shortBufName = substitute(l:shortBufName, '[][()]', '', 'g') 
                let l:tab = '['.l:i.':'.l:shortBufName.']'
                let l:spc = "  "

                if bufwinnr(l:i) != -1
                    let l:tab = l:tab . '*'
                    let l:spc = " "
                endif

                if(getbufvar(l:i, '&modified') == 1)
                    let l:tab = l:tab . '+'

                    if l:spc == " "
                        let l:spc = ""
                    else
                        let l:spc = " "
                    endif
                endif

                let l:tab = l:tab.l:spc

                let l:filenames = l:filenames . l:tab
            endif
        endif
    endwhile

    1,$d _
    $
    put! =l:filenames
    $ d _

endfunction

function! <SID>Resize()
    normal gg
    normal gq}
    normal G
    let l:height = line('.')
    normal gg

    exec "resize".l:height
endfunction

function! <SID>FindWindow(bufName)
  let l:bufNum = bufnr(a:bufName)

  if l:bufNum != -1
    let l:winNum = bufwinnr(l:bufNum)
  else
    let l:winNum = -1
  endif

  return l:winNum
endfunction
