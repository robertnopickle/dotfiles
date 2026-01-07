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
    requires = {
      'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
    },
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = true },
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
