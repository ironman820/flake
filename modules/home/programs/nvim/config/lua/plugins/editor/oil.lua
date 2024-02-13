local oil_ok, oil = pcall(require, "oil")
if not oil_ok then
  return
end
oil.setup()

local map = require("user-util").map
map("-", "<cmd>Oil<cr>", { desc = "Oil file explorer", mode = "n" })
