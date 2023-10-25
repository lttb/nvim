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
      theme = 'auto',

      component_separators = '|',
      section_separators = utils.is_neovide() and {} or { left = '', right = '' },

      -- component_separators = '|',
      -- section_separators = '',

      disabled_filetypes = { 'NvimTree', 'neo-tree' },
    },

    sections = {
      lualine_a = {
        { 'mode', right_padding = 2 },
      },
      lualine_b = { 'filename', 'branch', 'diff', 'diagnostics' },
      lualine_c = {},
      lualine_x = {},
      lualine_y = { 'filetype', 'progress' },
      lualine_z = {
        { 'location', left_padding = 2 },
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
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'arkav/lualine-lsp-progress' },
    },
  },
}
