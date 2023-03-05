local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

function config()
  require('neo-tree').setup({
    window = {
      width = 50,
    },

    filesystem = {
      follow_current_file = true,
      group_empty_dirs = true,
    },
  })

  utils.keyplug('lttb-sidebar-toggle', function()
    vim.cmd('NeoTreeShow')
  end)

  utils.keyplug('lttb-sidebar-focus', function()
    vim.cmd('NeoTreeReveal')
  end)

  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    callback = function(data)
      if not utils.should_open_sidebar(data) then
        return
      end

      -- open the tree but don't focus it
      vim.cmd('NeoTreeShow')
    end,
  })
end

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = config,
  },
}
