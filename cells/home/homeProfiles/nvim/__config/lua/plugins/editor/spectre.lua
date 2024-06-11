local spectre_ok, spectre = pcall(require, "spectre")
if not spectre_ok then
  return
end
spectre.setup({ open_cmd = "noswapfile vnew" })
local map = require("user-util").map
map("<leader>sr", function()
  spectre.open()
end, { desc = "Replace in files (Spectre)" })
