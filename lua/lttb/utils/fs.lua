local M = {
  system_open = function(filepath)
    vim.ui.open(filepath)
  end,
  copy_selector = function(filepath)
    local notify = require('notify')

    local modify = vim.fn.fnamemodify
    local filename = modify(filepath, ':t')

    local vals = {
      ['1.FILENAME'] = filename,
      ['2.DIRNAME'] = modify(filepath, ':h'),
      ['3.PATH (CWD)'] = modify(filepath, ':.'),
      ['4.PATH (HOME)'] = modify(filepath, ':~'),
      ['5.PATH (GLOBAL)'] = filepath,
      ['6.BASENAME'] = modify(filename, ':r'),
      ['7.EXTENSION'] = modify(filename, ':e'),
      ['8.URI'] = vim.uri_from_fname(filepath),
    }

    local options = vim.tbl_filter(function(val)
      return vals[val] ~= ''
    end, vim.tbl_keys(vals))
    if vim.tbl_isempty(options) then
      notify('No values to copy', vim.log.levels.WARN)
      return
    end
    table.sort(options)
    vim.ui.select(options, {
      prompt = 'Choose to copy to clipboard:',
      format_item = function(item)
        return ('%s: %s'):format(item:sub(3), vals[item])
      end,
    }, function(choice)
      local result = vals[choice]
      if result then
        notify(('Copied: `%s`'):format(result))
        vim.fn.setreg('+', result)
      end
    end)
  end,
  find_in_dir = function(type, filepath)
    require('telescope.builtin').find_files({
      cwd = type == 'directory' and filepath or vim.fn.fnamemodify(filepath, ':h'),
    })
  end,
}

return M
