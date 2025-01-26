local common_fg = '#636c76'
local inactive_bg = '#23272E'

if vim.o.background == 'light' then
  common_fg = '#1f2328'
  inactive_bg = '#f6f8fa'
end

local inactive_fg = common_fg

return {
  normal = {
    a = { bg = inactive_bg, fg = common_fg, gui = 'bold' },
    b = { bg = inactive_bg, fg = common_fg },
    c = { bg = inactive_bg, fg = common_fg },
  },

  insert = {
    a = { bg = inactive_bg, fg = '#324757', gui = 'bold' },
  },

  command = {
    a = { bg = inactive_bg, fg = '#9a6700', gui = 'bold' },
  },

  visual = {
    a = { bg = inactive_bg, fg = '#8250df', gui = 'bold' },
  },

  replace = {
    a = { bg = inactive_bg, fg = '#bf3989', gui = 'bold' },
  },

  inactive = {
    a = { bg = inactive_bg, fg = inactive_fg, gui = 'bold' },
    b = { bg = inactive_bg, fg = inactive_fg },
    c = { bg = inactive_bg, fg = inactive_fg },
  },
}
