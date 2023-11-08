local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  -- local git_blame = require('gitblame')
  local theme = require('lttb.theme')

  require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = require('lttb.themes.zengithub_lualine'),

      component_separators = '|',
      section_separators = '',

      -- component_separators = '|',
      -- section_separators = '',

      disabled_filetypes = { 'NvimTree', 'neo-tree' },
    },

    sections = {
      lualine_a = { { 'mode' } },
      lualine_b = { { color = 'CursorLine' } },
      lualine_c = { { color = 'CursorLine' } },
      lualine_x = { { color = 'CursorLine' } },
      lualine_y = { 'branch', 'diff', 'diagnostics', 'filetype', 'progress' },
      lualine_z = {
        {
          'location',
        },
      },
    },
    inactive_sections = {
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    -- tabline = {},
    -- extensions = {},

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

return {
  {
    'nvim-lualine/lualine.nvim',
    config = config,
    dependencies = { { 'nvim-tree/nvim-web-devicons' }, { 'arkav/lualine-lsp-progress' } },
  },
}
