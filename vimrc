""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: Jim Fitzpatrick <fitzpatrick.jim@gmail.com>                    "
"   Revision: $Rev$                                                          "
"        URL: http://github.com/jimf/vimfiles                                "
"                                                                            "
" Sections:                                                                  "
"   01. General ................. General Vim behavior                       "
"   02. Events .................. General autocmd events                     "
"   03. Theme/Colors ............ Colors, fonts, etc.                        "
"   04. Vim UI .................. User interface behavior                    "
"   05. Text Formatting/Layout .. Text, tab, indentation related             "
"   06. Abbreviations ........... General abbreviations                      "
"   07. Mappings ................ General mappings                           "
"   08. Functions/Commands ...... General functions and commands             "
"   09. Plugins                                                              "
"     09a. FuzzyFinder                                                       "
"     09b. Tagbar                                                            "
"     09c. CommandT                                                          "
"     09c. Sparkup                                                           "
"     09e. SnipMate                                                          "
"     09f. Syntastic                                                         "
"                                                                            "
" Recommended Plugins:                                                       "
"   -> Align.vim                                                             "
"   -> bufexplorer                                                           "
"   -> CommandT                                                              "
"   -> FuzzyFinder                                                           "
"   -> FuzzyFinderTextMate                                                   "
"   -> MRU.vim                                                               "
"   -> pathogen                                                              "
"   -> snipMate.vim                                                          "
"   -> Tagbar                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 01. General                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible         " Get rid of Vi compatibility mode. SET FIRST!

" Update runtime path to include ~/.vim/bundle directory
filetype off
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#helptags()

set history=500          " Number of lines of history to remember.
set isk+=_,$,@,%,#,:     " Make these characters count as part of a word.
set isfname-=-           " Make these characters NOT count as part of filename
set viminfo+=!           " Make sure we can save viminfo.
set autoread             " Automatically re-read file when externally modified
set autowrite            " Automatically write changes when running :make.
set switchbuf=useopen    " See :he switchbuf
set tags+=tags;$HOME     " Look for tags in parent dirs


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]

" Make sure the correct filetype is applied to these files:
augroup MassageFiletype
    autocmd!
    autocmd BufRead *.ctp set filetype=php
    autocmd BufRead *.erb set filetype=ruby
    autocmd BufRead *.htm set filetype=php
    autocmd BufRead *.html set filetype=php
    autocmd BufRead *.mako set filetype=mako
    autocmd BufRead *.t set filetype=perl
    autocmd BufRead *.thtml set filetype=php
    autocmd BufRead * if match(expand("%:p:h"), 'config/cron') > 0 | set ft=crontab | endif
    autocmd BufRead psql.edit.* set filetype=psql
    autocmd BufRead *.pp set filetype=ruby
    autocmd BufRead *.txt set filetype=txt
    autocmd BufRead *.zsh set filetype=zsh
    autocmd BufRead *.zsh-theme set filetype=zsh
    autocmd BufRead Vagrantfile set filetype=ruby
augroup END

autocmd FileType make setlocal noet sw=8
"au BufWritePost * if getline(1) =~ "^#!" | silent !chmod +x % | endif

augroup PerlEvents
    autocmd!
    autocmd FileType perl setlocal makeprg=perl\ -c\ %
    autocmd FileType perl setlocal errorformat=%f:%l:%m
    autocmd FileType perl iab echo print
    autocmd FileType perl set path+=~/svn/trunk/code/awlib/AW,/etc/perl,/usr/local/lib/perl/5.8.8,/usr/local/share/perl/5.8.8,/usr/lib/perl5,/usr/share/perl5,/usr/lib/perl/5.8,/usr/share/perl/5.8
    autocmd FileType perl nmap <leader>m :vimgrep /^\s*sub / %<CR>:cw<CR>zO
augroup END

augroup PhpEvents
    autocmd!
    autocmd FileType php match Error /}\zs \/\/ \?close.*$/
    autocmd FileType php setlocal isk-=-
    autocmd FileType php setlocal makeprg=php\ -l\ %
    autocmd FileType php setlocal errorformat=%t:\ %m\ in\ %f\ on\ line\ %l
    autocmd FileType php setlocal keywordprg=~/bin/php_doc
augroup END

augroup PythonEvents
    autocmd!
    autocmd FileType python set textwidth=72
    "if filereadable('./bin/pylint') && filereadable('./pylintrc')
    autocmd FileType python setlocal makeprg=./bin/pylint\ --rcfile=./pylintrc\ --reports=n\ --output-format=parseable\ %:p
    autocmd FileType python setlocal efm=%A%f:%l:\ [%t%.%#]\ %m,%Z%p^^,%-C%.%#
    "autocmd FileType python setlocal makeprg=(echo\ '[%:p]';\ rpylint\ --include-pep\ %:p)
    "autocmd FileType python setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m
    autocmd FileType python setlocal keywordprg=pydoc
    autocmd FileType python set isk-=:
    autocmd FileType python let python_highlight_all = 1
    autocmd FileType python nmap <leader>m :vimgrep /^\s*def / %<CR>:cw<CR>zO
    autocmd FileType python set suffixes+=.pyc,.pyo
    au BufEnter * if &filetype == "python" | match ErrorMsg '\%>79v.\+' | endif
    au BufLeave * match
    au BufEnter * if &filetype == "python" && v:version >= 703 | set colorcolumn=80 | endif
    au BufLeave * if v:version >= 703 | set colorcolumn=0 | endif
augroup END

augroup RubyEvents
    autocmd!
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
augroup END

augroup TextEvents
    autocmd!
    autocmd FileType txt setlocal wrap
    autocmd FileType txt setlocal spell spelllang=en_us
augroup END

" Filetype completion
set complete=.
if filereadable($HOME."/.vim/complete")
    set complete+=k$HOME/.vim/complete
endif
if version >= 700
   autocmd FileType python set omnifunc=pythoncomplete#Complete
   autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
   autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
   autocmd FileType css set omnifunc=csscomplete#CompleteCSS
   autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
   autocmd FileType php set omnifunc=phpcomplete#CompletePHP
   autocmd FileType c set omnifunc=ccomplete#Complete
endif

augroup NewFileTemplates
    autocmd!
    au BufNewFile *.pm      :call LoadTemplate('Moose')
    au BufNewFile *.pl      :call LoadTemplate('Perl')
    au BufNewFile *.t       :call LoadTemplate('PerlTest')
    au BufNewFile *.php     :call LoadTemplate('PHP')
    au BufNewFile setup.py  :call LoadTemplate('Setup')
    au BufNewFile *_test.py :call LoadTemplate('PythonTest')
    au BufNewFile test_*.py :call LoadTemplate('PythonTest')
    au BufNewFile *.py      :call LoadTemplate('Python')
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors                                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256             " Enable 256-color mode.
syntax enable            " Enable syntax highlighting (previously syntax on).

syn keyword Todo contained TODO FIXME XXX NOTE
hi link awError Error
match awError /^[} \t]*\zs\(else\?\)\? \?if(/"

if has("gui_running")
    if filereadable($HOME."/.vim/colors/xoria256.vim") || filereadable($VIMRUNTIME."/colors/xoria256.vim")
        colorscheme xoria256
    endif
else
    if filereadable($HOME."/.vim/colors/desert256.vim") || filereadable($VIMRUNTIME."/colors/desert256.vim")
        colorscheme desert256
    endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
set cmdheight=2          " Commandline spans 2 rows.
set laststatus=2         " Last window always has a statusline.
set statusline=\ %f%m%r%h\ %w\ \ %r%{Context()}%h\ \ \ Line:\ %l/%L:%c

" Ignore these patterns during completion.
set wildignore=*.pyc,*.egg-info/*

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
    else
        return ''
    endif
endfunction

function! GetMVCType()
    let parentdir = expand('%:p:h:t')
    if parentdir == 'controllers' || parentdir == 'controller'
        return 'controller'
    elseif parentdir == 'model'
        return 'model'
    elseif parentdir == 'templates'
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
    set guifont=Monaco:h12
    set cursorline
    hi cursorline guibg=#333333 
    hi CursorColumn guibg=#333333
    au GUIEnter * cd ~/svn/packages
endif

" Restore last edited position (help last-position-jump).
au BufReadPost * if line("'\"") > 0 && 
   \  line("'\"") <= line("$") | exe "normal g'\"" | endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formatting/Layout                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Abbreviations                                                          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab dateR <C-r>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>
iab pgdate <C-r>=strftime("%Y-%m-%d 00:00:00")<CR>
iab pgtime <C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>
iab xymd <C-r>=strftime("%Y-%m-%d")<CR>
iab xdMy <C-r>=strftime("%d %M %Y")<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 07. Mappings                                                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make Y more logical:
nmap Y y$

" Remap ^d to quit vim:
nmap <C-d> :quit<CR>

nmap <leader>w /[A-Z]<CR>

" Extend <C-l>:
nnoremap <C-l> :set nohls<CR><C-l>

" Visual searching:
vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" Remap F1 to escape, since this is a common mistype:
map <F1> <Esc>
imap <F1> <Esc>

" Change the cwd of vim to the main directory of our app.
noremap <F2> :cd <C-R>=expand("%:p:h")<CR><CR>

" Commit all open buffers to SVN.
"map <F3> :b <C-a><HOME><Right><C-w>!svn ci -m ""<LEFT>
"map <F3> :b <C-a><HOME><Right><C-w>!~/svnci.sh<CR>
map <F3> :!open <C-r>=expand("%:h")<CR><CR>

" Run make on current file.
map <silent> <F5> :make<CR>:cw<CR>

" SVN Diff the given file.
map <F6> :!/usr/bin/svn diff --diff-cmd /Applications/RoaringDiff.app/Contents/MacOS/RoaringDiff <C-r>%<CR>

" Turn on/off search highlighting.
map <silent> <leader>h :se invhlsearch<CR>

" Turn on/off highlighting of misspelled words.
if version >= 700
    autocmd FileType svn setlocal spell spelllang=en_us
    "map <F6> <Esc>:setlocal nospell<CR>
endif


" Complete some brackets to create matching end-bracket.  
"inoremap  { {<CR>}<C-O>O
"inoremap [ []<LEFT>
"inoremap ( () <LEFT><LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
inoremap <leader><tab>  <c-r>=MakeBlock()<cr>

" Reformat/reindent pasted text.
nnoremap <Esc>P P'[v']=
nnoremap <Esc>p p'[v']=

" Toggle fold under cursor.
nnoremap  <silent>  <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>

" Switch between buffers.
map <right> <ESC>:bn<RETURN>
map <left> <ESC>:bp<RETURN>

" Make middle-click paste indent-friendly.
"set mouse=a
"imap <MiddleMouse> <ESC>:set paste<CR>"*p:set paste!<CR>'[v']=

" Columnate arrays/lists.
"vmap <silent> <leader>= :!sed 's/^\s*//' \| sed 's/ *\(=>\?\) */ \1 /' \| column -t -s= \| sed -r 's/(\s*)   (>\| )/\1 =\2/'<CR>gv=
vmap <silent> <leader>= :Align => =<CR>

" Omni-complete class functions: (this can get slow...)
"imap :: ::<C-x><C-o><C-n>
"imap -> -><C-x><C-o><C-n>

" Switch between double/single quotes:
nmap <leader>' di"hr'plr'
nmap <leader>" di'hr"plr"

" Faster access to common directories:
cmap <leader>a code/sites/aweber_app/
cmap <leader>w code/sites/aweber_app/webroot/

" List methods within file:
autocmd FileType php nmap <leader>m :vimgrep /^\s*\(private \\|public \)\?function / %<CR>:cw<CR>zO

" Add phpDoc-style comment to function:
nmap <leader>* ?function<CR>f(yi(O/**<CR><CR><CR><Esc>p'[a <Esc>:s/\$/@/ge<CR>:s/,\s*/\r * /ge<CR>o/<Esc>v?\/\*\*<CR>=jA 

" Fill in a PHP function argument list:
nmap <silent> <leader>k :read !lynx -dump /usr/share/doc/php-doc/html/function.<C-R>=tr(expand("<cword>"), "_", "-")<CR>.html \| grep -A2 Description \| egrep -o "\(.*\)"<CR>kgJ

" Convert between underscore and camelcase:
nmap <leader>- ciw<C-R>=SwitchStyle("<C-R>"")<CR><ESC>

" SVN blame a block of text:
vmap <leader>b :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Faster :e
"map ,e :e <C-R>=expand("%:p:h")."/"<CR><C-D>
map ,e :e <C-R>=Look()<CR><C-D>

" Call RunAllTests
nnoremap <leader>a :call RunAllTests('')<cr>:redraw<cr>:call JumpToError()<cr>

" Re-select paste
nnoremap ,v V']

" Easier omni-completion mapping
inoremap <c-space> <c-x><c-o>

vnoremap <C-j> dpV']
vnoremap <C-k> dkPV']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 08. Functions/Commands                                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CdToProjectBase()
   let _dir = strpart(expand("%:p:h"), 0, matchend(expand("%:p:h"), "_app"))
   exec "cd " . _dir
   unlet _dir
endfunction

function! Look()
    let working = expand('%:h')
    if working == ''
        return ''
    else
        return working . '/'
    endif
endfunction

function! Underscore2Camelcase(text)
   return substitute(a:text, "_\\([a-z]\\)", "\\U\\1", "g")
endfunction

function! Camelcase2Underscore(text)
   return substitute(a:text, "\\C\\([A-Z]\\)", "_\\L\\1", "g")
endfunction

function! SwitchStyle(text)
   if match(a:text, "_") > 0
      return Underscore2Camelcase(a:text)
   else
      return Camelcase2Underscore(a:text)
   fi
endfunction

function! CompleteBlock()
   return ") {\<CR>}\<Esc>kf)i"
endfunction

function! MakeBlock()
   return "(" . CompleteBlock()
endfunction

" Smart tab completion.
function! InsertTabWrapper()
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

function! DimLogging()
    exec "hi DimmedLogging ctermfg=darkgray guibg=#333333"
    exec "match DimmedLogging /^\s*$self->log.*$/"
endfunction

function! SetWidth(width)
    execute "set tabstop=" . a:width
    execute "set softtabstop=" . a:width
    execute "set shiftwidth=" . a:width
    echo "Indentation width set to " . a:width
endfunction
command! -nargs=1 SetWidth call SetWidth(<q-args>)

function! OpenTests(pbase, tbase, tglob)
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

function! OpenPackageTests()
    let testdir = finddir("tests", expand("%:h").";")
    if strlen(testdir) > 0
        execute "e " . testdir
    else
        echo "Test directory not found"
    endif
endfunction

function! LoadTemplate(template_name)
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

function! Pkg(name)
    let target = substitute(system("$HOME/bin/pkg " . shellescape(a:name)), '\n', '', '')
    if isdirectory(target)
        execute "cd " . target
    else
        echo "Project not found"
    endif
endfunction
command! -nargs=1 Pkg call Pkg(<q-args>)

function! RunTests(target, args)
    silent ! echo
    exec 'silent ! echo -e "\033[1;36mRunning tests in ' . a:target . '\033[0m"'
    silent w
    exec "make " . a:target . " " . a:args
endfunction

function! ClassToFilename(class_name)
    let understored_class_name = substitute(a:class_name, '\(.\)\(\u\)', '\1_\U\2', 'g')
    let file_name = substitute(understored_class_name, '\(\u\)', '\L\1', 'g')
    return file_name
endfunction

function! ModuleTestPath()
    let file_path = @%
    let components = split(file_path, '/')
    let path_without_extension = substitute(file_path, '\.py$', '', '')
    let test_path = 'tests/unit/' . path_without_extension
    return test_path
endfunction

function! NameOfCurrentClass()
    let save_cursor = getpos(".")
    normal $<cr>
    call PythonDec('class', -1)
    let line = getline('.')
    call setpos('.', save_cursor)
    let match_result = matchlist(line, ' *class \+\(\w\+\)')
    let class_name = ClassToFilename(match_result[1])
    return class_name
endfunction

function! TestFileForCurrentClass()
    let class_name = NameOfCurrentClass()
    let test_file_name = ModuleTestPath() . '/test_' . class_name . '.py'
    return test_file_name
endfunction

function! TestModuleForCurrentFile()
    let test_path = ModuleTestPath()
    let test_module = substitute(test_path, '/', '.', 'g')
    return test_module
endfunction

function! RunTestsForFile(args)
    if @% =~ 'test_'
        call RunTests('%', a:args)
    else
        let test_file_name = TestModuleForCurrentFile()
        call RunTests(test_file_name, a:args)
    endif
endfunction

function! RunAllTests(args)
    silent ! echo
    silent ! echo -e "\033[1;36mRunning all unit tests\033[0m"
    silent w
    let avatarpath=substitute(getcwd(), $HOME . '/svn', '/mnt/hgfs', '')
    exec "set makeprg=ssh\\ avatar\\ 'cd\\ " . avatarpath . "\\ &&\\ sudo\\ python\\ setup.py\\ -q\\ nosetests\\ --config=/dev/null\\ --machine-out'"
    set errorformat=%f:%l:\ In\ %.%#:\ fail:\ %m
    exec "make!" . a:args
endfunction

function! JumpToError()
    if getqflist() != []
        for error in getqflist()
            if error['valid']
                break
            endif
        endfor
        let error_message = substitute(error['text'], '^ *', '', 'g')
        silent cc!
        exec ":sbuffer " . error['bufnr']
        call RedBar()
        echo error_message
    else
        call GreenBar()
        echo "All tests passed"
    endif
endfunction

function! RedBar()
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

function! GreenBar()
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

function! JumpToTestsForClass()
    exec 'e ' . TestFileForCurrentClass()
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09. Plugins                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09a. FuzzyFinder                                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trying CommandT in place of this plugin.
"let g:fuzzy_ignore="*.pyc;*/rel/*;*/branches/*;*/tags/*;*/build/*"
"let g:fuzzy_ceiling=50000
"let g:fuzzy_matching_limit=30
"map ,t :FuzzyFinderTextMate<CR>
"map ,b :FuzzyFinderBuffer<CR>
"map ,m :FuzzyFinderMruFile<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09b. Tagbar                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
"let g:ctags_statusline=1          " Display function name in status bar
"let generate_tags=1               " Automatically start script
"let Tlist_Use_Horiz_Window=0      " Display tag results in vertical window
"nnoremap TT :TlistToggle<CR>
""let Tlist_Use_Right_Window=1
"let Tlist_Compact_Format=1
"let Tlist_Exit_OnlyWindow=1
"let Tlist_GainFocus_On_ToggleOpen=1
"let Tlist_File_Fold_Auto_Close=1
"let Tlist_WinWidth=40
nnoremap TT :TagbarToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09c. CommandT                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map ,t :CommandT<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09d. Sparkup                                                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:sparkupNextMapping='<c-x>'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09e. SnipMate                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable($HOME."/.vim/snippets/support_functions.vim")
    exec "source " . $HOME . "/.vim/snippets/support_functions.vim"
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09f. Syntastic                                                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
    SyntasticEnable javascript
    let g:syntastic_enable_signs=1
    let g:syntastic_auto_jump=1
    let g:syntastic_auto_loc_list=1
endif
