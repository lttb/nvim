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
            local color = require('lttb.utils.color')

            color.inherit_hl('lualine_b_normal', 'LuaLineProgress', {
              fg = color.alpha_hl('lualine_b_normal', 'fg', 0.25),
            })

            return require('lsp-progress').progress({
              --- @param client_messages string[]|table[]
              ---     Client messages array.
              --- @return string
              ---     The returned value will be returned as the result of `progress` API.
              format = function(client_messages)
                local sign = '' -- nf-fa-gear \uf013
                if #client_messages > 0 then
                  local message = sign .. ' ' .. table.concat(client_messages, ' ')

                  -- ignore null-ls messages
                  if string.find(message, 'null%-ls') then
                    return ''
                  end

                  return message
                end

                local clients = (vim.lsp and vim.lsp.get_clients and vim.lsp.get_clients()) or nil
                if clients ~= nil and #clients > 0 then
                  return sign
                end
                return ''
              end,
            })
          end,
          color = 'LuaLineProgress',
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
    event = 'LazyFile',
    config = config,
    dependencies = {
      {
        'linrongbin16/lsp-progress.nvim',
        opts = {},
      },
    },
  },
}
