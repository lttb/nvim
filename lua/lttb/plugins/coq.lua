local utils = require('lttb.utils')

if utils.is_vscode() then
  return
end

return {
  {
    enabled = false,
    'ms-jpq/coq_nvim',
    branch = 'coq',
    init = function()
      local remap = vim.api.nvim_set_keymap
      local npairs = require('nvim-autopairs')

      vim.g.coq_settings = {
        auto_start = true,

        ['keymap.recommended'] = true,
        ['keymap.pre_select'] = true,
        ['keymap.jump_to_mark'] = '<s-d-c-p>',

        -- clients = {
        --   ['typescript-tools'] = {
        --     always_on_top = true,
        --   },
        -- },
      }

      -- @see https://github.com/windwp/nvim-autopairs

      -- these mappings are coq recommended mappings unrelated to nvim-autopairs
      remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
      remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
      remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
      remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

      -- skip it, if you use another global object
      _G.MUtils = {}

      MUtils.CR = function()
        if vim.fn.pumvisible() ~= 0 then
          if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
            return npairs.esc('<c-y>')
          end

          return npairs.esc('<c-e>') .. npairs.autopairs_cr()
        end

        return npairs.autopairs_cr()
      end
      remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

      MUtils.BS = function()
        if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
          return npairs.esc('<c-e>') .. npairs.autopairs_bs()
        else
          return npairs.autopairs_bs()
        end
      end
      remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
    end,
  },
}
