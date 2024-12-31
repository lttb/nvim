local bg = vim.o.background

if bg == 'light' then
  require('lttb.themes.zengithub_light')
else
  require('lttb.themes.zengithub_dark')
end
