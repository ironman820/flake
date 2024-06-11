local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
  return
end
---@class ConformOpts
local opts = {
  -- LazyVim will use these options when formatting with the conform.nvim formatter
  format = {
    timeout_ms = 500,
    async = false, -- not recommended to change
    lsp_fallback = true,
    quiet = false, -- not recommended to change
  },
  ---@type table<string, conform.FormatterUnit[]>
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    php = { "phpcbf", "php_cs_fixer" },
    python = { "isort", "black" },
  },
  -- The options you set here will be merged with the builtin formatters.
  -- You can also define any custom formatters here.
  ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
  formatters = {
    injected = { options = { ignore_errors = true } },
    -- # Example of using dprint only when a dprint.json file is present
    -- dprint = {
    --   condition = function(ctx)
    --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
    --   end,
    -- },
    --
    -- # Example of using shfmt with extra args
    -- shfmt = {
    --   prepend_args = { "-i", "2", "-ci" },
    -- },
  },
}
conform.setup(opts)
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
local map = require("user-util").map
map("<leader>cf", function()
  conform.format()
end, { desc = "Format Langs", mode = { "n", "v" } })
