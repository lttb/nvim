local utils = require('lttb.utils')

return {
  {
    'saghen/blink.indent',
    version = 'v1.0.0',
    --- @module 'blink.indent'
    --- @type blink.indent.Config
    opts = {
      static = {
        char = utils.is_neovide() and '┊' or '┊',
        highlights = { 'IblIndent' },
      },
      scope = {
        char = utils.is_neovide() and '┊' or '┊',
        highlights = { 'IblScope' },
      },
    },
  },
}
