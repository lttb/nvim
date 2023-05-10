local utils = require('lttb.utils')

local function config()
  -- local git_blame = require('gitblame')
  local theme = require('lttb.theme')

  require('lualine').setup({

    options = {
      icons_enabled = true,
      theme = 'auto',
      -- component_separators = '|',
      -- section_separators = '',

      disabled_filetypes = { 'NvimTree', 'neo-tree' },
    },

    -- sections = {
    --   -- lualine_c = {
    --   --   {
    --   --     'filename',
    --   --     newfile_status = true,
    --   --     path = 1,
    --   --   },
    --   --   -- {
    --   --   --   git_blame.get_current_blame_text,
    --   --   --   cond = git_blame.is_blame_text_available,
    --   --   -- },
    --   -- },
    -- },
  })
end

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvim-lualine/lualine.nvim',
    config = config,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'arkav/lualine-lsp-progress' },
    },
  },
}
