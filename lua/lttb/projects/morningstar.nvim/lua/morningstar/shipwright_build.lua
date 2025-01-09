-- TODO: refactor and move to the plugin level

local bg = vim.o.background

local colorscheme = require('morningstar.palette')
local lushwright = require('shipwright.transform.lush')

local name = 'morningstar_' .. bg

-- @see https://github.com/zenbones-theme/zenbones.nvim/blob/3c0b86bb912d41d191d90c019a346f6a1d27f588/lua/zenbones/shipwright/runners/vim.lua
local function to_vim_autoload(colorscheme)
  local vimcolors, term = unpack(colorscheme)

  local termcolors = {
    string.format("let g:terminal_color_0 = '%s'", term.black),
    string.format("let g:terminal_color_1 = '%s'", term.red),
    string.format("let g:terminal_color_2 = '%s'", term.green),
    string.format("let g:terminal_color_3 = '%s'", term.yellow),
    string.format("let g:terminal_color_4 = '%s'", term.blue),
    string.format("let g:terminal_color_5 = '%s'", term.magenta),
    string.format("let g:terminal_color_6 = '%s'", term.cyan),
    string.format("let g:terminal_color_7 = '%s'", term.white),
    string.format("let g:terminal_color_8 = '%s'", term.bright_black),
    string.format("let g:terminal_color_9 = '%s'", term.bright_red),
    string.format("let g:terminal_color_10 = '%s'", term.bright_green),
    string.format("let g:terminal_color_11 = '%s'", term.bright_yellow),
    string.format("let g:terminal_color_12 = '%s'", term.bright_blue),
    string.format("let g:terminal_color_13 = '%s'", term.bright_magenta),
    string.format("let g:terminal_color_14 = '%s'", term.bright_cyan),
    string.format("let g:terminal_color_15 = '%s'", term.bright_white),
  }

  return vim.list_extend(termcolors, vimcolors)
end

local scheme = colorscheme[bg]

local term = require('zenbones.term').colors_map(scheme.palette)

run(
  scheme.specs,
  lushwright.to_vimscript,
  lushwright.vim_compatible_vimscript,
  -- @see https://github.com/zenbones-theme/zenbones.nvim/blob/3c0b86bb912d41d191d90c019a346f6a1d27f588/lua/zenbones/shipwright/runners/vim.lua
  function(colors)
    local vimcolors = vim.tbl_filter(function(color)
      return not (
        string.match(color, '@')
        or string.match(color, 'Noice')
        or string.match(color, 'Telescope')
        or string.match(color, 'Leap')
        or string.match(color, 'Hop')
        or string.match(color, 'Neogit')
        or string.match(color, 'NvimTree')
        or string.match(color, 'Cmp')
        or string.match(color, 'Mason')
      )
    end, colors)
    return {
      vimcolors,
      term,
    }
  end,
  to_vim_autoload,
  { prepend, 'function ' .. name .. '#load()' },
  { append, 'endfunction' },
  { overwrite, 'autoload/' .. name .. '.vim' }
)
