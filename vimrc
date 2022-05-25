if !1 | finish | endif

" vim8 packages doesn't like being pointed to ~/.vim, which is a symlink
set packpath+=~/.dotfiles/vim

filetype off

if has('vim_starting')
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.dotfiles/vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.dotfiles/vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/unite.vim'

NeoBundle 'lifepillar/vim-solarized8'

NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}

NeoBundle 'bling/vim-airline'
NeoBundle 'bling/vim-bufferline'

NeoBundle 'fatih/vim-go'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'vim-scripts/nginx.vim'
NeoBundle 'vim-scripts/VimClojure'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'ekalinin/Dockerfile.vim'

NeoBundle 'Glench/Vim-Jinja2-Syntax'
NeoBundle 'saltstack/salt-vim'
NeoBundle 'martinda/Jenkinsfile-vim-syntax'

call neobundle#end()

filetype plugin indent on

" NeoBundleCheck

set nocompatible
set modelines=5

syntax on
set background=dark
set termguicolors
colorscheme solarized8

set ts=2 sw=2 sts=2 et ai vb
set bs=indent,eol,start
set enc=utf-8
set hidden
set wildmenu wildmode=list:longest
set ruler
set laststatus=2
"set relativenumber
"set undofile
set re=0

" A better leader character.
let mapleader=","

" Hmm... this be broken.
"nnoremap / /\v
"vnoremap / /\v

" ic: ignore case in search patterns
" sc: show partial commands and visual selection info
set ic sc

" is: incremental search; search as you type
" hls: highlight search terms
" sm: show matching brackets, braces, and parens
"set incsearch hlsearch showmatch
set is hls sm

" gd: global flag defaults to on for substitution operations
set gdefault

" Unhighlight search results with <leader><space>.
nnoremap <leader><space> :noh<cr>

nnoremap <tab> %
vnoremap <tab> %

" Prevents me from making long lines of code.
set colorcolumn=120

" Character markers. Noisy, but you can turn it on.
"set list listchars=tab:▸\ ,eol:¬

" I like not having to hold SHIFT for command prefixes.
nnoremap ; :

" Who uses F1? No one, that's who. Map it to ESC in case we hit the wrong
" button.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap <leader>l :ls<cr>
nnoremap <leader>j gqip
nnoremap <leader>s <C-w>v<C-w>l
nnoremap <leader>a :wa<cr>
nnoremap <leader>q :qa<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>m :!make<cr>
nnoremap <leader>t :wa <bar> :!clear && rake test <cr>
nnoremap <leader>f zR
nnoremap <leader>n :set number!<cr>
nnoremap <leader>0 :set relativenumber!<cr>
nnoremap <leader>c :w !pbcopy<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

xnoremap . :normal .<CR>

augroup vimrc
    au BufReadPre * setlocal foldmethod=indent
    au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=2

let g:vim_markdown_folding_disabled=1

let g:airline_powerline_fonts = 1

nnoremap <F3> "=strftime("%FT%T%z")<CR>P
inoremap <F3> <C-R>=strftime("%FT%T%z")<CR>

function! LastModified()
    if &modified
        let save_cursor = getpos(".")
        let n = min([20, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}last-modified: \).*#\1' . strftime('%FT%T%z') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun
autocmd BufWritePre * call LastModified()

au FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2 shiftwidth=2

set directory=~/.dotfiles/vim/swappage//

