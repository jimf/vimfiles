"-------------------------------------------------------------------------{{{1
" Maintainer: Jim Fitzpatrick <fitzpatrick.jim@gmail.com>                    |
"   Revision: $Rev$                                                          |
"        URL: http://github.com/jimf/vimfiles                                |
"                                                                            |
" Sections:                                                                  |
"   01. General ................. General Vim behavior                       |
"   02. Events .................. General autocmd events                     |
"   03. Theme/Colors ............ Colors, fonts, etc.                        |
"   04. Vim UI .................. User interface behavior                    |
"   05. Text Formatting/Layout .. Text, tab, indentation related             |
"   06. Abbreviations ........... General abbreviations                      |
"   07. Mappings ................ General mappings                           |
"   08. Functions/Commands ...... General functions and commands             |
"   09. Plugins                                                              |
"     09a. CommandT                                                          |
"     09b. LustyJuggler / LustyExplorer                                      |
"     09c. SnipMate                                                          |
"     09c. Surround                                                          |
"     09e. Syntastic                                                         |
"     09f. Tabular                                                           |
"     09g. Tagbar                                                            |
"     09h. Zen-Coding                                                        |
"-------------------------------------------------------------------------}}}1

" | 01. General ................. General Vim behavior -------------------{{{1
"  \_________________________________________________________________________|
set nocompatible         " Get rid of Vi compatibility mode. SET FIRST!

" Update runtime path to include ~/.vim/bundle directory
silent! call pathogen#infect()
silent! call pathogen#helptags()

set mouse=a              " Enable the mouse for all modes.
set history=500          " Number of lines of history to remember.
set isk+=_,$,@,%,#,:     " Make these characters count as part of a word.
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

augroup MassageFiletype                                                 " {{{2
    " Make sure the correct filetype is applied to these files:
    autocmd!
    autocmd BufRead *.ctp setlocal filetype=php
    autocmd BufRead *.erb setlocal filetype=ruby
    autocmd BufRead *.htm setlocal filetype=php
    autocmd BufRead *.html setlocal filetype=php
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
    autocmd BufWritePost *.coffee silent CoffeeMake! -b | cwindow
    autocmd FileType coffee setlocal softtabstop=2
    autocmd FileType coffee setlocal shiftwidth=2
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
    autocmd FileType python setlocal makeprg=./bin/pylint\ --rcfile=./pylintrc\ --reports=n\ --output-format=parseable\ %:p
    autocmd FileType python setlocal efm=%A%f:%l:\ [%t%.%#]\ %m,%Z%p^^,%-C%.%#
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
    au BufWritePost * if &filetype == "python" | call RunAllTests('test') | endif
augroup END
                                                                        " }}}2
augroup RubyEvents                                                      " {{{2
    autocmd!
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
augroup END
                                                                        " }}}2
augroup SassyEvents                                                     " {{{2
    autocmd!
    autocmd FileType scss setlocal softtabstop=2
    autocmd FileType scss setlocal shiftwidth=2
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
augroup NewFileTemplates                                                " {{{2
    autocmd!
    au BufNewFile *.pm      :call LoadTemplate('Moose')
    au BufNewFile *.pl      :call LoadTemplate('Perl')
    au BufNewFile *.t       :call LoadTemplate('PerlTest')
    au BufNewFile *.php     :call LoadTemplate('PHP')
    au BufNewFile setup.py  :call LoadTemplate('Setup')
    au BufNewFile *_test.py :call LoadTemplate('PythonTest')
    au BufNewFile test_*.py :call LoadTemplate('PythonTest')
    au BufNewFile *.py      :call LoadTemplate('Python')
augroup END                                                             " }}}2


                                                                        " }}}1
" | 03. Theme/Colors ............ Colors, fonts, etc. --------------------{{{1
"  \_________________________________________________________________________|
set t_Co=256             " Enable 256-color mode.
syntax enable            " Enable syntax highlighting (previously syntax on).

syn keyword Todo contained TODO FIXME XXX NOTE
hi link awError Error
match awError /^[} \t]*\zs\(else\?\)\? \?if(/

if has("gui_running")
    if filereadable($HOME."/.vim/colors/xoria256.vim") || filereadable($VIMRUNTIME."/colors/xoria256.vim")
        colorscheme xoria256
    endif
else
    if filereadable($HOME."/.vim/colors/desert256.vim") || filereadable($VIMRUNTIME."/colors/desert256.vim")
        colorscheme desert256
    endif
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
if exists("*fugitive#statusline")
    set statusline=\ %f%m%r%h\ %w\ \ %r%{Context()}%h%{fugitive#statusline()}%=%-14.(%l,%c/%L%V%)\ %P
else
    set statusline=\ %f%m%r%h\ %w\ \ %r%{Context()}%h%=%-14.(%l,%c/%L%V%)\ %P
endif

" Ignore these patterns during completion.
set wildignore=*.pyc,*.egg-info/*,*.egg/*

function! GetProjectName()
    let location=expand('%:p')
    if location == ''
        let location = getcwd()
    endif
    let location = substitute(location, $HOME, "~", "g")
    if match(location, '\~/svn/packages/') == 0
        return substitute(substitute(location, '\~/svn/packages/', '', ''), '/.*', '', '')
    elseif match(location, '\~/svn/projects/') == 0
        return substitute(substitute(location, '\~/svn/projects/[^/]\{-}/', '', ''), '/.*', '', '')
    elseif match(location, '\~/git/') == 0
        return substitute(substitute(location, '\~/git/', '', ''), '/.*', '', '')
    else
        return ''
    endif
endfunction

function! GetMVCType()
    let parentdir = expand('%:p:h:t')
    if parentdir =~ 'controller\|controllers'
        return 'controller'
    elseif parentdir == 'model\|models'
        return 'model'
    elseif parentdir =~ 'views\|templates\|view_wrappers'
        return 'view'
    else
        return ''
endfunction

function! IsTestFile()
    return match(expand('%:p'), 'test') >= 0
endfunction

function! Context()
    let context = ''
    let project = GetProjectName()
    if project != ''
        let context = '[' . project . ']'
    else
        let context = '[No Project]'
    endif

    let type = GetMVCType()
    if type != ''
        if IsTestFile()
            let context = context . '[' . type . ' test]'
        else
            let context = context . '[' . type . ']'
        endif
    endif

    return context
endfunction

" Enable folding and make it indent-sensitive.
if version >= 600
    set foldenable
    set foldlevel=100
    set fmr={,} 
    set foldmethod=marker
    set foldminlines=4
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
    set lines=999 columns=160
    set guioptions-=T
    set guioptions-=m
    set guioptions-=L
    set guioptions-=r
    set guicursor=a:blinkon0 " Disable gui cursor blinking.
    "set guifont=Monaco:h12
    set guifont=Menlo\ Regular\ for\ Powerline:h14
    set cursorline
    hi cursorline guibg=#333333 
    hi CursorColumn guibg=#333333
    au GUIEnter * cd ~/svn/packages
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
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l
nnoremap <C-h> <c-w>h

" Turn on/off search highlighting.
nnoremap <silent> <leader>h :se invhlsearch<CR>

" Reformat/reindent pasted text.
nnoremap <Esc>P P'[v']=
nnoremap <Esc>p p'[v']=

" Toggle fold under cursor.
nnoremap  <silent>  <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>

" Switch between buffers.
nnoremap <right> <ESC>:bn<RETURN>
nnoremap <left> <ESC>:bp<RETURN>

" Add phpDoc-style comment to function:
nnoremap <leader>* ?function<CR>f(yi(O/**<CR><CR><CR><Esc>p'[a <Esc>:s/\$/@/ge<CR>:s/,\s*/\r * /ge<CR>o/<Esc>v?\/\*\*<CR>=jA 

" Fill in a PHP function argument list:
nnoremap <silent> <leader>k :read !lynx -dump /usr/share/doc/php-doc/html/function.<C-R>=tr(expand("<cword>"), "_", "-")<CR>.html \| grep -A2 Description \| egrep -o "\(.*\)"<CR>kgJ

" Convert between underscore and camelcase:
nnoremap <leader>- ciw<C-R>=SwitchStyle("<C-R>"")<CR><ESC>

" Faster :e
nnoremap ,e :e <C-R>=Look()<CR><C-D>

" Call RunAllTests
nnoremap <leader>a :call RunAllTests('')<cr>:redraw<cr>:call JumpToError()<cr>

" Re-select paste
nnoremap ,v V']

" Run make on current file.
nnoremap <silent> <F5> :make<CR>:cw<CR>

" SVN Diff the given file.
nnoremap <F6> :!/usr/bin/svn diff --diff-cmd /Applications/RoaringDiff.app/Contents/MacOS/RoaringDiff <C-r>%<CR>

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

                                                                        " }}}2
" VISUAL mode ------------------------------------------------------------{{{2
" Visual searching:
vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" SVN blame a block of text:
vnoremap <leader>b :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Bubble text
vnoremap <C-j> dpV']
vnoremap <C-k> dkPV']

" Center selection within window (zz for visual selection):
vnoremap zz <ESC>'<:<C-R>=(line("'>") - line("'<") + 1) / 2 + line("'<")<CR><CR>zzgv"'")'

                                                                        " }}}2
" COMMAND mode -----------------------------------------------------------{{{2
" Faster access to common directories:
cnoremap <leader>a ~/svn/trunk/code/sites/aweber_app/
cnoremap <leader>w ~/svn/trunk/code/sites/aweber_app/webroot/

                                                                        " }}}2

                                                                        " }}}1
" | 08. Functions/Commands ...... General functions and commands ---------{{{1
"  \_________________________________________________________________________|
function! CdToProjectBase() " --------------------------------------------{{{2
   let _dir = strpart(expand("%:p:h"), 0, matchend(expand("%:p:h"), "_app"))
   exec "cd " . _dir
   unlet _dir
endfunction
                                                                        " }}}2
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
function! DimLogging() " -------------------------------------------------{{{2
    exec "hi DimmedLogging ctermfg=darkgray guibg=#333333"
    exec "match DimmedLogging /^\s*$self->log.*$/"
endfunction
                                                                        " }}}2
function! SetWidth(width) " ----------------------------------------------{{{2
    execute "set tabstop=" . a:width
    execute "set softtabstop=" . a:width
    execute "set shiftwidth=" . a:width
    echo "Indentation width set to " . a:width
endfunction
command! -nargs=1 SetWidth call SetWidth(<q-args>)
                                                                        " }}}2
function! OpenTests(pbase, tbase, tglob) " -------------------------------{{{2
    " TODO: use finddir with a contat'ed let/expand to recursively search for
    " the tests/ directory
    let testdir = substitute(expand("%:p:r"), a:pbase, a:tbase, "")
    if isdirectory(testdir)
        let testfiles = split(glob(testdir . "/" . a:tglob), "\0")
        if len(testfiles) == 0
            echo "No tests found in test directory"
        elseif len(testfiles) == 1
            execute "e " . testfiles[0]
        else
            execute "e " . testdir
        endif
    elseif filereadable(testdir . substitute(a:tglob, "*", "", ""))
        execute "e " . testdir . substitute(a:tglob, "*", "", "")
    else
        echo "Could not find test file(s) or directory"
    endif
endfunction
au FileType perl command! -nargs=0 Tests call OpenTests("awlib", "awlib/tests", "*.t")
au FileType python command! -nargs=0 Tests call OpenTests("Python", "Python/tests", "_test.py")
                                                                        " }}}2
function! OpenPackageTests() " -------------------------------------------{{{2
    let testdir = finddir("tests", expand("%:h").";")
    if strlen(testdir) > 0
        execute "e " . testdir
    else
        echo "Test directory not found"
    endif
endfunction
                                                                        " }}}2
function! LoadTemplate(template_name) " ----------------------------------{{{2
    if !exists("g:templates_loaded")
        let g:templates_loaded = {}
    endif

    let curfile = expand("%:p")
    if !has_key(g:templates_loaded, curfile)
        let g:templates_loaded[curfile] = 1
        let template_path = $HOME.'/Templates/'.a:template_name
        if filereadable(template_path)
            execute ":r " . template_path . " | normal -1dd"
        endif
    endif
endfunction
                                                                        " }}}2
function! Pkg(name) " ----------------------------------------------------{{{2
    let target = substitute(system("$HOME/bin/pkg " . shellescape(a:name)), '\n', '', '')
    if isdirectory(target)
        execute "cd " . target
    else
        echo "Project not found"
    endif
endfunction
command! -nargs=1 Pkg call Pkg(<q-args>)
                                                                        " }}}2
function! RunTests(target, args) " ---------------------------------------{{{2
    silent ! echo
    exec 'silent ! echo -e "\033[1;36mRunning tests in ' . a:target . '\033[0m"'
    silent w
    exec "make " . a:target . " " . a:args
endfunction
                                                                        " }}}2
function! ClassToFilename(class_name) " ----------------------------------{{{2
    let understored_class_name = substitute(a:class_name, '\(.\)\(\u\)', '\1_\U\2', 'g')
    let file_name = substitute(understored_class_name, '\(\u\)', '\L\1', 'g')
    return file_name
endfunction
                                                                        " }}}2
function! ModuleTestPath() " ---------------------------------------------{{{2
    let file_path = @%
    let components = split(file_path, '/')
    let path_without_extension = substitute(file_path, '\.py$', '', '')
    let test_path = 'tests/unit/' . path_without_extension
    return test_path
endfunction
                                                                        " }}}2
function! NameOfCurrentClass() " -----------------------------------------{{{2
    let save_cursor = getpos(".")
    normal $<cr>
    call PythonDec('class', -1)
    let line = getline('.')
    call setpos('.', save_cursor)
    let match_result = matchlist(line, ' *class \+\(\w\+\)')
    let class_name = ClassToFilename(match_result[1])
    return class_name
endfunction
                                                                        " }}}2
function! TestFileForCurrentClass() " ------------------------------------{{{2
    let class_name = NameOfCurrentClass()
    let test_file_name = ModuleTestPath() . '/test_' . class_name . '.py'
    return test_file_name
endfunction
                                                                        " }}}2
function! TestModuleForCurrentFile() " -----------------------------------{{{2
    let test_path = ModuleTestPath()
    let test_module = substitute(test_path, '/', '.', 'g')
    return test_module
endfunction
                                                                        " }}}2
function! RunTestsForFile(args) " ----------------------------------------{{{2
    if @% =~ 'test_'
        call RunTests('%', a:args)
    else
        let test_file_name = TestModuleForCurrentFile()
        call RunTests(test_file_name, a:args)
    endif
endfunction
                                                                        " }}}2
function! RunAllTests(args) " --------------------------------------------{{{2
    if filereadable('./Makefile')
        silent ! echo
        "exec "set makeprg=make\\ NOSE='bin/nosetests\\ --no-color\\ --machine-out'"
        exec "set makeprg=env/bin/python\\ setup.py\\ -q\\ nosetests\\ --with-machineout\\ --no-color"
        set errorformat=%f:%l:\ %m
        exec "AsyncMakeGreen " . a:args
    endif
endfunction
                                                                        " }}}2
function! JumpToTestsForClass() " ----------------------------------------{{{2
    exec 'e ' . TestFileForCurrentClass()
endfunction
                                                                        " }}}2
function! PresentationSettings() " ---------------------------------------{{{2
    "exec 'set guifont=Monaco:h22'
    set guifont=Menlo\ Regular\ for\ Powerline:h24
endfunction
                                                                        " }}}2

                                                                        " }}}1
" | 09. Plugins ................. Plugin-specific settings ---------------{{{1
" |                                                                          |
" | 09a. AsyncMakeGreen               |-----------------------------------{{{2
"  \_________________________________________________________________________|
let g:async_make_green_use_make_output_on_success = 1

                                                                        " }}}2
" | 09a. CommandT                     |-----------------------------------{{{2
"  \_________________________________________________________________________|
map ,t :CommandT<CR>
nnoremap ,b :CommandTBuffer<CR>

                                                                        " }}}2
" | 09b. delimitMate                  |-----------------------------------{{{2
"  \_________________________________________________________________________|
let g:delimitMate_smart_quotes = 0

                                                                        " }}}2
" | 09b. Gist                         |-----------------------------------{{{2
"  \_________________________________________________________________________|
let g:gist_github_hostname = 'github.colo.lair'
let g:gist_force_http = 1
let g:gist_open_browser_after_post = 1
if filereadable($HOME."/.vimrc_secret_git")
    exec "source ".$HOME."/.vimrc_secret_git"
endif
                                                                        " }}}2
" | 09c. Indent Guides                |-----------------------------------{{{2
"  \_________________________________________________________________________|
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
au VimEnter,Colorscheme * if &ft != 'help' | :hi IndentGuidesOdd  guibg=#272727 | endif
au VimEnter,Colorscheme * if &ft != 'help' | :hi IndentGuidesEven guibg=#323232 | endif
                                                                        " }}}2
" | 09d. LustyJuggler / LustyExplorer |-----------------------------------{{{2
"  \_________________________________________________________________________|
if !has('gui_running')
    let g:LustyExplorerSuppressRubyWarning = 1
    let g:LustyJugglerSuppressRubyWarning = 1
endif
                                                                        " }}}2
" | 09d. Powerline                    |-----------------------------------{{{2
"  \_________________________________________________________________________|
let g:Powerline_symbols = 'fancy'
                                                                        " }}}2
" | 09d. RedGreen                     |-----------------------------------{{{2
"  \_________________________________________________________________________|
hi GreenBar term=reverse ctermfg=white ctermbg=green guifg=white guibg=green4
hi RedBar   term=reverse ctermfg=white ctermbg=red   guifg=white guibg=red3

                                                                        " }}}2
" | 09d. SnipMate                     |-----------------------------------{{{2
"  \_________________________________________________________________________|
if filereadable($HOME."/.vim/snippets/support_functions.vim")
    exec "source " . $HOME . "/.vim/snippets/support_functions.vim"
endif

                                                                        " }}}2
" | 09e. Surround                     |-----------------------------------{{{2
"  \_________________________________________________________________________|
" Switch between double/single quotes:
nmap  <leader>'  cs"'
nmap  <leader>"  cs'"

                                                                        " }}}2
" | 09f. Syntastic                    |-----------------------------------{{{2
"  \_________________________________________________________________________|
" Be sure to pip install flake8
if has("gui_running")
    let g:syntastic_mode_map = { 'mode': 'active',
                               \ 'active_filetypes': ['javascript', 'python'],
                               \ 'passive_filetypes': [] }
    let g:syntastic_enable_signs=1
    let g:syntastic_auto_jump=1
    let g:syntastic_auto_loc_list=1
    let g:syntastic_javascript_jshint_conf = $HOME . "/.jshintrc"
else
    let g:syntastic_enable_signs=0
endif

                                                                        " }}}2
" | 09g. Tabular                      |-----------------------------------{{{2
"  \_________________________________________________________________________|
" Columnate arrays/lists.
vnoremap <silent> <leader>= :Tab /=<CR>
vnoremap <silent> <leader>: :Tab /^[^:]*\zs:\zs/l0l0<CR>


                                                                        " }}}2
" | 09h. Tagbar                       |-----------------------------------{{{2
"  \_________________________________________________________________________|
nnoremap TT :TagbarToggle<CR>

                                                                        " }}}2
" | 09i. Zen-Coding                   |-----------------------------------{{{2
"  \_________________________________________________________________________|
let g:user_zen_settings = {'indentation': '  '}

                                                                        " }}}2

" }}}1 vim: foldmethod=marker:foldlevel=0:fml=1
