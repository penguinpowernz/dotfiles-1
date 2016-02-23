set nocompatible               " be iMproved

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" My Plugins here:
"
" original repos on github
Plugin 'tpope/vim-fugitive.git'
Plugin 'tpope/vim-rails.git'
Plugin 'kien/ctrlp.vim.git'
Plugin 'tpope/vim-vividchalk.git'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree.git'
Plugin 'mileszs/ack.vim.git'
Plugin 'ervandew/supertab.git'
Plugin 'vim-scripts/vimwiki.git'
Plugin 'tpope/vim-surround.git'
Plugin 'tpope/vim-repeat.git'
" vim snippets
Plugin 'MarcWeber/vim-addon-mw-utils.git'
Plugin 'tomtom/tlib_vim.git'
Plugin 'honza/vim-snippets.git'
Plugin 'garbas/vim-snipmate.git'
Plugin 'tpope/vim-endwise.git'

Plugin 'scrooloose/nerdcommenter.git'
Plugin 'kchmck/vim-coffee-script.git'
Plugin 'godlygeek/tabular.git'
Plugin 'rking/ag.vim.git'
Plugin 'chrisbra/csv.vim.git'
Plugin 'mustache/vim-mode.git'
Plugin 'mwise/vim-rspec-focus.git'
Plugin 'fatih/vim-go.git'
Plugin 'airblade/vim-gitgutter.git'

call vundle#end()

colorscheme vividchalk

" linenumbers
set number
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" auto reading/writing
set autoread " auto read externally modified files
set autowrite " write when leaving buffer
set autowriteall " write when leaving buffer (always)
set nobackup " no backup files
autocmd FocusLost * :wa " write on loss of focus (gvim)
autocmd BufLeave,FocusLost * silent! wall

" disable swp - maybe I should just add .swp to global gitignore
set noswapfile

" fix backspace for MacVim
set backspace=indent,eol,start

" set tab width
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab

" NERDTree
map <leader>[ :NERDTreeToggle<CR>
map <leader>{ :NERDTreeFind<CR>

" Trim whitespace
nmap <leader>tw :%s/\s\+$//e

" Toggle pastemode
set pastetoggle=<leader>p

" disable arrow keys
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

" search highlight
set hlsearch 

" rspec tests
" run entire file
map <Leader>T :call RunCurrentTest()<CR>
" run single test
map <Leader>t :call RunCurrentLineInTest()<CR>

filetype off                   " required!
filetype plugin on             " required for vimwiki, maybe other things too

" syntax highlighting
syntax on
filetype plugin indent on     " required!

function! RunCurrentTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
    call SelectTestRunner()
  endif

  exec g:last_test_runner g:last_test_file
endfunction

function! RunCurrentLineInTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFileWithLine()
    call SelectTestRunner()
  end

  exec g:last_test_runner g:last_test_file . ":" . g:last_test_file_line
endfunction

function! SelectTestRunner()
  call SetZeus()
  if match(expand('%'), '\.feature$') != -1
    call SetTestRunner("!" . g:zeus . "cucumber")
  elseif match(expand('%'), '_spec\.rb$') != -1
    call SetTestRunner("!" . g:zeus . "rspec")
  else
    call SetTestRunner("!ruby -Itest")
  endif
endfunction

function! SetZeus()
  if findfile(".zeus.sock", ".;") == ".zeus.sock"
    let g:zeus="zeus "
  else
    let g:zeus=""
  endif
endfunction

function! SetTestRunner(runner)
  let g:last_test_runner=a:runner
endfunction

function! SetTestFile()
  let g:last_test_file=@%
endfunction

function! SetTestFileWithLine()
  let g:last_test_file=@%
  let g:last_test_file_line=line(".")
endfunction


" Cucumber table alignment
" https://gist.github.com/tpope/287147
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
 
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" Strip whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Easier split navigation
" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>                                                                                                                       
nmap <silent> <c-j> :wincmd j<CR>                                                                                                                       
nmap <silent> <c-h> :wincmd h<CR>                                                                                                                       
nmap <silent> <c-l> :wincmd l<CR> 

" Rspec errors in quickfix
" http://fweepcode.blogspot.co.nz/2013/03/faster-tdd-with-rspec-vim-and-quickfix.html
function! LoadAndDisplayRSpecQuickfix()
  let quickfix_filename = "./tmp/quickfix.out"
  if filereadable(quickfix_filename) && getfsize(quickfix_filename) != 0
    silent execute ":cfile " . quickfix_filename
    botright cwindow
    cc
  else
    redraw!
    echohl WarningMsg | echo "Quickfix file " . quickfix_filename . " is missing or empty." | echohl None
  endif
endfunction
noremap <Leader>q :call LoadAndDisplayRSpecQuickfix()<CR>

" Macros
let @b = 'Obinding.pry'

" vim-rspec-focus
:nnoremap <leader>ff :ToggleFocusTag<CR>
:nnoremap <leader>fa :AddFocusTag<CR>
:nnoremap <leader>fr :RemoveFocusTag<CR>
:nnoremap <leader>fd :ToggleDescribeFocusTag<CR>
:nnoremap <leader>fc :ToggleContextFocusTag<CR>
:nnoremap <leader>fi :ToggleItFocusTag<CR>
:nnoremap <leader>rf :RemoveAllFocusTags<CR>
