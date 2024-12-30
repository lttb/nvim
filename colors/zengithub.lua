local bg = vim.o.background

if bg == 'light' then
  require('colors.zengithub_light')
else
  require('colors.zengithub_dark')
end
