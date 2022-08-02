local set = vim.opt

set.hidden = true
vim.o.shortmess = vim.o.shortmess .. "c"
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.smarttab = true
set.number = true

set.linebreak = true
set.autoindent = true

set.clipboard = "unnamedplus"
set.cino = "N-s"

set.autowrite = true

set.splitbelow = true
set.splitright = true

set.foldmethod = "syntax"
set.foldnestmax = 10
set.foldlevelstart = 99

set.background="dark"
set.mouse="a"

set.exrc = true
set.secure = true

vim.g.airline_powerline_fonts = 1
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#tab_nr_type"] = 1
vim.g["airline#extensions#tabline#formatter"] = "unique_tail"


