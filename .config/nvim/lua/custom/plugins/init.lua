-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

require 'robertnopickle'

return {
  'mbbill/undotree',
  'christoomey/vim-tmux-navigator',
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          accept_word = '<C-j>',
          accept_line = '<C-k>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-h>',
        },
      },
      panel = { enabled = true },
      nes = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        ['*'] = true,
      },
    },
  },
}
