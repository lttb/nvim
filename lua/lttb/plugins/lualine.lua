local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  -- local git_blame = require('gitblame')

  require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = 'auto',
      -- theme = require('lualine.themes.zengithub'),

      component_separators = '|',
      section_separators = '',

      -- component_separators = '|',
      -- section_separators = '',

      disabled_filetypes = { 'NvimTree', 'neo-tree', 'oil' },
    },

    sections = {
      lualine_a = { { 'mode', separator = { left = utils.is_neovide() and '' or '' } } },
      lualine_b = {},
      lualine_c = {
        {
          function()
            local progress = vim.ui.progress_status()
            if progress ~= '' then
              return ' ' .. progress
            end
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients > 0 then
              return ''
            end
            return ''
          end,
        },
      },
      lualine_x = {},
      lualine_y = {
        'branch',
        { 'filename', path = 4, symbols = { unnamed = '' } },
        'diff',
        'diagnostics',
        'filetype',
        'progress',
      },
      lualine_z = {
        {
          'location',
          separator = { right = utils.is_neovide() and '' or '' },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
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

  vim.schedule(function()
    local color = require('lttb.utils.color')
    local function patch(mode)
      local hl = 'lualine_a_' .. mode
      color.extend_hl(
        hl,
        { bg = 'NONE', fg = color.alpha_hl(hl, 'bg', 1, color.get_hl('Normal', 'fg')), default = false }
      )
    end

    -- patch('normal')
    -- patch('visual')
    -- patch('insert')
    -- patch('command')
  end)

  vim.api.nvim_create_autocmd('LspProgress', {
    callback = function()
      require('lualine').refresh()
    end,
  })
end

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'LazyFile',
    config = config,
  },
}
