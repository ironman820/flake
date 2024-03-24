local undotree_ok, undotree = pcall(require, "undotree")
if not undotree_ok then
  return
end
undotree.setup()

local map = require("user-util").map
map("<leader>bu", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Open Undotree", mode = "n" })
