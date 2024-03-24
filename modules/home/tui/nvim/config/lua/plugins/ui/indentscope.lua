-- ---@diagnostic disable-next-line
-- return

local indentscope_ok, indentscope = pcall(require, "indentscope")
if not indentscope_ok then
  return
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "lazyterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
indentscope.setup({
  -- symbol = "▏",
  symbol = "│",
  options = {
    try_as_border = true,
  },
})
