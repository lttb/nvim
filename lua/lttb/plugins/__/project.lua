local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'ahmedkhalf/project.nvim',
    event = 'VeryLazy',
    init = function()
      utils.on_load('telescope.nvim', function()
        require('project_nvim').setup({
          manual_mode = true,
          scope_chdir = 'tab',
        })

        require('telescope').load_extension('projects')
      end)
    end,
  },
}
