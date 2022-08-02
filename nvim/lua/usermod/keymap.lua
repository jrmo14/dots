local map = vim.api.nvim_set_keymap

options = {noremap = true}

-- Better split navigation
map('n', '<C-J>', '<C-W><C-J>', options)
map('n', '<C-K>', '<C-W><C-K>', options)
map('n', '<C-L>', '<C-W><C-L>', options)
map('n', '<C-H>', '<C-W><C-H>', options)

-- map('', '<C-n>', ':cnext<CR>', options)
-- map('', '<C-m>', ':cprevious<CR>', options)

map('n', '<Leader>a', ':cclose<CR>', options)
map('', '<Leader>cc', ':noh<CR>', options)

map('n', '<C-_>', ':Commentary<CR>', options)
map('x', '<C-_>', ':Commentary<CR>', options)

map('n', '<Leader>vr', ':source $MYVIMRC<CR>', options)

map('n', '<C-t>', ':NvimTreeToggle<CR>', options)

map('n', '<F8>', ':TagbarToggle<CR>', options)

-- Coc keymaps
map('n', '[g', '<plug>(coc-diagnostic-prev)', options)
map('n', ']g', '<plug>(coc-diagnostic-next)', options)
map('n', 'gd', '<plug>(coc-definition)', options)
map('n', 'gy', '<plug>(coc-type-definition)', options)
map('n', 'gi', '<plug>(coc-implementation)', options)
map('n', 'gr', '<plug>(coc-references)', options)
map('n', '<leader>rn', '<plug>(coc-rename)', options)
map('n', '<F3>', '<plug>(coc-codeaction-line)', options)
map('x', '<F3>', '<plug>(coc-codeaction-line)', options)

-- Indent anyfile that we don't have an autocmd format for
map('n', '<F4>', 'mmgz=G`z', options)

