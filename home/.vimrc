set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Pretty
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'dylanaraps/wal.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'philj56/vim-asm-indent'

" Useful autoloads
Plugin 'xolox/vim-misc'

" Plugins for languages
Plugin 'davidhalter/jedi-vim'
Plugin 'valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
Plugin 'udalov/kotlin-vim'
Plugin 'lervag/vimtex'
Plugin 'dart-lang/dart-vim-plugin'

" Spacing and formatting
Plugin 'Raimondi/delimitMate'
Plugin 'Yggdroot/indentLine'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set number
set linebreak
set autoindent
syntax enable

" Sane namespace convention
set cino=N-s

" Pretty colors
let g:airline_theme = 'base16_nord'
colorscheme 0x7A69_dark
let g:nord_italic=1
let g:nord_underline=1
let g:nord_italic_comments=1
let g:nord_comment_brightness=15
" set termguicolors

" Easier splits navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" More  mapings
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <Leader>a :cclose<CR>
" Clear matche
noremap <Leader>cc :noh<CR>

" Automatically saves the file when make is called
set autowrite

" More logical splits
set splitbelow
set splitright

" Reload vimrc
nnoremap <Leader>vr :source $MYVIMRC<CR>

" Enable autofunction folding
set foldmethod=syntax
set foldnestmax=10
highlight Folded ctermbg=black
" Open folds at start
set foldlevelstart=99


" NERDTree setup
let NERDTreeShowHidden=1
nnoremap <C-t> :NERDTreeToggle <CR>
let NERDTreeIgnore=['\.pyc$', '\.swp$', '\.classpath$', '\.project$', '\.git$']


" CUDA support -- not great
"au BufNewFile,BufRead *.cu set ft=cuda
au BufNewFile,BufRead *.cuh set ft=cuda

" Remove whitespace on save
function! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" YCM config
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/.ycm_extra_conf.py'
nnoremap <silent> <C-B> :vsp \| YcmCompleter GoToDefinition<CR>
let g:ycm_rust_source_path = '~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
let g:syntastic_java_checkers=[]
let g:EclimFileTypeValidate=0
let g:ycm_goto_buffer_command='split'
nnoremap <C-g> :rightbelow vertical YcmCompleter GoTo<CR>

" Dark background
set background=dark
" Flip the background and foreground colors on highlight
highlight Visual cterm=reverse ctermbg=NONE

" Enable mouse scroll and select
set mouse=a

" Config airline/tabline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
"let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter='unique_tail'


" Variable replace local and global
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" FUNCTION KEY MAPINGS
noremap <F2> :tabe \| :tabm \| :terminal<CR> a
noremap <F3> :YcmCompleter FixIt<CR>
" Fix tabs with a keybind
noremap <F4> mzgg=G`z

" Allow per project config
set exrc
set secure

" Markdown and text spell check
autocmd BufRead,BufWritePre *.md,*.txt setlocal spell
autocmd BufRead,BufWritePre *.md, setlocal tabstop=4
set spellfile=~/.vim/spell/en.utf-8.add

" Treat .rasi as css
au BufNewFile,BufRead /*.rasi setf css

" Vimwiki config
let g:vimwiki_list = [{'path': '~/Documents/notes', 'path_html': '~/Documents/export/html'}]
