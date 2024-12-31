local util = require('zenbones.util')
local core = require('lttb.themes.zengithub')

local lush = require('lush')
local hsluv = lush.hsluv -- Human-friendly hsl

core.create('zengithub_dark', 'dark', function()
  return util.palette_extend({
    -- bg = hsluv(0, 0, 9),
    -- bg = hsluv('#24282e'),
    bg = hsluv('#24282e'),
    fg = hsluv('#C2C2C2'),
    sky = hsluv('#7d8590'),

    muted = hsluv('#636c76'),

    type = hsluv('#a07e3b'),

    cursor_line = hsluv('#282c34'),

    -- sidebar = hsluv('#22272e'),
  }, 'dark')
end)
