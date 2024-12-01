local util = require("zenbones.util")
local core = require("lttb.theme.zengithub")

local lush = require("lush")
local hsluv = lush.hsluv -- Human-friendly hsl

core.create("zengithub_light", "light", function()
  return util.palette_extend({
    bg = hsluv("#ffffff"),
    fg = hsluv("#1f2328"),
    -- rose = hsluv('#d1242f'),
    -- leaf = hsluv('#1a7f37'),
    -- wood = hsluv('#bf3989'),
    -- water = hsluv('#0969da'),
    -- blossom = hsluv('#8250df'),
    sky = hsluv("#6e7781"),

    -- gold = hsluv('#9a6700'),
    -- gold = hsluv('#9a6700'),
    -- gold_muted = hsluv('#ad8c45'),
    muted = hsluv("#636c76"),

    type = hsluv("#AB47BC"),

    cursor_line = hsluv("#f6f8fa"),
    -- sidebar = hsluv('#fafafa'),
  }, "light")
end)
