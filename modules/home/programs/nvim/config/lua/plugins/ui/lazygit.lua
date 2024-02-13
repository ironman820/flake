local lazygit_ok, _ = pcall(require, "lazygit")
if not lazygit_ok then
  return
end

local map = require("user-util").map

map("<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
