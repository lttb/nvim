# Neovim 0.12 UI2 + native statusline + tiny-cmdline

**Date:** 2026-04-11
**Status:** Approved — ready for implementation

## Goal

Adopt Neovim 0.12 UI improvements in this config:

1. Replace `lualine.nvim` with a native `vim.o.statusline` module that is a 1:1 visual replica of the current lualine setup, auto-adapting to any colorscheme and dark/light background switches.
2. Fix the LSP progress regression (progress component silently returns empty under `laststatus=3`).
3. Enable Neovim 0.12's experimental `vim._core.ui2` with the ephemeral message window (`msg` target) and layer `tiny-cmdline.nvim` on top for a centered floating cmdline.
4. Disable `snacks.nvim` notifier (replaced by UI2 `msg` window).
5. Adopt a handful of minor 0.12 niceties: `pumborder`, `pummaxwidth`, `:restart` keymap, rely on native `gr*` LSP mappings.

## Non-goals

- Re-theming or extending the statusline beyond lualine's current feature set.
- Switching away from `blink.cmp` to native `autocomplete`.
- Setting `winborder` globally (affects all floats — too broad for this change).
- Replacing `snacks` pickers with native or other alternatives.

## Background — why the LSP progress regression happened

Commit `2bb2e2b` ("optimize config for neovim 0.12") replaced `lsp-progress.nvim` with `vim.ui.progress_status()` at `lua/lttb/plugins/lualine.lua:31`. That function exists in 0.12 but its implementation gates on `vim.g.actual_curwin`:

```
v:lua.require('vim._core.util').term_exitcode() ...
  luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1)
           and vim.ui.progress_status()) or '''' ')
```

When lualine re-evaluates the component on its own refresh cycle (or via the `LspProgress` autocmd) with `laststatus=3`, it routinely falls outside the "actual current window" context and returns `""`. The right API for a global statusline is `vim.lsp.status()` — workspace-scoped, no window gating.

## File layout

```
Created:
  lua/lttb/config/statusline.lua            — native statusline builder
  lua/lttb/plugins/ui.tiny-cmdline.lua      — tiny-cmdline plugin spec + UI2 enable

Deleted:
  lua/lttb/plugins/lualine.lua

Edited:
  init.lua                                  — require('lttb.config.statusline').setup()
  lua/lttb/config/keymaps.lua               — <leader>qr restart
  lua/lttb/settings/init.lua                — pumborder, pummaxwidth
  lua/lttb/plugins/snacks.lua               — notifier disabled, <leader>n/un removed, grr comment
```

## Component 1 — `lua/lttb/config/statusline.lua`

Module with a single public `setup()` entry point. All pieces below live in this file.

### Layout (1:1 with lualine sections a→z)

```
[ NORMAL ]        LSP_progress   %=    main | parent/file.lua | +1 ~2 -3 |  1  1 |  lua | 45%    120:10
   A                   C                          ───────── Y ─────────                          Z
```

- **A** — mode label with per-mode fg color
- **B** — empty space
- **C** — LSP progress or client-attached gear icon
- **X** — `%=` align-right
- **Y** — branch │ filename │ diff │ diagnostics │ filetype │ progress%, joined by ` | `
- **Z** — `%l:%c` location

### Components (functions in the module)

| Function | Replicates lualine item | Source of truth |
|---|---|---|
| `M.mode()` | `mode` | `vim.api.nvim_get_mode().mode` → `MODE_MAP` table → full-word label + hl group |
| `M.lsp_progress()` | custom LSP component from `lualine.lua:28-42` | `vim.lsp.status()` (fix) + `vim.lsp.get_clients({bufnr=0})` fallback |
| `M.branch()` | `branch` | `vim.b.gitsigns_head` |
| `M.filename()` | `filename path=4 symbols={unnamed=''}` | `fnamemodify(':h:t') .. '/' .. fnamemodify(':t')`; empty for unnamed buffer; `●`/`` for modified/readonly |
| `M.diff()` | `diff` | `vim.b.gitsigns_status_dict` → `+N ~N -N` with linked hl groups |
| `M.diagnostics()` | `diagnostics` | `vim.diagnostic.count(0)` with nerd-font glyphs matching lualine defaults |
| `M.filetype()` | `filetype` | `vim.bo.filetype` + `nvim-web-devicons` prefix |
| `'%P'` | `progress` (cursor %) | native statusline expression |
| `'%l:%c'` | `location` | native statusline expression |

### `M.build()`

Called via `statusline = "%!v:lua.require'lttb.config.statusline'.build()"`. Re-evaluated on every redraw.

```lua
local DISABLED = { NvimTree = true, ['neo-tree'] = true, oil = true }

function M.build()
  if DISABLED[vim.bo.filetype] then return '' end
  return table.concat({
    M.mode(),                               -- A
    ' ',                                    -- B empty
    '%#LttbStlC#', M.lsp_progress(), '%*',  -- C
    '%=',                                   -- X empty + align-right
    M.section_y(),                          -- Y
    ' %#LttbStlZ# %l:%c %*',                -- Z
  })
end
```

`M.section_y()` joins non-empty parts (`branch`, `filename`, `diff`, `diagnostics`, `filetype`, `%P`) with ` | ` separator in `LttbStlSep` hl.

### Mode map (mirrors lualine/utils/mode.lua)

```lua
local MODE_MAP = {
  n = { 'NORMAL',  'LttbStlA_N' },
  i = { 'INSERT',  'LttbStlA_I' }, ic = { 'INSERT', 'LttbStlA_I' }, ix = { 'INSERT', 'LttbStlA_I' },
  v = { 'VISUAL',  'LttbStlA_V' }, V = { 'V-LINE', 'LttbStlA_V' }, ['\22'] = { 'V-BLOCK', 'LttbStlA_V' },
  s = { 'SELECT',  'LttbStlA_V' }, S = { 'S-LINE', 'LttbStlA_V' }, ['\19'] = { 'S-BLOCK', 'LttbStlA_V' },
  R = { 'REPLACE', 'LttbStlA_R' }, Rv = { 'V-REPLACE', 'LttbStlA_R' },
  c = { 'COMMAND', 'LttbStlA_C' }, cv = { 'EX', 'LttbStlA_C' },
  r = { 'PROMPT',  'LttbStlA_N' }, rm = { 'MORE', 'LttbStlA_N' }, ['r?'] = { 'CONFIRM', 'LttbStlA_N' },
  ['!'] = { 'SHELL', 'LttbStlA_N' }, t = { 'TERMINAL', 'LttbStlA_N' },
}
```

Fallback when a mode code is missing: look up first character, then uppercase it as a last resort. Never errors.

### Theme-adaptive highlights

All hl values are **derived from existing theme groups** at `ColorScheme` time, so the statusline auto-adapts to any colorscheme and to dark/light background flips.

```lua
local function get(name, attr, fallback)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return hl[attr] or fallback
end

function M.apply_highlights()
  local bar_bg = get('StatusLine', 'bg', get('Normal', 'bg', 'NONE'))
  local bar_fg = get('StatusLine', 'fg', get('Comment', 'fg', 'NONE'))

  local mode_colors = {
    A_N = bar_fg,
    A_I = get('String',          'fg', bar_fg),
    A_V = get('Constant',        'fg', get('Type', 'fg', bar_fg)),
    A_C = get('DiagnosticWarn',  'fg', get('WarningMsg', 'fg', bar_fg)),
    A_R = get('DiagnosticError', 'fg', get('ErrorMsg',   'fg', bar_fg)),
  }

  local set = function(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  for mode, fg in pairs(mode_colors) do
    set('LttbStl' .. mode, { bg = bar_bg, fg = fg, bold = true })
  end
  set('LttbStlB',   { bg = bar_bg, fg = bar_fg })
  set('LttbStlC',   { bg = bar_bg, fg = bar_fg })
  set('LttbStlY',   { bg = bar_bg, fg = bar_fg })
  set('LttbStlZ',   { bg = bar_bg, fg = bar_fg, bold = true })
  set('LttbStlSep', { bg = bar_bg, fg = bar_fg })

  set('LttbStlDiffAdd',    { bg = bar_bg, link = 'GitSignsAdd'    })
  set('LttbStlDiffChange', { bg = bar_bg, link = 'GitSignsChange' })
  set('LttbStlDiffDelete', { bg = bar_bg, link = 'GitSignsDelete' })
  set('LttbStlDiagErr',    { bg = bar_bg, link = 'DiagnosticError' })
  set('LttbStlDiagWarn',   { bg = bar_bg, link = 'DiagnosticWarn'  })
  set('LttbStlDiagInfo',   { bg = bar_bg, link = 'DiagnosticInfo'  })
  set('LttbStlDiagHint',   { bg = bar_bg, link = 'DiagnosticHint'  })
end
```

### `M.setup()`

```lua
function M.setup()
  vim.o.statusline = "%!v:lua.require'lttb.config.statusline'.build()"
  M.apply_highlights()

  local grp = vim.api.nvim_create_augroup('lttb.statusline', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', { group = grp, callback = M.apply_highlights })
  vim.api.nvim_create_autocmd('OptionSet', {
    group = grp, pattern = 'background', callback = M.apply_highlights,
  })
  vim.api.nvim_create_autocmd(
    { 'LspProgress', 'DiagnosticChanged', 'ModeChanged', 'BufEnter' },
    { group = grp, callback = function() vim.cmd.redrawstatus() end }
  )
end
```

## Component 2 — `lua/lttb/plugins/ui.tiny-cmdline.lua`

```lua
local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'rachartier/tiny-cmdline.nvim',
    lazy = false,
    priority = 900,
    init = function()
      vim.o.cmdheight = 0
    end,
    config = function()
      require('vim._core.ui2').enable({
        msg = {
          targets = 'msg',
          msg = { height = 0.5, timeout = 6000 },
        },
      })

      -- Borderless padded border to match the hover float aesthetic (commit 6a234d8)
      local border = {
        { ' ', 'NormalFloat' }, { ' ', 'NormalFloat' }, { ' ', 'NormalFloat' }, { ' ', 'NormalFloat' },
        { ' ', 'NormalFloat' }, { ' ', 'NormalFloat' }, { ' ', 'NormalFloat' }, { ' ', 'NormalFloat' },
      }

      require('tiny-cmdline').setup({
        width = { value = '60%' },
        position = { x = '50%', y = '50%' },
        border = border,
      })
    end,
  },
}
```

## Component 3 — `lua/lttb/plugins/snacks.lua` edits

1. Flip `notifier.enabled` from `true` to `false` at `lua/lttb/plugins/snacks.lua:64-69`.
2. Remove the `<leader>n` (notification history) and `<leader>un` (dismiss) keymaps at `lua/lttb/plugins/snacks.lua:240-252` — UI2 replaces this path; `:messages` → pager opens via `g<`.
3. Add a brief comment near the `gr` mapping noting that Neovim 0.12 ships `grr`/`gra`/`grn`/etc. as defaults, which coexist with the snacks two-letter overrides.

## Component 4 — `lua/lttb/settings/init.lua` edits

Add near the other UI options block (after `vim.opt.cmdheight = 0`):

```lua
vim.opt.pumborder   = 'rounded'   -- rounded popup menu (0.12)
vim.opt.pummaxwidth = 40          -- cap completion popup width (0.12)
```

## Component 5 — `lua/lttb/config/keymaps.lua` edit

Add alongside the existing `<leader>qq`:

```lua
vim.keymap.set('n', '<leader>qr', '<cmd>restart<cr>', { desc = 'Restart Neovim' })
```

## Component 6 — `init.lua` edit

After `require('lttb.config.keymaps')`:

```lua
require('lttb.config.statusline').setup()
```

## Delete — `lua/lttb/plugins/lualine.lua`

Remove the file entirely. The morningstar lualine theme at `lua/lttb/projects/morningstar.nvim/lua/lualine/themes/morningstar.lua` stays (it's a published artifact of the morningstar project, not consumed here).

## Testing checklist

1. `nvim --headless -c "lua require('lttb.config.statusline').setup()" -c qa` — module loads clean.
2. Open nvim normally, open a Lua file — verify mode switches cycle colors (`NORMAL` → `i` → `INSERT`, etc.).
3. Trigger an LSP client — verify progress text appears during attach/indexing.
4. `:lua vim.o.background = 'light'` / `dark` — verify statusline bg flips without restart.
5. `:colorscheme habamax` → `:colorscheme morningstar` — verify colors re-derive, no hardcoded hex leaks through.
6. `:edit foo.txt` then `:messages` → pager opens as a buffer + window (UI2 pager target).
7. `:w` a file — verify write message appears in the ephemeral `msg` window and fades after ~6s.
8. `:restart` — verify full restart path via the new command.
9. Open oil / neo-tree — verify statusline blanks for those filetypes.

## Rollback plan

`git revert <commit>` restores `lualine.lua` and the old notifier config. No external state changes; all edits are in the config repo.
