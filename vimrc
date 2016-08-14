set nocompatible

let mapleader = " "
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup      " no backup files
set nowritebackup
set noswapfile

" auto writing
set autowrite     " write when leaving buffer
set autowriteall  " write when leaving buffer (always)
autocmd FocusLost * :wa " write on loss of focus
autocmd BufLeave,FocusLost * silent! wall


" set tab width
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab

" Numbers
set number
set numberwidth=5

" http://stackoverflow.com/questions/16902317/vim-slow-with-ruby-syntax-highlighting
set re=1

call plug#begin('~/.vim/bundle')
Plug 'tpope/vim-vividchalk'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'kchmck/vim-coffee-script'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
call plug#end()

colorscheme vividchalk

set hlsearch
hi Search cterm=NONE ctermfg=black ctermbg=yellow


" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Macros
let @b = 'Obinding.pry'


" File explorer
let g:netrw_liststyle=3
map <leader>k :Explore<cr>

" NERDTree
map <leader>[ :NERDTreeToggle<CR>
map <leader>{ :NERDTreeFind<CR>

" Toggle pastemode
map <leader>p :set paste!<CR>
