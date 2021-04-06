"-------------------------------------------------------------------------{{{1
" Maintainer: Jim Fitzpatrick <fitzpatrick.jim@gmail.com>                    |
"   Revision: $Rev$                                                          |
"        URL: http://github.com/jimf/vimfiles                                |
"-------------------------------------------------------------------------}}}1

" | 01. General ................. General Vim behavior -------------------{{{1
"  \_________________________________________________________________________|
set nocompatible         " Get rid of Vi compatibility mode. SET FIRST!
set mouse=a              " Enable the mouse for all modes.
set history=500          " Number of lines of history to remember.
set isk+=_,$,@,%,#       " Make these characters count as part of a word.
set isfname-=-           " Make these characters NOT count as part of filename
set viminfo+=!           " Make sure we can save viminfo.
set autoread             " Automatically re-read file when externally modified
set autowrite            " Automatically write changes when running :make.
set switchbuf=useopen    " See :he switchbuf
set tags+=tags;$HOME     " Look for tags in parent dirs

                                                                        " }}}1
" | 02. Events .................. General autocmd events -----------------{{{1
"  \_________________________________________________________________________|
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]

augroup WindowEvents                                                    " {{{2
    autocmd!
    autocmd BufWritePre * call EnsureDirExists(expand("%:h"))
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END
                                                                        " }}}2
augroup MassageFiletype                                                 " {{{2
    " Make sure the correct filetype is applied to these files:
    autocmd!
    autocmd BufRead *.ctp setlocal filetype=php
    autocmd BufRead *.erb setlocal filetype=ruby
    autocmd BufRead *.hbs setlocal filetype=handlebars
    autocmd BufRead *.htm setlocal filetype=php
    autocmd BufRead *.html setlocal filetype=php
    autocmd BufRead *.less setlocal filetype=less.css
    autocmd BufRead *.mako setlocal filetype=mako
    autocmd BufRead *.t setlocal filetype=perl
    autocmd BufRead *.thtml setlocal filetype=php
    autocmd BufRead * if match(expand("%:p:h"), 'config/cron') > 0 | setlocal ft=crontab | endif
    autocmd BufRead psql.edit.* setlocal filetype=psql
    autocmd BufRead *.pp setlocal filetype=ruby
    autocmd BufRead *.txt setlocal filetype=txt
    autocmd BufRead *.zsh setlocal filetype=zsh
    autocmd BufRead *.zsh-theme setlocal filetype=zsh
    autocmd BufRead Vagrantfile setlocal filetype=ruby
augroup END
                                                                        " }}}2
augroup CoffeescriptEvents                                              " {{{2
    autocmd!
    " autocmd BufWritePost *.coffee silent make! -b | cwindow
    autocmd FileType coffee setlocal softtabstop=2
    autocmd FileType coffee setlocal shiftwidth=2
    autocmd FileType coffee setlocal isk-=:
augroup END

augroup GitEvents                                                       " {{{2
    autocmd!
    if version >= 700
        autocmd FileType gitcommit setlocal spell spelllang=en_us
    endif
augroup END
                                                                        " }}}2
augroup LessEvents                                                      " {{{2
    autocmd!
    autocmd FileType less.css setlocal softtabstop=2
    autocmd FileType less.css setlocal shiftwidth=2
    autocmd FileType less.css setlocal isk-=:
augroup END
                                                                        " }}}2
augroup Handlebars                                                      " {{{2
    autocmd!
    au FileType handlebars setlocal softtabstop=2
    au FileType handlebars setlocal shiftwidth=2
augroup END
                                                                        " }}}2
augroup HelpEvents                                                      " {{{2
    autocmd!
    au FileType help setlocal nospell
augroup END
                                                                        " }}}2
augroup JavascriptEvents                                                " {{{2
    autocmd!
    autocmd FileType javascript setlocal isk-=:
augroup END
                                                                        " }}}2
augroup MakefileEvents                                                  " {{{2
    autocmd!
    autocmd FileType make setlocal noet sw=8
augroup END
                                                                        " }}}2
augroup PerlEvents                                                      " {{{2
    autocmd!
    autocmd FileType perl setlocal makeprg=perl\ -c\ %
    autocmd FileType perl setlocal errorformat=%f:%l:%m
    autocmd FileType perl iab <buffer> echo print
    autocmd FileType perl set path+=~/svn/trunk/code/awlib/AW,/etc/perl,/usr/local/lib/perl/5.8.8,/usr/local/share/perl/5.8.8,/usr/lib/perl5,/usr/share/perl5,/usr/lib/perl/5.8,/usr/share/perl/5.8
    autocmd FileType perl nmap <buffer> <leader>m :vimgrep /^\s*sub / %<CR>:cw<CR>zO
augroup END
                                                                        " }}}2
augroup PhpEvents                                                       " {{{2
    autocmd!
    autocmd FileType php setlocal ai
    autocmd FileType php match Error /}\zs \/\/ \?close.*$/
    autocmd FileType php setlocal isk-=-
    autocmd FileType php setlocal makeprg=php\ -l\ %
    autocmd FileType php setlocal errorformat=%t:\ %m\ in\ %f\ on\ line\ %l
    autocmd FileType php setlocal keywordprg=~/bin/php_doc

    " List methods within file:
    autocmd FileType php nnoremap <buffer> <leader>m :vimgrep /^\s*\(private \\|public \)\?function / %<CR>:cw<CR>zO
augroup END
                                                                        " }}}2
augroup PythonEvents                                                    " {{{2
    autocmd!
    autocmd FileType python setlocal textwidth=72
    "if filereadable('./bin/pylint') && filereadable('./pylintrc')
    " autocmd FileType python setlocal makeprg=./bin/pylint\ --rcfile=./pylintrc\ --reports=n\ --output-format=parseable\ %:p
    " autocmd FileType python setlocal efm=%A%f:%l:\ [%t%.%#]\ %m,%Z%p^^,%-C%.%#
    "autocmd FileType python setlocal makeprg=(echo\ '[%:p]';\ rpylint\ --include-pep\ %:p)
    "autocmd FileType python setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m
    autocmd FileType python setlocal keywordprg=pydoc
    autocmd FileType python setlocal isk-=:
    autocmd FileType python let python_highlight_all = 1
    autocmd FileType python nmap <buffer> <leader>m :vimgrep /^\s*def / %<CR>:cw<CR>zO
    autocmd FileType python setlocal suffixes+=.pyc,.pyo
    au BufEnter * if &filetype == "python" | match ErrorMsg '\%>79v.\+' | endif
    au BufLeave * match
    au BufEnter * if &filetype == "python" && v:version >= 703 | setlocal colorcolumn=80 | endif
    au BufLeave * if v:version >= 703 | setlocal colorcolumn=0 | endif
    " au BufWritePost * if &filetype == "python" | call RunAllTests('test') | endif
    "au BufWritePost * if &filetype == "python" | call RunAllTests('unit-test') | endif
augroup END
                                                                        " }}}2
augroup RubyEvents                                                      " {{{2
    autocmd!
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
augroup END
                                                                        " }}}2
augroup SassEvents                                                      " {{{2
    autocmd!
    autocmd FileType scss setlocal softtabstop=2
    autocmd FileType scss setlocal shiftwidth=2
    autocmd FileType scss setlocal isk+=-
    autocmd FileType scss setlocal isk-=:
augroup END
                                                                        " }}}2
augroup SvnEvents                                                       " {{{2
    autocmd!
    if version >= 700
        autocmd FileType svn setlocal spell spelllang=en_us
    endif
augroup END
                                                                        " }}}2
augroup TextEvents                                                      " {{{2
    autocmd!
    autocmd FileType txt setlocal wrap
    autocmd FileType txt setlocal spell spelllang=en_us
augroup END
                                                                        " }}}2
" Filetype completion                                                   " {{{2
set complete=.
if filereadable($HOME."/.vim/complete")
    set complete+=k$HOME/.vim/complete
endif
if version >= 700
   autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
   autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
   autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
   autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
   autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
   autocmd FileType c setlocal omnifunc=ccomplete#Complete
endif
                                                                        " }}}2


                                                                        " }}}1
" | 03. Theme/Colors ............ Colors, fonts, etc. --------------------{{{1
"  \_________________________________________________________________________|
set t_Co=256             " Enable 256-color mode.
syntax enable            " Enable syntax highlighting (previously syntax on).

syn keyword Todo contained TODO FIXME XXX NOTE
hi link awError Error
match awError /^[} \t]*\zs\(else\?\)\? \?if(/

if filereadable($HOME."/.vim/colors/xoria256.vim") || filereadable($VIMRUNTIME."/colors/xoria256.vim")
    colorscheme xoria256
elseif filereadable($HOME."/.vim/colors/desert256.vim") || filereadable($VIMRUNTIME."/colors/desert256.vim")
    colorscheme desert256
endif

                                                                        " }}}1
" | 04. Vim UI .................. User interface behavior ----------------{{{1
"  \_________________________________________________________________________|
set hidden               " Allow buffer switching without being forced to save
set noerrorbells         " Disable error bells.
set ve=block             " Allow free movement in visual-block mode.
set showmatch            " Show matching braces and brackets.
set mat=5                " How many tenths of a second to show a match.
set nohlsearch           " Don't continue to highlight searched phrases.
set incsearch            " But do highlight as you type your search.
set ignorecase           " Make searches case-insensitive.
set smartcase            " Override ignorecase when caps are used.
set so=5                 " Keep 5 lines for scope.
set siso=5               " Keep 5 lines for scope.
set nu                   " Show line numbers.
set wildmenu             " Enhanced commandline completion.
set ruler                " Always show info along bottom.
set splitbelow           " Open new horizontal splits below the current.
set splitright           " Open new vertical splits to the right.
set cmdheight=2          " Commandline spans 2 rows.
set laststatus=2         " Last window always has a statusline.
set lazyredraw           " Faster cursor scrolling.
set cursorline           " Highlight cursor line.
hi CursorLine term=NONE cterm=NONE ctermbg=236 guifg=NONE guibg=#333333
hi CursorLineNr term=bold cterm=NONE ctermfg=11 gui=bold guifg=Yellow

set wildmode=longest,list

if exists('$TMUX')
    " Disable background color erase (BCE) in tmux to fix bgcolor
    set t_ut=
endif

if !has("gui_running")
    if has("mac")
        if exists('$TMUX')
            let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
            let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
        else
            let &t_SI = "\<Esc>]50;CursorShape=1\x7"
            let &t_EI = "\<Esc>]50;CursorShape=0\x7"
        endif
    endif
endif

" Ignore these patterns during completion.
set wildignore=*.pyc,*.egg-info/*,*.egg/*,*/node_modules/*,*/build/*,*/coverage/*,*/dist/*,package-lock.json

" Enable folding and make it indent-sensitive.
if version >= 600
    set foldenable
    set foldlevel=100
    set fmr={,} 
    set foldmethod=marker
    " set foldminlines=4
endif
"set foldopen-=search     " Don't open folds when you search into them.
"set foldopen-=undo       " Don't open folds when you undo stuff.

if version >= 700
    set showtabline=2     " Always show tab bar.

    " Use longest common text for completion.
    set completeopt=longest,menuone
endif

" Get rid of bell and visualbell
set visualbell t_vb=
if has("multi_byte")
   scriptencoding utf-8  " Make sure the following is read as utf8.
   "set list listchars=eol:§,tab:»·,trail:·,extends:»,precedes:«
   set list listchars=tab:»·,trail:·
   scriptencoding
endif

if has("gui_running")
    set guioptions-=T
    set guioptions-=m
    set guioptions-=L
    set guioptions-=r
    set showtabline=0  " Hide tab bar
    set guicursor=a:blinkon0 " Disable gui cursor blinking.
    "set guifont=Monaco:h12
    set guifont=Menlo\ Regular\ for\ Powerline:h14
    hi CursorColumn guibg=#333333
    au GUIEnter * cd ~/git
endif

" Restore last edited position (help last-position-jump).
au BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$")
  \         && bufname('%') != 'svn-commit.tmp'
  \         && expand('%') !~ 'COMMIT_EDITMSG' |
  \     exe "normal g`\"" |
  \ endif


                                                                        " }}}1
" | 05. Text Formatting/Layout .. Text, tab, indentation related ---------{{{1
"  \_________________________________________________________________________|
set fo=tcrqn             " See help (complex).
set ai                   " Auto-indent.
set backspace=2          " Backspace behavior.
"set si                   " Smart indent.      \ Replaced w/ filetype indent
"set cindent              " C-style indenting. /
set cinkeys-=0#          " Prevent unindenting of '#'.
set tabstop=8            " Tab spacing (settings below correspond to unify.
set softtabstop=4        " Unify.
set shiftwidth=4         " Indent/outdent by 4 columns.
set shiftround           " Always indent/outdent to the nearest tabstop.
set expandtab            " Use spaces instead of tabs.
set smarttab             " Use tabs at the start of a line, spaces elsewhere.
set nowrap               " Don't wrap text.

                                                                        " }}}1
" | 06. Abbreviations ........... General abbreviations ------------------{{{1
"  \_________________________________________________________________________|
iab dateR <C-r>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>
iab pgdate <C-r>=strftime("%Y-%m-%d 00:00:00")<CR>
iab pgtime <C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>
iab xymd <C-r>=strftime("%Y-%m-%d")<CR>
iab xdMy <C-r>=strftime("%d %M %Y")<CR>
iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit
iab llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi
iab lllorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi.  Integer hendrerit lacus sagittis erat fermentum tincidunt.  Cras vel dui neque.  In sagittis commodo luctus.  Mauris non metus dolor, ut suscipit dui.  Aliquam mauris lacus, laoreet et consequat quis, bibendum id ipsum.  Donec gravida, diam id imperdiet cursus, nunc nisl bibendum sapien, eget tempor neque elit in tortor

                                                                        " }}}1
" | 07. Mappings ................ General mappings -----------------------{{{1
"  \_________________________________________________________________________|

" NORMAL mode ------------------------------------------------------------{{{2
" Make Y more logical:
nnoremap Y y$

" Remap ^d to quit vim:
nnoremap <C-d> :quit<CR>

nnoremap <leader>w /[A-Z]<CR>

" More easily navigate windows.
" nnoremap <C-j> <c-w>j
" nnoremap <C-k> <c-w>k
" nnoremap <C-l> <c-w>l
" nnoremap <C-h> <c-w>h

" Turn on/off search highlighting.
nnoremap <silent> <leader>h :se invhlsearch<CR>

" Reformat/reindent pasted text.
nnoremap <Esc>P P'[v']=
nnoremap <Esc>p p'[v']=

" Toggle fold under cursor.
nnoremap  <silent>  <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>

" Add phpDoc-style comment to function:
nnoremap <leader>* ?function<CR>f(yi(O/**<CR><CR><CR><Esc>p'[a <Esc>:s/\$/@/ge<CR>:s/,\s*/\r * /ge<CR>o/<Esc>v?\/\*\*<CR>=jA 

" Fill in a PHP function argument list:
nnoremap <silent> <leader>k :read !lynx -dump /usr/share/doc/php-doc/html/function.<C-R>=tr(expand("<cword>"), "_", "-")<CR>.html \| grep -A2 Description \| egrep -o "\(.*\)"<CR>kgJ

" Convert between underscore and camelcase:
nnoremap <leader>- ciw<C-R>=SwitchStyle("<C-R>"")<CR><ESC>

" Faster :e
nnoremap ,e :e <C-R>=Look()<CR><C-D>

" Re-select paste
nnoremap ,v V']

" Run make on current file.
nnoremap <silent> <F5> :make<CR>:cw<CR>

                                                                        " }}}2
" INSERT mode ------------------------------------------------------------{{{2
inoremap <leader><tab>  <c-r>=MakeBlock()<cr>

" Make middle-click paste indent-friendly.
"inoremap <MiddleMouse> <ESC>:set paste<CR>"*p:set paste!<CR>'[v']=

" Easier omni-completion mapping
inoremap <c-space> <c-x><c-o>

" Next-line shortcuts
inoremap <S-CR> <ESC>o
inoremap <C-S-CR> <ESC>A;<CR>

" Emacs-style home/end
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$

                                                                        " }}}2
" VISUAL mode ------------------------------------------------------------{{{2
" Visual searching:
vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" Color conversion
vnoremap <leader>r c<C-R>=color_convert#hex2rgb('<C-R>"')<CR><ESC>
vnoremap <leader>h c<C-R>=color_convert#rgb2hex('<C-R>"')<CR><ESC>
" #ffffff

" Bubble text
vnoremap <C-j> dpV']
vnoremap <C-k> dkPV']

" Center selection within window (zz for visual selection):
vnoremap zz <ESC>'<:<C-R>=(line("'>") - line("'<") + 1) / 2 + line("'<")<CR><CR>zzgv"'")'

" Increment column (from https://github.com/toranb/dotfiles/blob/daf05812bed08b9c6d367aeb0b6ccd12764765dd/vimrc#L288
vnoremap <C-a> :call Incr()<CR>

                                                                        " }}}2
" COMMAND mode -----------------------------------------------------------{{{2

                                                                        " }}}2

                                                                        " }}}1
" | 08. Functions/Commands ...... General functions and commands ---------{{{1
"  \_________________________________________________________________________|
function! Look() " -------------------------------------------------------{{{2
    let working = expand('%:h')
    if working == ''
        return ''
    else
        return working . '/'
    endif
endfunction
                                                                        " }}}2
function! Underscore2Camelcase(text) " -----------------------------------{{{2
   return substitute(a:text, "_\\([a-z]\\)", "\\U\\1", "g")
endfunction
                                                                        " }}}2
function! Camelcase2Underscore(text) " -----------------------------------{{{2
   return substitute(a:text, "\\C\\([A-Z]\\)", "_\\L\\1", "g")
endfunction
                                                                        " }}}2
function! SwitchStyle(text) " --------------------------------------------{{{2
   if match(a:text, "_") > 0
      return Underscore2Camelcase(a:text)
   else
      return Camelcase2Underscore(a:text)
   fi
endfunction
                                                                        " }}}2
function! CompleteBlock() " ----------------------------------------------{{{2
   return ") {\<CR>}\<Esc>kf)i"
endfunction
                                                                        " }}}2
function! MakeBlock() " --------------------------------------------------{{{2
   return "(" . CompleteBlock()
endfunction
                                                                        " }}}2
function! InsertTabWrapper() " -------------------------------------------{{{2
    " Smart tab completion.
   let col = col('.') - 1
   let line = getline('.')
   if (match(line, '\(require\|include\)') >= 0)
      return "\<C-x>\<C-f>"
   elseif col && getline('.')[col - 1] == '('
      return CompleteBlock()
   "elseif col && getline('.')[col - 1] !~ '\k'
   "   return MakeBlock()
   elseif col && getline('.')[col - 1] =~ '\k'
      "return "\<C-x>\<C-o>"
      return "\<C-n>"
   else
      return "\<tab>"
   endif
endfunction
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>
                                                                        " }}}2
function! SetWidth(width) " ----------------------------------------------{{{2
    execute "set tabstop=" . a:width
    execute "set softtabstop=" . a:width
    execute "set shiftwidth=" . a:width
    echo "Indentation width set to " . a:width
endfunction
command! -nargs=1 SetWidth call SetWidth(<q-args>)
                                                                        " }}}2
function! EnsureDirExists(dir) " -----------------------------------------{{{2
    if a:dir != "."
        if !isdirectory(a:dir)
            if exists("*mkdir")
                call mkdir(a:dir, "p")
            endif
        endif
    endif
endfunction
                                                                        " }}}2
function! Incr() " -------------------------------------------------------{{{2
    let a = line('.') - line("'<'")
    let c = virtcol("'<'")
    if a > 0
        execute 'normal! '.c.'|'.a."\<C-a>"
    endif
    normal `<
endfunction
                                                                        " }}}2
function! Standard() " ---------------------------------------------------{{{2
    let g:syntastic_javascript_checkers = ['standard']
    let g:ultisnips_javascript = {
        \ 'keyword-spacing': 'always',
        \ 'semi': 'never',
        \ 'space-before-function-paren': 'always',
        \ }
    call SetWidth(2)
endfunction
command! -nargs=0 Standard call Standard()
                                                                        " }}}2

                                                                        " }}}1
" | 09. Plugins ................. Plugin-specific settings ---------------{{{1
" |                                                                          |
" | ALE                          |----------------------------------------{{{2
"  \_________________________________________________________________________|
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ }
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_set_highlights = 0
highlight clear ALEErrorSign
highlight clear ALEWarningSign

                                                                        " }}}2
" | delimitMate                  |----------------------------------------{{{2
"  \_________________________________________________________________________|
" Temporarily disable enter-indent to experiment with <CR> expansion via
" delimitMate. If I can achieve what I want with delimitMate, I'll be
" removing enter-indent entirely.
let g:loaded_enter_indent = 1
let g:delimitMate_expand_cr = 1

                                                                        " }}}2
" | Emmet                        |----------------------------------------{{{2
"  \_________________________________________________________________________|
" Turn on Emmet for JSX in *.js files
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}

                                                                        " }}}2
" | FZF                          |----------------------------------------{{{2
"  \_________________________________________________________________________|
nnoremap ,t :<C-u>FZF<CR>

                                                                        " }}}2
" | Indent Guides                |----------------------------------------{{{2
"  \_________________________________________________________________________|
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
au VimEnter,Colorscheme * if &ft != 'help' | :hi IndentGuidesOdd  guibg=#272727 | endif
au VimEnter,Colorscheme * if &ft != 'help' | :hi IndentGuidesEven guibg=#323232 | endif
                                                                        " }}}2
" | JavaScript                   |----------------------------------------{{{2
"  \_________________________________________________________________________|
let g:javascript_plugin_jsdoc = 1

                                                                        " }}}2
" | JSX Pretty                   |----------------------------------------{{{2
"  \_________________________________________________________________________|
let g:jsx_ext_required = 0
                                                                        " }}}2
" | Lightline                    |----------------------------------------{{{2
"  \_________________________________________________________________________|
" Modifications from stock setup:
" active.left:
"   - add projectiontype
"   - replace filename with relativepath
" active.right:
"   - remove ['fileformat', 'fileencoding', 'filetype']
let g:lightline = {
    \ 'active': {
    \   'left': [['mode', 'paste'], ['projectiontype', 'readonly', 'relativepath', 'modified']],
    \   'right': [['lineinfo'], ['percent']],
    \ },
    \ 'component_function': {
    \   'projectiontype': 'LightlineProjectionistType',
    \ },
    \ }

function! LightlineProjectionistType()
    return join(projectionist#query_scalar('type'), '+')
endfunction

                                                                        " }}}2
" | LustyJuggler / LustyExplorer |----------------------------------------{{{2
"  \_________________________________________________________________________|
" High Sierra altered ruby version, breaking this plugin.
let g:LustyExplorerSuppressRubyWarning = 1
                                                                        " }}}2
" | SnipMate                     |----------------------------------------{{{2
"  \_________________________________________________________________________|
if filereadable($HOME."/.vim/snippets/support_functions.vim")
    exec "source " . $HOME . "/.vim/snippets/support_functions.vim"
endif

                                                                        " }}}2
" | Surround                     |----------------------------------------{{{2
"  \_________________________________________________________________________|
" Switch between double/single quotes:
nmap  <leader>'  cs"'
nmap  <leader>"  cs'"

                                                                        " }}}2
" | Syntastic                    |----------------------------------------{{{2
"  \_________________________________________________________________________|
" Be sure to pip install flake8
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['javascript', 'python'],
                           \ 'passive_filetypes': [] }
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_php_checkers=['php', 'phpcs']
let g:syntastic_php_phpcs_args='--standard=PSR2 -n'

if filereadable("node_modules/@aw-int/aweber-webapp-scripts/.eslintrc") && !filereadable("./.eslintrc")
    let g:syntastic_javascript_eslint_exe = 'npx eslint --config="node_modules/@aw-int/aweber-webapp-scripts/.eslintrc"'
endif

if !has("gui_running")
    let g:syntastic_enable_highlighting=0
endif

                                                                        " }}}2
" | Tabular                      |----------------------------------------{{{2
"  \_________________________________________________________________________|
" Columnate arrays/lists.
vnoremap <silent> <leader>= :Tab /=<CR>
vnoremap <silent> <leader>: :Tab /^[^:]*\zs:\zs/l0l0<CR>


                                                                        " }}}2
" | UltiSnips                    |----------------------------------------{{{2
"  \_________________________________________________________________________|
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

                                                                        " }}}2

" }}}1 vim: foldmethod=marker:foldlevel=0:fml=1
