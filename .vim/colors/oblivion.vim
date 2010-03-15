"
" Oblivion color scheme (based on darkspectrum)
" Lucas de Vries <lucas@tuple-typed.org>
"

" Clear syntax
hi clear
if exists("syntax_on")
    syntax reset
endif

" Dark background
set background=dark

" Color name
let g:colors_name="oblivion"

hi Normal        ctermbg=0 ctermfg=white

hi SpecialKey    ctermfg=244
hi NonText       ctermfg=239 ctermbg=16
hi Directory     ctermfg=74
hi ErrorMsg      ctermfg=15 ctermbg=1
hi IncSearch     cterm=reverse ctermfg=202 ctermbg=231
hi Search        ctermfg=231 ctermbg=139
hi MoreMsg       ctermfg=221
hi ModeMsg       cterm=bold ctermfg=221
hi LineNr        ctermfg=239 ctermbg=16
hi Question      ctermfg=121

hi StatusLine    cterm=reverse ctermfg=lightgray ctermbg=black
hi StatusLineNC  ctermfg=gray ctermbg=black

hi VertSplit     cterm=reverse ctermfg=lightgray ctermbg=black

hi Title         ctermfg=202
hi Visual        ctermfg=231 ctermbg=59
hi VisualNOS     cterm=bold
hi WarningMsg    ctermfg=202
hi WildMenu      ctermfg=0 ctermbg=11
hi Folded        ctermfg=221 ctermbg=239
hi FoldColumn    ctermfg=16 ctermbg=239
hi DiffAdd       cterm=bold ctermfg=231 ctermbg=18
hi DiffChange    cterm=bold ctermfg=231 ctermbg=64
hi DiffDelete    cterm=bold ctermfg=231 ctermbg=53
hi DiffText      cterm=bold ctermfg=231 ctermbg=64
hi SignColumn    ctermfg=14 ctermbg=242
hi SpellBad      ctermbg=9
hi SpellCap      ctermbg=12
hi SpellRare     ctermbg=13
hi SpellLocal    ctermbg=14
hi Pmenu         ctermfg=0 ctermbg=139
hi PmenuSel      ctermfg=0 ctermbg=11
hi PmenuSbar     ctermfg=0 ctermbg=248
hi PmenuThumb    cterm=reverse

hi TabLine       cterm=underline ctermfg=247 ctermbg=16
hi TabLineSel    cterm=bold ctermfg=231
hi TabLineFill   ctermfg=239 ctermbg=16

hi CursorColumn  ctermbg=16
hi CursorLine    ctermbg=16 cterm=NONE
hi MatchParen    ctermfg=231 ctermbg=139
hi Comment       ctermfg=244
hi Constant      ctermfg=202
hi Special       ctermfg=208
hi Function      ctermfg=74 cterm=bold
hi Statement     ctermfg=15 cterm=bold
hi PreProc       ctermfg=blue cterm=bold
hi Type          ctermfg=112
hi Underlined    ctermfg=81 cterm=underline
hi Ignore        ctermfg=0
hi Error         ctermfg=15 ctermbg=9
hi Todo          ctermfg=0 ctermbg=11
hi String        ctermfg=221
hi Number        ctermfg=214
hi Identifier    ctermfg=70
hi Braces        ctermfg=139
hi BoldBraces    ctermfg=139 cterm=bold
hi Cursor        ctermfg=16 ctermbg=231
