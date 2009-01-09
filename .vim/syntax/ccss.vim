" Vim syntax file
" Language:	Cascading Style Sheets
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" URL:		http://www.fleiner.com/vim/syntax/css.vim
" Last Change:	2007 Nov 06
" CSS2 by Nikolai Weibull
" Full CSS2, HTML4 support by Yeti

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'ccss'
endif

syn case ignore

syn keyword cssTagName abbr acronym address applet area a b base
syn keyword cssTagName basefont bdo big blockquote body br button
syn keyword cssTagName caption center cite code col colgroup dd del
syn keyword cssTagName dfn dir div dl dt em fieldset font form frame
syn keyword cssTagName frameset h1 h2 h3 h4 h5 h6 head hr html img i
syn keyword cssTagName iframe img input ins isindex kbd label legend li
syn keyword cssTagName link map menu meta noframes noscript ol optgroup
syn keyword cssTagName option p param pre q s samp script select small
syn keyword cssTagName span strike strong style sub sup tbody td
syn keyword cssTagName textarea tfoot th thead title tr tt ul u var
syn match cssTagName "\<table\>"
syn match cssTagName "\*"

syn match cssTagName "@page\>" nextgroup=cssDefinition

syn match cssSelectorOp "[+>.]"
syn match cssSelectorOp2 "[~|]\?=" contained
syn region cssAttributeSelector matchgroup=cssSelectorOp start="\[" end="]" transparent contains=cssUnicodeEscape,cssSelectorOp2,cssStringQ,cssStringQQ

try
syn match cssIdentifier "#[A-Za-zÀ-ÿ_@][A-Za-zÀ-ÿ0-9_@-]*"
catch /^.*/
syn match cssIdentifier "#[A-Za-z_@][A-Za-z0-9_@-]*"
endtry


syn match cssMedia "@media\>" nextgroup=cssMediaType skipwhite skipnl
syn keyword cssMediaType screen print aural braile embosed handheld projection ty tv all nextgroup=cssMediaComma,cssMediaBlock skipwhite skipnl
syn match cssMediaComma "," nextgroup=cssMediaType skipwhite skipnl

syn match cssValueInteger "[-+]\=\d\+"
syn match cssValueNumber "[-+]\=\d\+\(\.\d*\)\="
syn match cssValueLength "[-+]\=\d\+\(\.\d*\)\=\(%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\)"
syn match cssValueAngle "[-+]\=\d\+\(\.\d*\)\=\(deg\|grad\|rad\)"
syn match cssValueTime "+\=\d\+\(\.\d*\)\=\(ms\|s\)"
syn match cssValueFrequency "+\=\d\+\(\.\d*\)\=\(Hz\|kHz\)"

syn match cssFontDescriptor "@font-face\>" nextgroup=cssFontDescriptorBlock skipwhite skipnl
syn region cssFontDescriptorBlock transparent matchgroup=cssBraces start="{" end="}" contains=cssComment,cssError,cssUnicodeEscape,cssFontProp,cssFontAttr,cssCommonAttr,cssStringQ,cssStringQQ,cssFontDescriptorProp,cssValue.*,cssFontDescriptorFunction,cssUnicodeRange,cssFontDescriptorAttr
syn match cssFontDescriptorProp "\<\(unicode-range\|unit-per-em\|panose-1\|cap-height\|x-height\|definition-src\)\>"
syn keyword cssFontDescriptorProp src stemv stemh slope ascent descent widths bbox baseline centerline mathline topline
syn keyword cssFontDescriptorAttr all
syn region cssFontDescriptorFunction matchgroup=cssFunctionName start="\<\(uri\|url\|local\|format\)\s*(" end=")" contains=cssStringQ,cssStringQQ oneline keepend
syn match cssUnicodeRange "U+[0-9A-Fa-f?]\+"
syn match cssUnicodeRange "U+\x\+-\x\+"

syn keyword cssColor aqua black blue fuchsia gray green lime maroon navy olive purple red silver teal yellow
" FIXME: These are actually case-insentivie too, but (a) specs recommend using
" mixed-case (b) it's hard to highlight the word `Background' correctly in
" all situations
syn case match
syn keyword cssColor ActiveBorder ActiveCaption AppWorkspace ButtonFace ButtonHighlight ButtonShadow ButtonText CaptionText GrayText Highlight HighlightText InactiveBorder InactiveCaption InactiveCaptionText InfoBackground InfoText Menu MenuText Scrollbar ThreeDDarkShadow ThreeDFace ThreeDHighlight ThreeDLightShadow ThreeDShadow Window WindowFrame WindowText Background
syn case ignore
syn match cssColor "\<transparent\>"
syn match cssColor "\<white\>"
syn match cssColor "#[0-9A-Fa-f]\{3\}\>"
syn match cssColor "#[0-9A-Fa-f]\{6\}\>"
"syn match cssColor "\<rgb\s*(\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*)"
syn region cssURL matchgroup=cssFunctionName start="\<url\s*(" end=")" oneline keepend
syn region cssFunction matchgroup=cssFunctionName start="\<\(rgb\|clip\|attr\|counter\|rect\)\s*(" end=")" oneline keepend

syn match cssImportant "!\s*important\>"

syn keyword cssCommonAttr auto none inherit
syn keyword cssCommonAttr top bottom
syn keyword cssCommonAttr medium normal

syn match cssFontProp "\<font\>\(-\(family\|style\|variant\|weight\|size\(-adjust\)\=\|stretch\)\>\)\="
syn match cssFontAttr "\<\(sans-\)\=\<serif\>"
syn match cssFontAttr "\<small\>\(-\(caps\|caption\)\>\)\="
syn match cssFontAttr "\<x\{1,2\}-\(large\|small\)\>"
syn match cssFontAttr "\<message-box\>"
syn match cssFontAttr "\<status-bar\>"
syn match cssFontAttr "\<\(\(ultra\|extra\|semi\|status-bar\)-\)\=\(condensed\|expanded\)\>"
syn keyword cssFontAttr cursive fantasy monospace italic oblique
syn keyword cssFontAttr bold bolder lighter larger smaller
syn keyword cssFontAttr icon menu
syn match cssFontAttr "\<caption\>"
syn keyword cssFontAttr large smaller larger
syn keyword cssFontAttr narrower wider

syn keyword cssColorProp color
syn match cssColorProp "\<background\(-\(color\|image\|attachment\|position\)\)\="
syn keyword cssColorAttr center scroll fixed
syn match cssColorAttr "\<repeat\(-[xy]\)\=\>"
syn match cssColorAttr "\<no-repeat\>"

syn match cssTextProp "\<\(\(word\|letter\)-spacing\|text\(-\(decoration\|transform\|align\|index\|shadow\)\)\=\|vertical-align\|unicode-bidi\|line-height\)\>"
syn match cssTextAttr "\<line-through\>"
syn match cssTextAttr "\<text-indent\>"
syn match cssTextAttr "\<\(text-\)\=\(top\|bottom\)\>"
syn keyword cssTextAttr underline overline blink sub super middle
syn keyword cssTextAttr capitalize uppercase lowercase center justify baseline sub super

syn match cssBoxProp "\<\(margin\|padding\|border\)\(-\(top\|right\|bottom\|left\)\)\=\>"
syn match cssBoxProp "\<border-\(\(\(top\|right\|bottom\|left\)-\)\=\(width\|color\|style\)\)\=\>"
syn match cssBoxProp "\<\(width\|z-index\)\>"
syn match cssBoxProp "\<\(min\|max\)-\(width\|height\)\>"
syn keyword cssBoxProp width height float clear overflow clip visibility
syn keyword cssBoxAttr thin thick both
syn keyword cssBoxAttr dotted dashed solid double groove ridge inset outset
syn keyword cssBoxAttr hidden visible scroll collapse

syn keyword cssGeneratedContentProp content quotes
syn match cssGeneratedContentProp "\<counter-\(reset\|increment\)\>"
syn match cssGeneratedContentProp "\<list-style\(-\(type\|position\|image\)\)\=\>"
syn match cssGeneratedContentAttr "\<\(no-\)\=\(open\|close\)-quote\>"
syn match cssAuralAttr "\<lower\>"
syn match cssGeneratedContentAttr "\<\(lower\|upper\)-\(roman\|alpha\|greek\|latin\)\>"
syn match cssGeneratedContentAttr "\<\(hiragana\|katakana\)\(-iroha\)\=\>"
syn match cssGeneratedContentAttr "\<\(decimal\(-leading-zero\)\=\|cjk-ideographic\)\>"
syn keyword cssGeneratedContentAttr disc circle square hebrew armenian georgian
syn keyword cssGeneratedContentAttr inside outside

syn match cssPagingProp "\<page\(-break-\(before\|after\|inside\)\)\=\>"
syn keyword cssPagingProp size marks inside orphans widows
syn keyword cssPagingAttr landscape portrait crop cross always avoid

syn keyword cssUIProp cursor
syn match cssUIProp "\<outline\(-\(width\|style\|color\)\)\=\>"
syn match cssUIAttr "\<[ns]\=[ew]\=-resize\>"
syn keyword cssUIAttr default crosshair pointer move wait help
syn keyword cssUIAttr thin thick
syn keyword cssUIAttr dotted dashed solid double groove ridge inset outset
syn keyword cssUIAttr invert

syn match cssRenderAttr "\<marker\>"
syn match cssRenderProp "\<\(display\|marker-offset\|unicode-bidi\|white-space\|list-item\|run-in\|inline-table\)\>"
syn keyword cssRenderProp position top bottom direction
syn match cssRenderProp "\<\(left\|right\)\>"
syn keyword cssRenderAttr block inline compact
syn match cssRenderAttr "\<table\(-\(row-gorup\|\(header\|footer\)-group\|row\|column\(-group\)\=\|cell\|caption\)\)\=\>"
syn keyword cssRenderAttr static relative absolute fixed
syn keyword cssRenderAttr ltr rtl embed bidi-override pre nowrap
syn match cssRenderAttr "\<bidi-override\>"


syn match cssAuralProp "\<\(pause\|cue\)\(-\(before\|after\)\)\=\>"
syn match cssAuralProp "\<\(play-during\|speech-rate\|voice-family\|pitch\(-range\)\=\|speak\(-\(punctuation\|numerals\)\)\=\)\>"
syn keyword cssAuralProp volume during azimuth elevation stress richness
syn match cssAuralAttr "\<\(x-\)\=\(soft\|loud\)\>"
syn keyword cssAuralAttr silent
syn match cssAuralAttr "\<spell-out\>"
syn keyword cssAuralAttr non mix
syn match cssAuralAttr "\<\(left\|right\)-side\>"
syn match cssAuralAttr "\<\(far\|center\)-\(left\|center\|right\)\>"
syn keyword cssAuralAttr leftwards rightwards behind
syn keyword cssAuralAttr below level above higher
syn match cssAuralAttr "\<\(x-\)\=\(slow\|fast\)\>"
syn keyword cssAuralAttr faster slower
syn keyword cssAuralAttr male female child code digits continuous

syn match cssTableProp "\<\(caption-side\|table-layout\|border-collapse\|border-spacing\|empty-cells\|speak-header\)\>"
syn keyword cssTableAttr fixed collapse separate show hide once always

" FIXME: This allows cssMediaBlock before the semicolon, which is wrong.
syn region cssInclude start="@import" end=";" contains=cssComment,cssURL,cssUnicodeEscape,cssMediaType
syn match cssBraces "[{}]"
syn match cssError "{@<>"
syn region cssDefinition transparent matchgroup=cssBraces start='{' end='}' contains=css.*Attr,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape
syn match cssBraceError "}"

syn match cssPseudoClass ":\S*" contains=cssPseudoClassId,cssUnicodeEscape
syn keyword cssPseudoClassId link visited active hover focus before after left right
syn match cssPseudoClassId "\<first\(-\(line\|letter\|child\)\)\=\>"
syn region cssPseudoClassLang matchgroup=cssPseudoClassId start=":lang(" end=")" oneline

syn region cssComment start="/\*" end="\*/" contains=@Spell

syn match cssUnicodeEscape "\\\x\{1,6}\s\?"
syn match cssSpecialCharQQ +\\"+ contained
syn match cssSpecialCharQ +\\'+ contained
syn region cssStringQQ start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=cssUnicodeEscape,cssSpecialCharQQ
syn region cssStringQ start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=cssUnicodeEscape,cssSpecialCharQ
syn match cssClassName "\.[A-Za-z][A-Za-z0-9_-]\+"

if main_syntax == "css"
  syn sync minlines=10
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_css_syn_inits")
  if version < 508
    let did_css_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cssComment Comment
  HiLink cssTagName Statement
  HiLink cssSelectorOp Special
  HiLink cssSelectorOp2 Special
  HiLink cssFontProp StorageClass
  HiLink cssColorProp StorageClass
  HiLink cssTextProp StorageClass
  HiLink cssBoxProp StorageClass
  HiLink cssRenderProp StorageClass
  HiLink cssAuralProp StorageClass
  HiLink cssRenderProp StorageClass
  HiLink cssGeneratedContentProp StorageClass
  HiLink cssPagingProp StorageClass
  HiLink cssTableProp StorageClass
  HiLink cssUIProp StorageClass
  HiLink cssFontAttr Type
  HiLink cssColorAttr Type
  HiLink cssTextAttr Type
  HiLink cssBoxAttr Type
  HiLink cssRenderAttr Type
  HiLink cssAuralAttr Type
  HiLink cssGeneratedContentAttr Type
  HiLink cssPagingAttr Type
  HiLink cssTableAttr Type
  HiLink cssUIAttr Type
  HiLink cssCommonAttr Type
  HiLink cssPseudoClassId PreProc
  HiLink cssPseudoClassLang Constant
  HiLink cssValueLength Number
  HiLink cssValueInteger Number
  HiLink cssValueNumber Number
  HiLink cssValueAngle Number
  HiLink cssValueTime Number
  HiLink cssValueFrequency Number
  HiLink cssFunction Constant
  HiLink cssURL String
  HiLink cssFunctionName Function
  HiLink cssColor Constant
  HiLink cssIdentifier Function
  HiLink cssInclude Include
  HiLink cssImportant Special
  HiLink cssBraces Function
  HiLink cssBraceError Error
  HiLink cssError Error
  HiLink cssInclude Include
  HiLink cssUnicodeEscape Special
  HiLink cssStringQQ String
  HiLink cssStringQ String
  HiLink cssMedia Special
  HiLink cssMediaType Special
  HiLink cssMediaComma Normal
  HiLink cssFontDescriptor Special
  HiLink cssFontDescriptorFunction Constant
  HiLink cssFontDescriptorProp StorageClass
  HiLink cssFontDescriptorAttr Type
  HiLink cssUnicodeRange Constant
  HiLink cssClassName Function
  delcommand HiLink
endif

let b:current_syntax = "ccss"

if main_syntax == 'ccss'
  unlet main_syntax
endif


" vim: ts=8

