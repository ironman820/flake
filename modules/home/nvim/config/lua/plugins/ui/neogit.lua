local neogit_ok, neogit = pcall(require, "neogit")
if not neogit_ok then
  return
end
neogit.setup({})
local map = require("user-util").map
map("<leader>go", "<cmd>Neogit<cr>", { desc = "Open Neogit", mode = "n" })
