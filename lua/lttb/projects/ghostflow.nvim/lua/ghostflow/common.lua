---@diagnostic disable: undefined-global

local lush = require('lush')

local M = {}

function M.create(colors_name, bg, get_palette)
  local palette = get_palette()

  -- Generate the lush specs using the generator util
  local generator = require('zenbones.specs')
  local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

  -- Optionally extend specs using Lush
  local specs = lush.extends({ base_specs }).with(function(injected_functions)
    local sym = injected_functions.sym

    return {
      CursorLine({ bg = palette.cursor_line }),
      ColorColumn({ link = 'CursorLine' }),
      BufferLineFill({ bg = palette.cursor_line }),

      -- Visual({ bg = palette.cursor_line }),

      Statement({ fg = palette.sky, gui = 'NONE' }),
      -- Special({ fg = palette.water, gui = 'NONE' }),

      Type({ fg = palette.type.desaturate(80) }),
      sym('@type.builtin')({ fg = palette.type.desaturate(60) }),

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

      Todo({ underline = false }),

      -- NeoTreeNormalNC({ bg = '#FAFAFA' }),
      NeoTreeDirectoryIcon({ fg = palette.sky.hex }),
      NeoTreeDirectoryName({ fg = palette.sky.hex }),
      NeoTreeFileName({ fg = palette.sky.hex }),

      NvimTreeNormal({ bg = palette.bg }),
      NvimTreeWinSeparator({ bg = palette.cursor_line, fg = palette.cursor_line, link = 'WinSeparator' }),
      NvimTreeCursorLine({ bg = palette.cursor_line }),
      NvimTreeExecFile({ link = 'Normal' }),

      TreesitterContextSeparator({ fg = palette.cursor_line }),

      -- I might want to move it to autocmds to apply for all themes
      FloatBorder({
        bg = 'NONE',
      }),

      NormalFloat({
        bg = palette.bg,
      }),

      VertSplit({
        bg = palette.cursor_line,
        fg = palette.cursor_line,
      }),

      WinSeparator({
        bg = palette.cursor_line,
        fg = palette.cursor_line,
        link = 'WinSeparator',
      }),
    }
  end)

  return { specs = lush(specs), palette = palette }
end

return M
