local utils = require('lttb.utils')

return {
  enabled = false,
  'ms-jpq/chadtree',
  branch = 'chad',
  build = 'python3 -m chadtree deps',
  init = function()
    -- vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    --   -- it should be "nested" not to show the number column
    --   -- @see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1106
    --   nested = true,
    --   callback = function(data)
    --     if not utils.should_open_sidebar(data) then
    --       return
    --     end

    --     -- open the tree but don't focus it
    --     vim.cmd('CHADopen')
    --   end,
    -- })
  end,
  config = function()
    -- vim.api.nvim_set_var('chadtree_settings', {
    --   view = {
    --     width = '25%',
    --   },
    --   theme = {
    --     text_colour_set = 'nord',
    --     icon_colour_set = 'none',
    --   },
    -- })
  end,
}
