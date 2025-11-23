return {
  {
    'saghen/blink.pairs',
    event = 'InsertEnter',
    version = '*',
    build = 'cargo build --release',
    opts = {
      highlights = {
        enabled = false,
      },
    },
  },
}
