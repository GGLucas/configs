if $TERM =~ "linux"
    if !has("gui_running")
        GuiColorScheme darkspectrum
    endif

    highlight Pmenu ctermbg=139 ctermfg=0
    highlight PmenuSel ctermbg=11 ctermfg=0
    highlight PmenuSbar ctermbg=248 ctermfg=0
    highlight Statement cterm=bold

    hi Normal ctermbg=black
    hi Preproc ctermfg=74 cterm=underline
    hi Comment ctermfg=244
    hi Statement cterm=bold ctermfg=white
    hi Constant ctermfg=202
    hi Identifier ctermfg=74
    hi Type ctermfg=112
end
