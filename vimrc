if !1 | finish | endif

filetype off

if has('vim_starting')
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/unite.vim'

NeoBundle 'altercation/vim-colors-solarized'

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'vim-scripts/bufexplorer.zip'
NeoBundle 'vim-scripts/mru.vim'

"NeoBundle 'Lokaltog/vim-easymotion', '09c0cea8'
"NeoBundle 'sophacles/vim-bundle-mako'

NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}

NeoBundle 'L9'

NeoBundle 'FuzzyFinder'

"NeoBundle 'rails.vim'

NeoBundle 'git://git.wincent.com/command-t.git'

NeoBundle 'bling/vim-airline'
NeoBundle 'bling/vim-bufferline'

NeoBundle 'groenewege/vim-less'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'vim-scripts/nginx.vim'
NeoBundle 'vim-scripts/VimClojure'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'jnwhiteh/vim-golang'
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'elzr/vim-json'
NeoBundle 'ekalinin/Dockerfile.vim'

call neobundle#end()

filetype plugin indent on

" NeoBundleCheck

set nocompatible
set modelines=5

syntax on
set background=dark
colorscheme solarized

set ts=4 sw=4 sts=4 et ai vb
set bs=indent,eol,start
set enc=utf-8
set hidden
set wildmenu wildmode=list:longest
set ruler
set laststatus=2
"set relativenumber
"set undofile

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

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

au syntax mason so /usr/share/vim/vim73/syntax/mason.vim
au BufNewFile,BufRead *.html set ft=mason
au BufNewFile,BufRead autohandler set ft=mason
au BufNewFile,BufRead dhandler set ft=mason
au BufNewFile,BufRead Thorfile set ft=ruby

"autocmd vimenter * NERDTree
"autocmd vimenter * if !argc() | NERDTree | endif

let g:ackprg="ack-grep -H --nocolor --nogroup --column"
let g:vim_markdown_folding_disabled=1

let g:airline_powerline_fonts = 1
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'

if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

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

au BufNewFile,BufRead *.tt call s:AdjustTT2Type()
func! s:AdjustTT2Type()
    if ( getline(1) . getline(2) . getline(3) =~ '<\chtml' && getline(1) . getline(2) . getline(3) !~ '<[%?]' ) || getline(1) =~ '<!DOCTYPE HTML'
        setf tt2html
    else
        setf tt2
    endif
endfunc

au BufNewFile,BufRead *.confluence setf confluence
au FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2 shiftwidth=2

