runtime macros/matchit.vim
set textwidth=0 wrapmargin=0 showmode
set backspace=start,indent

let mapleader = " "
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>g :source /home/kjr/.gvimrc<cr>

cnoreabbrev Vrc $MYVIMRC
cnoreabbrev Zrc ~/.zshrc
cnoreabbrev Grc ~/.gvimrc

cnoreabbrev rm rm -vi 
cnoreabbrev mv mv -vi 
cnoreabbrev cp cp -vi 

set foldmethod=indent
set nofoldenable

" zsh style completion (with automenu and autolist enabled)
set wildmode=longest:list,full

set ruler
set modeline secure
set showmatch
set showcmd 
" always show the status line
set laststatus=2
set hlsearch incsearch

" Force at least N lines above and below the cursor, except at the top/bottom
" of the file:
set scrolloff=3

" Some smart search options.  ignorecase+smartcase ignores case unless there
" are uppercase letters in the search.  Incsearch shows the first match as
" you're typing the search:
set ignorecase smartcase incsearch
set history=9000
set viminfo='50,\"500,%
set backspace+=indent,eol,start

"set up for various coding filetypes
filetype indent plugin on
"syntax highlighting:
syntax on

"toggle hlsearch on/off with F7
:noremap <F7> :set hlsearch!<cr>
"map Ctrl-k to tell myself to run the current script on a command line
map <C-k> :!echo please run this script on the command line so you do not have waiting/editing issues.<c-m>
  "map <C-k> :!%:p<C-m>
"mappings for easy saving of files: (nicer with :set backspace=start)
inoremap <C-s> <C-o>:w<C-m>
noremap <C-s> :w<C-m>
"nice navigation for text files with long lines:
map <M-m>  :map j gj<C-m>:map k gk<C-m>:set linebreak<C-m>:set backspace=start,indent,eol<C-m>
map <ESC>m :map j gj<C-m>:map k gk<C-m>:set linebreak<C-m>:set backspace=start,indent,eol<C-m>
" Copy the current file name/path to the clipboard (while at CHG)
noremap <silent> <F4> :let @+=expand("%:p")<CR>

"Definitions for editing files in C++
"be able to jump from class method definitions to the prototypes (if in the same file) and back...  Foo::Bar(int &bla) jumps to Bar(int &bla)
noremap <C-k><C-k><C-k> /^}<c-m>[[?::<c-m>^f:B"yyt:f:llvf(e"xy?^class <C-r>y<C-m>zt/<C-r>x<C-m>
"noremap <C-j><C-j><C-j> ^w"zyt(?^class<C-m>w"xye/<C-r>x.*::.*<C-r>z\><C-m>zz
noremap <C-j><C-j><C-j> ^f(B"zyt(?^class<C-m>w"xye/<C-r>x.*::[^(]*<C-r>z\><C-m>zz
"be able to define a function from a prototype...  will mess things up if the class is not defined or a class method is not already declared.
"noremap <C-j><C-j><C-d> ^"yyt;?^class<C-m>wve"xyG?^\<\w.*\s*.<C-r>x::<C-m>/^}<C-m>o<c-m><c-r>y<esc>\|f(Bi<c-r>x::<esc>$o{<c-m>}<esc>O//code goes here...<esc>
noremap <C-j><C-j><C-d> ^"yyt;?^class<C-m>wve"xyG?^\(\<\w.*\s*.\)\{0,1\}<C-r>x::<C-m>/^}<C-m>o<c-m><c-r>y<esc>\|f(Bi<c-r>x::<esc>$o{<c-m>}<esc>O//code goes here...<esc>
"case statements automatically include a break statement:
"iab case case 2:
" break;k$hh2s


"tabs = 3 or 4 spaces.
map <M-3> :set softtabstop=3 tabstop=3 expandtab shiftwidth=3<C-m>
map <M-4> :set softtabstop=4 tabstop=4 expandtab shiftwidth=4<C-m>

"create mapping for C-w,C-w to change windows and maximize.
map <M-m>w :noremap <C-v><C-w><C-v><C-w> <C-v><C-w><C-v><C-w><C-v><C-w>_<C-m>

" F3 toggles background=light/dark
map <silent> #3 :let &background = (&background == 'dark' ? 'light' : 'dark')<CR>
imap <silent> #3 <C-o>:let &background = (&background == 'dark' ? 'light' : 'dark')<CR>

" Function key 2 toggles internal spell checking:
map <silent> #2 :setlocal invspell<CR>
imap <silent> #2 <C-o>:setlocal invspell<CR>

"augroup myautos
" autocmd!
"augroup END
"

:iabbrev Ypath <c-r>=expand('%:p')<cr>

function! Ktabs(tabsize)
	execute "set softtabstop=" . a:tabsize . " tabstop=" . a:tabsize . " expandtab shiftwidth=" . a:tabsize
	"set softtabstop=a:tabsize tabstop=a:tabsize expandtab shiftwidth=a:tabsize
endfunction
noremap <leader><Tab> :call Ktabs(3)<Left>
noremap <leader>k :call Ktabs(3)<Left>

":echo expand('%:p')
function! CompileSass()
  chdir %:p:h
  let newFile = join([expand('%:t'), '.css'], "")
  if newFile =~ ".scss.css$" 
    write
    execute "!sass " . expand('%:t') . " " .  newFile
    let @+ = join(readfile(newFile), "\n")
    echo "Compiled sass file to " . newFile . " and then copied it to the system clipboard!"
  else
    echo "This is not a sass file--I cannot compile it."
    echo "Aborting"
  endif
endfunction
noremap <leader>c :call CompileSass()
noremap <leader><leader> :map<C-m>

if has('win32') 
  set dir^=~/vim-swap//

  " code in this if block is based on code from https://groups.google.com/forum/#!msg/vim_use/1ZrWkBj6DKI/uWa3Kvq5PXwJ
  " set noswapfile 
  " "autocmd BufReadPre,BufNewFile O:/* set directory=~/vim-swap " doesn't work alone
  " autocmd BufReadPre * setlocal noswapfile 
  " autocmd BufEnter {O,Z}:{/,\\}* set dir-=. dir+=. dir^=~/vim-swap//
  " " nested autocmd to enable swap files so SwapExists autocmds fire, too 
  " autocmd BufEnter * nested setlocal swapfile 
  " autocmd BufLeave {O,Z}:{/,\\}* set dir-=. dir^=. dir-=~/vim-swap//
endif 

" augroup optio
" 	augroup! optio
" 	autocmd BufReadPre,BufNewFile O:/*OPTIO*	setlocal readonly nomodifiable
" 	autocmd! BufReadPre,BufNewFile O:/*OPTIO*/dev*	setlocal noreadonly modifiable
" 	autocmd! BufReadPre,BufNewFile O:/*OPTIO*/*.txt	setlocal readonly modifiable
" 	autocmd BufReadPre,BufNewFile O:/*OPTIO*/*.{dcl|fun|seg|fmt|dcl|dev|sql|chn}	setlocal smartindent ts=3 sts=3 sw=3 et nu
" augroup END

:noremap <C-Ins> :tabnew<C-m>
:noremap <C-S-Ins> :tabnew<C-m>

" from http://vim.wikia.com/wiki/Maximize_or_set_initial_window_size ...
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  au GUIEnter * simalt ~x
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=100
  endif
endif
"au GUIEnter * simalt ~x "maximizes the window on create.

colorscheme darkblue
