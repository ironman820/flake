local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then
  return
end
luasnip.setup({
  history = true,
  check_events = { "TextChanged", "TextChangedI" },
})

local map = require("user-util").map
map("<tab>", function()
  return luasnip.jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
end, { expr = true, silent = true, mode = "i" })
map("<tab>", function()
  luasnip.jump(1)
end, { mode = "s" })
map("<s-tab>", function()
  luasnip.jump(-1)
end, { mode = { "i", "s" } })
map(
  "<leader>us",
  "<cmd>source ~/.config/nvim/after/plugin/nix.lua<cr>",
  { desc = "Source Luasnip Snippets", mode = "n" }
)
