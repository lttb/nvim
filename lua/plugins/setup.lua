local utils = require("lttb.utils")

if utils.is_neovide() then
  require("lttb.settings.neovide")

  return {}
end

return {}
