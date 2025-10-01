return {
  -- cmd = { ... },
  -- filetypes = { ... },
  -- capabilities = {},
  settings = {
    Lua = {
      -- NOTE: it seems a bit slow
      -- diagnostics = { neededFileStatus = { ['codestyle-check'] = 'Any' } },
      -- NOTE: You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
      completion = { callSnippet = 'Replace' },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },

      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
