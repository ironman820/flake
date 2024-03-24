local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  return
end
vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
local defaults = require("cmp.config.default")()
local opts = {
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  snippet = {
    expand = function(args)
      local luasnip_ok, luasnip = pcall(require, "luasnip")
      if luasnip_ok then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<S-CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<C-CR>"] = function(fallback)
      cmp.abort()
      fallback()
    end,
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "nerdfont" },
  }),
  formatting = {
    format = function(_, item)
      local icons = require("user-icons").kinds
      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
      end
      return item
    end,
  },
  experimental = {
    ghost_text = {
      hl_group = "CmpGhostText",
    },
  },
  sorting = defaults.sorting,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}
for _, source in ipairs(opts.sources) do
  source.group_index = source.group_index or 1
end
cmp.setup(opts)
cmp.setup.filetype(
  { "sql", "mysql", "plsql" },
  vim.tbl_extend("force", defaults, {
    sources = cmp.config.sources({
      { name = "vim-dadbod-completion" },
    }),
  })
)
-- Use git then buffer completion for commit messages
cmp.setup.filetype(
  "gitcommit",
  vim.tbl_extend("force", defaults, {
    sources = cmp.config.sources({
      { name = "git" },
    }, {
      { name = "buffer" },
    }),
  })
)
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  { "/", "?" },
  vim.tbl_extend("force", defaults, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":",
  vim.tbl_extend("force", defaults, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
)
