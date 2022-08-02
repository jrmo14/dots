local M = {}
local cmd = vim.cmd


function M.create_augroup(autocmds, name)
  cmd('augroup ' .. name)
  cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do
    cmd('autocmd ' .. table.concat(autocmd, ' '))
  end
  cmd('augroup END')
end

M.create_augroup(
{
  {'BufEnter,FocusGained,InsertLeave,WinEnter', '*', 'if &nu && mode() != "i" | set rnu   | endif'},
  {'BufLeave,FocusLost,InsertEnter,WinLeave', '*', 'if &nu | set nornu | endif'}
}, 'numbertoggle'
)

cmd('autocmd CursorHold * silent call CocAction(\'highlight\')')

M.create_augroup(
{
  {'Filetype', 'c,cpp,java', 'nnoremap <buffer> <F4> :!clang-format -i %<CR>'},
  {'Filetype', 'rust', 'nnoremap <buffer> <F4> :!cargo fmt<CR>'},
  {'Filetype', 'python', 'nnoremap <buffer> <F4> :!black -q %<CR>'},
  {'Filetype', 'zig','nnoremap <buffer> <F4> :!zig fmt %<CR>'},
}, 'formatbindings'
)

M.create_augroup(
{
  {"BufRead,BufWritePre", "*.md,*.txt", "setlocal spell"},
  {"BufRead,BufWritePre", "*.md", "setlocal tabstop=4"},
}, "markdownsettings"
)

cmd("autocmd BufNewFile,BufRead meson.build setlocal syntax=meson")
cmd("autocmd BufNewFile,BufRead *.rasi setf css")
