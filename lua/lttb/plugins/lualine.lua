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
      theme = theme.colorscheme == 'zengithub' and require('lttb.themes.zengithub_lualine') or 'auto',

      component_separators = '|',
      section_separators = '',

      -- component_separators = '|',
      -- section_separators = '',

      disabled_filetypes = { 'NvimTree', 'neo-tree' },
    },

    sections = {
      lualine_a = { { 'mode' } },
      lualine_b = {},
      lualine_c = {
        {
          function()
            return require('lsp-progress').progress({
              --- @param client_messages string[]|table[]
              ---     Client messages array.
              --- @return string
              ---     The returned value will be returned as the result of `progress` API.
              format = function(client_messages)
                local sign = '' -- nf-fa-gear \uf013
                if #client_messages > 0 then
                  return sign .. ' ' .. table.concat(client_messages, ' ')
                end

                local clients = (vim.lsp and vim.lsp.get_clients and vim.lsp.get_clients()) or nil
                if clients ~= nil and #clients > 0 then
                  return sign
                end
                return ''
              end,
            })
          end,
          color = 'GitSignsCurrentLineBlame',
        },
      },
      lualine_x = {},
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

  vim.schedule(function()
    local color = require('lttb.utils.color')
    local function patch(mode)
      local hl = 'lualine_a_' .. mode
      color.extend_hl(
        hl,
        { bg = 'NONE', fg = color.alpha_hl(hl, 'bg', 1, color.get_hl('Normal', 'fg')), default = false }
      )
    end

    patch('normal')
    patch('visual')
    patch('insert')
    patch('command')
  end)

  -- listen lsp-progress event and refresh lualine
  vim.api.nvim_create_augroup('lualine_augroup', { clear = true })
  vim.api.nvim_create_autocmd('User', {
    group = 'lualine_augroup',
    pattern = 'LspProgressStatusUpdated',
    callback = require('lualine').refresh,
  })
end

return {
  {
    'nvim-lualine/lualine.nvim',
    config = config,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'arkav/lualine-lsp-progress', enabled = false },
      {
        'linrongbin16/lsp-progress.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
      },
    },
  },
}
