"
" Chasm           vim color scheme
"
" Author: Lucas de Vries <lucas@glacicle.org>
"

hi clear
set background=dark
let colors_name="chasm"

" Editor elements
hi Normal       ctermbg=0     ctermfg=255    cterm=NONE
hi NonText      ctermbg=16    ctermfg=239
hi Ignore                     ctermfg=0
hi MoreMsg                    ctermfg=221
hi ModeMsg                    ctermfg=221    cterm=bold
hi SpecialKey                 ctermfg=244
hi LineNr       ctermbg=16    ctermfg=239
hi ErrorMsg     ctermbg=1     ctermfg=15
hi Visual       ctermbg=8
hi VertSplit    ctermbg=248   ctermfg=248     cterm=NONE
hi Folded       ctermbg=239   ctermfg=221
hi FoldColumn   ctermbg=239   ctermfg=16
hi CursorColumn ctermbg=16
hi CursorLine   ctermbg=16                    cterm=NONE
hi StatusLineNC ctermbg=0     ctermfg=248
hi StatusLine   ctermbg=0     ctermfg=253     cterm=reverse

" Browser
hi Title                      ctermfg=202
hi Directory                  ctermfg=74

" Spelling check
hi SpellBad     ctermbg=0                     cterm=reverse

" Completion Menu
hi Pmenu        ctermbg=139   ctermfg=0
hi PmenuSel     ctermbg=11    ctermfg=0
hi PmenuSbar    ctermbg=248   ctermfg=0
hi PmenuThumb                                 cterm=reverse

" Diff
hi DiffAdd      ctermbg=16
hi DiffChange   ctermbg=17
hi DiffDelete   ctermbg=88
hi DiffText     ctermbg=17

" Search
hi IncSearch    ctermbg=231   ctermfg=202     cterm=reverse
hi Search       ctermbg=139   ctermfg=231

" Extra elements
hi MatchParen   ctermbg=139   ctermfg=231

" Syntax highlight
hi Comment                    ctermfg=244
hi Statement                  ctermfg=255     cterm=bold
hi Type                       ctermfg=112
hi Special                    ctermfg=208
hi PreProc                    ctermfg=4       cterm=bold
hi Identifier                 ctermfg=70      cterm=bold
hi Constant                   ctermfg=202

" Specialised syntax
"" Constant
hi String                     ctermfg=221
hi Number                     ctermfg=214

"" Identifier
hi Function                   ctermfg=74      cterm=bold

"" Statement
hi Conditional                ctermfg=4       cterm=bold
hi Repeat                     ctermfg=166     cterm=bold
hi Operator                   ctermfg=5       cterm=bold

"" PreProc
hi Define                     ctermfg=39      cterm=bold

"" Other
hi Braces                     ctermfg=139
hi BoldBraces                 ctermfg=139     cterm=bold
