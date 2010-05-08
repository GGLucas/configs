" This is a simple script. It extends the syntax highlighting to
" highlight each matching set of parens in different colors, to make
" it visually obvious what matches which.

" Obviously, most useful when working with lisp. But it's also nice othe
" times.

" I don't intend to maintain this script. I hacked it together for my
" own purposes, and it is sufficient to the day. If you want to improve it,
" knock yourself out.

" This file is public domain.


" define colors. Note that the one numbered '16' is the outermost pair,
" keep that in mind if you want to change the colors.
" Also, if this script doesn't work on your terminal, you may need to add
" guifg=xx or ever termfg=, though what good this script will do on a 
" black and white terminal I don't know.
hi level1c ctermfg=white
hi level2c ctermfg=white
hi level3c ctermfg=white
hi level4c ctermfg=white
hi level5c ctermfg=white
hi level6c ctermfg=white
hi level7c ctermfg=white
hi level8c ctermfg=white
hi level9c ctermfg=white
hi level10c ctermfg=blue
hi level11c ctermfg=yellow
hi level12c ctermfg=brown
hi level13c ctermfg=red
hi level14c ctermfg=green
hi level15c ctermfg=cyan
hi level16c ctermfg=magenta



" These are the regions for each pair.
" This could be improved, perhaps, by makeing them match [ and { also,
" but I'm not going to take the time to figure out haw to make the
" end pattern match only the proper type.
syn region level1 matchgroup=level1c start=/(/ end=/)/ contains=TOP,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level2 matchgroup=level2c start=/(/ end=/)/ contains=TOP,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level3 matchgroup=level3c start=/(/ end=/)/ contains=TOP,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level4 matchgroup=level4c start=/(/ end=/)/ contains=TOP,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level5 matchgroup=level5c start=/(/ end=/)/ contains=TOP,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level6 matchgroup=level6c start=/(/ end=/)/ contains=TOP,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level7 matchgroup=level7c start=/(/ end=/)/ contains=TOP,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level8 matchgroup=level8c start=/(/ end=/)/ contains=TOP,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level9 matchgroup=level9c start=/(/ end=/)/ contains=TOP,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level10 matchgroup=level10c start=/(/ end=/)/ contains=TOP,level10,level11,level12,level13,level14,level15, level16,NoInParens
syn region level11 matchgroup=level11c start=/(/ end=/)/ contains=TOP,level11,level12,level13,level14,level15, level16,NoInParens
syn region level12 matchgroup=level12c start=/(/ end=/)/ contains=TOP,level12,level13,level14,level15, level16,NoInParens
syn region level13 matchgroup=level13c start=/(/ end=/)/ contains=TOP,level13,level14,level15, level16,NoInParens
syn region level14 matchgroup=level14c start=/(/ end=/)/ contains=TOP,level14,level15, level16,NoInParens
syn region level15 matchgroup=level15c start=/(/ end=/)/ contains=TOP,level15, level16,NoInParens
syn region level16 matchgroup=level16c start=/(/ end=/)/ contains=TOP,level16,NoInParens

syn region blevel1 matchgroup=level1c start=/\[/ end=/\]/ contains=TOP,blevel1,blevel2,blevel3,blevel4,blevel5,blevel6,blevel7,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel2 matchgroup=level2c start=/\[/ end=/\]/ contains=TOP,blevel2,blevel3,blevel4,blevel5,blevel6,blevel7,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel3 matchgroup=level3c start=/\[/ end=/\]/ contains=TOP,blevel3,blevel4,blevel5,blevel6,blevel7,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel4 matchgroup=level4c start=/\[/ end=/\]/ contains=TOP,blevel4,blevel5,blevel6,blevel7,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel5 matchgroup=level5c start=/\[/ end=/\]/ contains=TOP,blevel5,blevel6,blevel7,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel6 matchgroup=level6c start=/\[/ end=/\]/ contains=TOP,blevel6,blevel7,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel7 matchgroup=level7c start=/\[/ end=/\]/ contains=TOP,blevel7,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel8 matchgroup=level8c start=/\[/ end=/\]/ contains=TOP,blevel8,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel9 matchgroup=level9c start=/\[/ end=/\]/ contains=TOP,blevel9,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel10 matchgroup=level10c start=/\[/ end=/\]/ contains=TOP,blevel10,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel11 matchgroup=level11c start=/\[/ end=/\]/ contains=TOP,blevel11,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel12 matchgroup=level12c start=/\[/ end=/\]/ contains=TOP,blevel12,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel13 matchgroup=level13c start=/\[/ end=/\]/ contains=TOP,blevel13,blevel14,blevel15, blevel16,NoInParens
syn region blevel14 matchgroup=level14c start=/\[/ end=/\]/ contains=TOP,blevel14,blevel15, blevel16,NoInParens
syn region blevel15 matchgroup=level15c start=/\[/ end=/\]/ contains=TOP,blevel15, blevel16,NoInParens
syn region blevel16 matchgroup=level16c start=/\[/ end=/\]/ contains=TOP,blevel16,NoInParens

syn region clevel1 matchgroup=level1c start=/{/ end=/}/ contains=TOP,clevel1,clevel2,clevel3,clevel4,clevel5,clevel6,clevel7,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel2 matchgroup=level2c start=/{/ end=/}/ contains=TOP,clevel2,clevel3,clevel4,clevel5,clevel6,clevel7,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel3 matchgroup=level3c start=/{/ end=/}/ contains=TOP,clevel3,clevel4,clevel5,clevel6,clevel7,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel4 matchgroup=level4c start=/{/ end=/}/ contains=TOP,clevel4,clevel5,clevel6,clevel7,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel5 matchgroup=level5c start=/{/ end=/}/ contains=TOP,clevel5,clevel6,clevel7,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel6 matchgroup=level6c start=/{/ end=/}/ contains=TOP,clevel6,clevel7,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel7 matchgroup=level7c start=/{/ end=/}/ contains=TOP,clevel7,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel8 matchgroup=level8c start=/{/ end=/}/ contains=TOP,clevel8,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel9 matchgroup=level9c start=/{/ end=/}/ contains=TOP,clevel9,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel10 matchgroup=level10c start=/{/ end=/}/ contains=TOP,clevel10,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel11 matchgroup=level11c start=/{/ end=/}/ contains=TOP,clevel11,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel12 matchgroup=level12c start=/{/ end=/}/ contains=TOP,clevel12,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel13 matchgroup=level13c start=/{/ end=/}/ contains=TOP,clevel13,clevel14,clevel15, clevel16,NoInParens
syn region clevel14 matchgroup=level14c start=/{/ end=/}/ contains=TOP,clevel14,clevel15, clevel16,NoInParens
syn region clevel15 matchgroup=level15c start=/{/ end=/}/ contains=TOP,clevel15, clevel16,NoInParens
syn region clevel16 matchgroup=level16c start=/{/ end=/}/ contains=TOP,clevel16,NoInParens
