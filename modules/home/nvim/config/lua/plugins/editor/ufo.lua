local ufo_ok, ufo = pcall(require, "ufo")
if not ufo_ok then
  return
end
local map = require("user-util").map

vim.o.foldcolumn = "1" -- '0' is not bad
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
map("zR", ufo.openAllFolds, { mode = "n" })
map("zM", ufo.closeAllFolds, { mode = "n" })
map("<Leader>-", "<Cmd>set foldlevel-=1<CR>zz", { desc = "zoom out (see less)", mode = "n" })
map("<Leader>=", "<Cmd>set foldlevel+=1<CR>zz", { desc = "zoom in (see more)", mode = "n" })
map("<Leader><Leader>-", "<Cmd>set foldlevel=0<CR>zM", { desc = "zoom out max", mode = "n" })
map("<Leader><Leader>=", "<Cmd>set foldlevel=20<CR>zR", { desc = "zoom in max", mode = "n" })
map("Z", "zkzxzz", { mode = "n" })
map("X", "zjzxzz", { mode = "n" })

-- nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true
-- }
-- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
-- for _, ls in ipairs(language_servers) do
--     require('lspconfig')[ls].setup({
--         capabilities = capabilities
--         -- you can add other fields for setting up lsp server in this table
--     })
-- end
-- ufo.setup()

-- Option 3: treesitter as a main provider instead
-- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
-- use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
---@diagnostic disable-next-line: missing-fields
ufo.setup({
  provider_selector = function(_, _, _)
    return { "treesitter", "indent" }
  end,
})
