local persistence_ok, persistence = pcall(require, "persistence")
if not persistence_ok then
  return
end
persistence.setup({ options = vim.opt.sessionoptions:get() })
local map = require("user-util").map
map("<leader>qs", function()
  require("persistence").load()
end, { desc = "Restore Session" })
map("<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })
map("<leader>qd", function()
  require("persistence").stop()
end, { desc = "Don't Save Current Session" })
