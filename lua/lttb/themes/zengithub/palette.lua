local util = require('zenbones.util')
local core = require('lttb.themes.zengithub.common')

local lush = require('lush')
local hsluv = lush.hsluv -- Human-friendly hsl

local M = {}

M.light = core.create('zengithub', 'light', function()
  return util.palette_extend({
    bg = hsluv('#ffffff'),
    fg = hsluv('#1f2328'),
    sky = hsluv('#6e7781'),

    muted = hsluv('#636c76'),

    type = hsluv('#AB47BC'),

    cursor_line = hsluv('#f6f8fa'),
  }, 'light')
end)
M.dark = core.create('zengithub', 'dark', function()
  return util.palette_extend({
    bg = hsluv('#24282e'),
    fg = hsluv('#C2C2C2'),
    sky = hsluv('#7d8590'),

    muted = hsluv('#636c76'),

    type = hsluv('#a07e3b'),

    cursor_line = hsluv('#282c34'),
  }, 'dark')
end)


return M
