"======================================================
"Vim configuration file
"Author: Huang Zhiqiang
"~/.vimrc
"Latees change: 2009.06.03
"==============
"Setings
"=============
set nocompatible
set history=400
set ruler
set showcmd
set number
set hlsearch
set incsearch
set expandtab
set noerrorbells
set novisualbell
set t_vb= "close visual bell
set tabstop=4
set shiftwidth=4
set nobackup
set nowritebackup
set smarttab
set smartindent
set autoindent
set cindent
set wrap
set wildmenu
set autoread
set cmdheight=3
set showtabline=2
set tabpagemax=20
set laststatus=2
set noswapfile
set cursorline
set statusline=\ [File]\ %F%m%r%h\ %w\ \ %h\ \%=[Line]\ %l,%c\ %=\ %P
set whichwrap=b,s,<,>,[,],h,l "Allow move the cursor left/right to move to the previous/next line
set term=xterm
set listchars=tab:>-,trail:_
set list
set encoding=utf-8
set scrolloff=5
set cursorline
:colors darkblue

"===============
"Mappings
"===============
:map <F5> :tabp<CR>
:map <F6> :tabn<CR>
:imap <F5> <ESC>:tabp<CR>i
:imap <F6> <ESC>:tabn<CR>i
function! CurrectDir()
    let curdir = substitute(getcwd(), "", "", "g")
    return curdir
endfunction

syntax on
syntax match Trail " +$"
highlight def link Trail Todo
