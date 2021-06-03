set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.vim/pluged')

" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'

" Pretty
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'flazz/vim-colorschemes'
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/gruvbox-material'
Plug 'ryanoasis/vim-devicons'

" Plugs for languages
"Plug 'ycm-core/YouCompleteMe'
"Plug 'rdnetto/YCM-Generator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'majutsushi/tagbar'

" Spacing and formatting
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'

" Git
Plug 'airblade/vim-gitgutter'

call plug#end()

filetype plugin indent on
set hidden
set nobackup
set nowritebackup
set shortmess+=c
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set number
set linebreak
set autoindent
syntax enable
" Use system clipboard
set clipboard=unnamedplus

" Sane namespace convention
set cino=N-s


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

" Tagbar
nnoremap <F8> :TagbarToggle<CR>
" Tagbar rust support
let g:rust_use_custom_ctags_defs = 1  " if using rust.vim
let g:tagbar_type_rust = {
  \ 'ctagsbin' : '/usr/local/bin/ctags',
  \ 'ctagstype' : 'rust',
  \ 'kinds' : [
      \ 'n:modules',
      \ 's:structures:1',
      \ 'i:interfaces',
      \ 'c:implementations',
      \ 'f:functions:1',
      \ 'g:enumerations:1',
      \ 't:type aliases:1:0',
      \ 'v:constants:1:0',
      \ 'M:macros:1',
      \ 'm:fields:1:0',
      \ 'e:enum variants:1:0',
      \ 'P:methods:1',
  \ ],
  \ 'sro': '::',
  \ 'kind2scope' : {
      \ 'n': 'module',
      \ 's': 'struct',
      \ 'i': 'interface',
      \ 'c': 'implementation',
      \ 'f': 'function',
      \ 'g': 'enum',
      \ 't': 'typedef',
      \ 'v': 'variable',
      \ 'M': 'macro',
      \ 'm': 'field',
      \ 'e': 'enumerator',
      \ 'P': 'method',
  \ },
\ }

" Remove whitespace on save
function! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" CoC config
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')


" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

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
noremap <F2> :exec winheight(0)/5."split" \| :set nonumber \| :terminal<CR> a

noremap <F3> :CocAction <CR>

" Fix tabs with a keybind
noremap <F4> mzgg=G`z
autocmd Filetype c,cpp nnoremap <buffer> <F4> :!clang-format -i *.c *.h<CR>
autocmd Filetype rust nnoremap <buffer> <F4> :!cargo fmt<CR>

" Allow per project config
set exrc
set secure

" Markdown and text spell check
autocmd BufRead,BufWritePre *.md,*.txt setlocal spell
autocmd BufRead,BufWritePre *.md, setlocal tabstop=4
set spellfile=~/.vim/spell/en.utf-8.add

" Meson syntax
autocmd BufNewFile,BufRead meson.build setlocal syntax=meson


" Treat .rasi as css
au BufNewFile,BufRead /*.rasi setf css

" VimTex config
let g:tex_flavor = "latex"
let g:vimtex_view_method = 'zathura'

" Pretty colors
let g:airline_theme = 'base16_nord'
"colorscheme 0x7A69_dark
colorscheme nord
let g:nord_italic=1
let g:nord_underline=1
let g:nord_italic_comments=1
"let g:nord_comment_brightness=15


" Open man pages
" Comes with vim already
runtime ftplugin/man.vim
