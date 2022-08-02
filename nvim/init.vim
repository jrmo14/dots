set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin()

" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'
" Pretty
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/goyo.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/gruvbox-material'
Plug 'ryanoasis/vim-devicons'

" Plugs for languages
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'timmyjose-projects/lox.vim'
Plug 'ziglang/zig.vim'
Plug 'ARM9/arm-syntax-vim'

" General tools
Plug 'majutsushi/tagbar'
Plug 'dkarter/bullets.vim'
Plug 'lvht/tagbar-markdown'
" Plug 'scrooloose/nerdtree'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'tpope/vim-commentary'
" Spacing and formatting
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/seoul256.vim'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'

call plug#end()

filetype plugin indent on
lua require('usermod.settings')
lua require('usermod.autocommands')
lua require('usermod.keymap')


lua require'nvim-tree'.setup {}

" Tagbar rust support
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

let g:tagbar_type_zig = {
    \ 'ctagstype': 'zig',
    \ 'kinds' : [
      \ 'f:functions',
      \ 's:structs',
      \ 'e:enums',
      \ 'u:unions',
      \ 'E:errors'
    \ ]
    \ }

let g:tagbar_type_arm = {
    \ 'ctagsbin'  : '/usr/local/bin/ctags',
    \ 'ctagstype' : 'Asm',
    \ 'ctagsargs' : '-f- --format=2 --excmd=pattern --fields=nksSa --extra= --sort=no --language-force=asm',
    \ 'kinds' : [
        \ 'l:labels:0:1',
        \ 'm:macros:1:0',
        \ 't:types:1:0',
        \ 'd:defines:1:0'
    \ ],
    \ 'sro': '::'
\}

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
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

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
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


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

" VimTex config
let g:tex_flavor = "latex"
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
let g:tex_conceal = ""
let g:conceallevel = 0
" Pretty colors
let g:airline_theme = 'base16_nord'
"colorscheme seoul256-light
colorscheme nord
let g:nord_italic=1
let g:nord_underline=1
let g:nord_italic_comments=1

hi Folded ctermbg=black
hi Visual cterm=reverse ctermbg=NONE
hi CocMenuSel cterm=reverse ctermfg=2 ctermbg=0
