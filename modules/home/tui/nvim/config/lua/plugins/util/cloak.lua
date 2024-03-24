local cloak_ok, cloak = pcall(require, "cloak")
if not cloak_ok then
  return
end

cloak.setup({})

local map = require("user-util").map

map("<leader>cc", "<cmd>CloakToggle<cr>", { desc = "Toggle cloak" })
