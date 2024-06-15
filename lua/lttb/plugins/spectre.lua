local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'windwp/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      live_update = true,
      is_insert_mode = true,
    },
    keys = function()
      local spectre = require('spectre')

      return {
        { '<leader>rr', spectre.open, {
          desc = 'spectre',
        } },
        { '<leader>rf', spectre.open_file_search, {
          desc = 'spectre: search in file',
        } },
      }
    end,
  },
}
