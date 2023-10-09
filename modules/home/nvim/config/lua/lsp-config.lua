-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local cmp = require('cmp')
local ih = require('lsp-inlayhints')
local lsp = require('lsp-zero')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format()

lsp.preset('recommended')
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
lsp.set_sign_icons({
  error = '󱐋',
  warn = '',
  hint = '󰌵',
  info = '',
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    -- 'rnix',
    'yamlls',
  },
  handlers = {
    lsp.default_setup,
  },
})

require('lspconfig').lua_ls.setup({
  on_attach = function (client, bufnr)
    ih.on_attach(client, bufnr)
  end,
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
    },
  },
})

lsp.setup()

cmp.setup({
  formatting = cmp_format,
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-j>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-k>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm({select = false}),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
  }),
  sources = {
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip'},
    {name = 'buffer'},
    {
      name = 'rg',
      keyword_length = 3,
    },
    {name = 'async_path'},
    {name = 'nerdfont'},
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
