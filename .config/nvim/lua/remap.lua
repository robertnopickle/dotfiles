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
