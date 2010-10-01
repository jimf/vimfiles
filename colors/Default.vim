" DARK colorscheme.  The purpose of this colorscheme is to make small
" adjustments to the default.

" Restore default colors
hi clear


if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Default"

hi Comment term=NONE cterm=NONE ctermfg=4
