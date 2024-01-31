local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = { 'Neotree' },
    keys = {
      { '<D-b>', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Sidebar' } },
      { '<D-e>', '<cmd>Neotree reveal<cr>', { desc = 'Focus Sidebar' } },
    },
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      -- 'coffebar/neovim-project',
    },
    init = function()
      vim.api.nvim_create_autocmd({ 'VimEnter' }, {
        -- it should be "nested" not to show the number column
        -- @see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1106
        nested = true,
        callback = function(data)
          if not utils.should_open_sidebar(data) then
            return
          end

          -- open the tree but don't focus it
          vim.cmd('Neotree show')
        end,
      })
    end,
    opts = {
      window = {
        width = utils.is_neovide() and 60 or '25%',

        min_width = 40,

        mappings = {
          ['<space>'] = false, -- disable space until we figure out which-key disabling
          s = false,
          ['[b'] = 'prev_source',
          [']b'] = 'next_source',
          F = 'find_in_dir',
          O = 'system_open',
          Y = 'copy_selector',
          h = 'parent_or_close',
          l = 'child_or_open',
          o = 'open',
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ['<C-j>'] = 'move_cursor_down',
          ['<C-k>'] = 'move_cursor_up',
        },
      },

      enable_diagnostics = false,
      enable_git_status = false,

      filesystem = {
        filtered_items = {
          visible = true,
        },

        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = false,

        use_libuv_file_watcher = false,
      },

      default_component_configs = {
        name = {
          highlight_opened_files = true,
        },
      },

      -- @see https://github.com/AstroNvim/AstroNvim/blob/main/lua/plugins/neo-tree.lua
      commands = {
        system_open = function(state)
          vim.ui.open(state.tree:get_node():get_id())
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == 'directory' or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == 'directory' or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local notify = require('notify')

          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ['BASENAME'] = modify(filename, ':r'),
            ['EXTENSION'] = modify(filename, ':e'),
            ['FILENAME'] = filename,
            ['PATH (CWD)'] = modify(filepath, ':.'),
            ['PATH (HOME)'] = modify(filepath, ':~'),
            ['PATH'] = filepath,
            ['URI'] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ''
          end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            notify('No values to copy', vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = 'Choose to copy to clipboard:',
            format_item = function(item)
              return ('%s: %s'):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              notify(('Copied: `%s`'):format(result))
              vim.fn.setreg('+', result)
            end
          end)
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').find_files({
            cwd = node.type == 'directory' and path or vim.fn.fnamemodify(path, ':h'),
          })
        end,
      },
    },
  },
}
