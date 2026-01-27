-- My very own remapp'ns
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = '[P]roject [V]iew' })

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndotree' })

-- Tmux
vim.keymap.set('n', '<C-h', function()
  return { '<cmd> TmuxNavigateLeft<CR>', 'window left' }
end)
vim.keymap.set('n', '<C-l', function()
  return { '<cmd> TmuxNavigateRight<CR>', 'window right' }
end)
vim.keymap.set('n', '<C-j', function()
  return { '<cmd> TmuxNavigateDown<CR>', 'window down' }
end)
vim.keymap.set('n', '<C-k', function()
  return { '<cmd> TmuxNavigateUp<CR>', 'window up' }
end)

-- Copy current path and line to clipboard
vim.opt.clipboard:append('unnamedplus')
vim.keymap.set('n', '<leader>cpl', function()
  local file_info = vim.fn.expand('%') .. ':' .. vim.fn.line('.')
  vim.fn.setreg('+', file_info)
  print('Path and line copied: ' .. file_info)
end, { noremap = true, silent = true, desc = '[C]opy current [P]ath and [L]ine' })

