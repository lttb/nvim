-- local git_blame = require('gitblame')
local theme = require('lttb.theme')

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    -- component_separators = '|',
    -- section_separators = '',
  },

  sections = {
    lualine_c = {
      {
        'filename',
        newfile_status = true,
        path = 1,
      },
      -- {
      --   git_blame.get_current_blame_text,
      --   cond = git_blame.is_blame_text_available,
      -- },
    },
  },
})
