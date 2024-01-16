---@diagnostic disable: undefined-global

local colors_name = 'zengithub'
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require('lush')
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require('zenbones.util')

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
local palette

if bg == 'light' then
  palette = util.palette_extend({
    bg = hsluv('#FFFFFF'),
    fg = hsluv('#1f2328'),
    -- rose = hsluv('#d1242f'),
    -- leaf = hsluv('#1a7f37'),
    -- wood = hsluv('#bf3989'),
    -- water = hsluv('#0969da'),
    -- blossom = hsluv('#8250df'),
    sky = hsluv('#6e7781'),

    -- gold = hsluv('#9a6700'),
    -- gold = hsluv('#9a6700'),
    -- gold_muted = hsluv('#ad8c45'),
    muted = hsluv('#636c76'),
  }, bg)
else
  palette = util.palette_extend({
    -- bg = hsluv(0, 0, 9),
    bg = hsluv('#24282e'),
    fg = hsluv('#C2C2C2'),
    sky = hsluv('#7d8590'),

    muted = hsluv('#636c76'),
  }, bg)
end

-- Generate the lush specs using the generator util
local generator = require('zenbones.specs')
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function(injected_functions)
  local sym = injected_functions.sym

  return {
    Visual({ bg = palette.fg.mix(palette.bg, bg == 'light' and 95 or 80) }),

    Statement({ fg = palette.sky, gui = 'NONE' }),
    -- Special({ fg = palette.water, gui = 'NONE' }),

    Type({ fg = palette.rose.desaturate(60) }),
    sym('@type.builtin')({ fg = palette.rose.desaturate(90) }),

    -- Constant({ fg = palette.muted, gui = 'NONE' }),
    -- sym('@constant')({ fg = palette.muted, gui = 'NONE' }),

    Function({ fg = palette.fg, gui = 'bold' }),

    -- sym('@include')({ fg = palette.wood, gui = 'NONE' }),
    -- sym('@keyword')({ fg = palette.wood, gui = 'NONE' }),

    -- sym('@property')({ fg = palette.fg, gui = 'NONE' }),

    sym('@label')({ fg = palette.fg, gui = 'NONE' }),
    sym('@method')({ gui = 'NONE' }),
    sym('@tag')({ fg = palette.wood, gui = 'NONE' }),
    sym('@constructor')({ fg = palette.wood, gui = 'NONE' }),

    sym('@constant')({ fg = palette.wood, gui = 'NONE' }),

    sym('@string')({ fg = palette.sky, gui = 'NONE' }),
    sym('@number')({ fg = palette.sky, gui = 'NONE' }),
    sym('@boolean')({ fg = palette.sky, gui = 'NONE' }),

    Comment({ fg = palette.fg.mix(palette.bg, 65) }),

    DiagnosticDeprecated({ strikethrough = true }),
    DiagnosticUnnecessary({
      bg = 'NONE',
      fg = palette.fg.mix(palette.bg, 70).hex,
      underline = false,
      reverse = false,
    }),

    NeoTreeNormalNC({ bg = '#FAFAFA' }),
    NeoTreeDirectoryIcon({ fg = palette.sky.hex }),
    NeoTreeDirectoryName({ fg = palette.sky.hex }),
    NeoTreeFileName({ fg = palette.sky.hex }),

    Todo({ underline = false }),
  }
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
require('zenbones.term').apply_colors(palette)
