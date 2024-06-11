local dressing_ok, _ = pcall(require, "dressing")
if not dressing_ok then
  return
end
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(...)
  require("dressing")
  return vim.ui.select(...)
end
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(...)
  require("dressing")
  return vim.ui.input(...)
end
