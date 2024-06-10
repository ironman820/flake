local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  return
end
local neodev_ok, neodev = pcall(require, "neodev")
if neodev_ok then
  neodev.setup({})
end
local keys = vim.keymap
local buffer = vim.lsp.buf
-- local stylua = require("efmls-configs.formatters.stylua")
-- local statix = require("efmls-configs.linters.statix")
-- local nixfmt = require("efmls-configs.formatters.nixfmt")
-- local flake8 = require("efmls-configs.linters.flake8")
-- local black = require("efmls-configs.formatters.black")
local opts = {
  -- options for vim.diagnostic.config()
  diagnostics = {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
      -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
      -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
      -- prefix = "icons",
    },
    severity_sort = true,
  },
  flags = {
    debounce_text_changes = 500,
  },
  -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
  -- Be aware that you also will need to properly configure your LSP server to
  -- provide the inlay hints.
  inlay_hints = {
    enabled = false,
  },
  -- add any global capabilities here
  capabilities = {},
  -- options for vim.lsp.buf.format
  -- `bufnr` and `filter` is handled by the LazyVim formatter,
  -- but can be also overridden when specified
  format = {
    formatting_options = nil,
    timeout_ms = nil,
  },
  on_attach = function(client, bufnr)
    keys.set("n", "K", buffer.hover, { desc = "Enable hover definitions" })
    keys.set("n", "gd", buffer.definition, { desc = "Goto definition" })
    keys.set("n", "gr", buffer.references, { desc = "Goto references" })
    -- keys.set("n", "gy", buffer.references, { desc = "Goto references" })
    keys.set("n", "gD", buffer.declaration, { desc = "Goto declaration" })
    keys.set("n", "gI", buffer.implementation, { desc = "Goto implimentation" })
    -- keys.set("n", "gK", buffer.signature_help, { desc = "Goto implimentation" })
    keys.set("n", "<leader>cD", "<cmd>Telescope diagnostics<cr>", { desc = "Open Diagnostics list" })
    keys.set("n", "<leader>cl", "<Cmd>LspInfo<CR>", { desc = "Open LSP Info" })
    keys.set("n", "<leader>cL", "<cmd>LspLog<cr>", { desc = "Open LSP [L]og" })
    if client.server_capabilities["documentSymbolProvider"] then
      require("nvim-navic").attach(client, bufnr)
    end
  end,
  -- LSP Server Settings
  -- ---@type lspconfig.options
  servers = {
    -- efm = {
    --   filetypes = {
    --     "lua",
    --     "nix",
    --     "python",
    --   },
    --   init_options = {
    --     documentFormatting = true,
    --     documentRangeFormatting = true,
    --     hover = true,
    --     documentSymbol = false,
    --     codeAction = true,
    --     completion = true,
    --   },
    --   mason = false,
    --   settings = {
    --     languages = {
    --       lua = { stylua },
    --       nix = { statix, nixfmt },
    --       python = { flake8, black },
    --     },
    --   },
    -- },
    lua_ls = {
      mason = false, -- set to false if you don't want this server to be installed with mason
      -- Use this to add any additional keymaps
      -- for specific lsp servers
      -- ---@type LazyKeysSpec[]
      -- keys = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              [vim.env.VIMRUNTIME] = true,
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
              -- ["${3rd}/luv/library"] = true,
            },
          },
        },
      },
    },
    nil_ls = {
      mason = false,
      settings = {},
    },
    pyright = {
      mason = false,
      settings = {},
    },
    psalm = {
      cmd = { "psalm", "--language-server" },
      mason = false,
      root_dir = lspconfig.util.root_pattern(".git"),
      settings = {},
    },
    taplo = {
      mason = false,
      settings = {},
    },
  },
  settings = {},
  -- you can do any additional lsp server setup here
  -- return true if you don't want this server to be setup with lspconfig
  -- ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  setup = {
    -- example to setup with typescript.nvim
    -- tsserver = function(_, opts)
    --   require("typescript").setup({ server = opts })
    --   return true
    -- end,
    -- Specify * to use this function as a fallback for any server
    -- ["*"] = function(server, opts) end,
  },
}
-- vim.lsp.set_log_level("debug")
local neoconf_ok, neoconf = pcall(require, "neoconf")
if neoconf_ok then
  neoconf.setup()
end

-- diagnostics
local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
for name, icon in pairs(signs) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

-- if opts.inlay_hints.enabled then
--   Util.lsp.on_attach(function(client, buffer)
--     if client.supports_method("textDocument/inlayHint") then
--       Util.toggle.inlay_hints(buffer, true)
--     end
--   end)
-- end

-- if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
--   opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
--     or function(diagnostic)
--       local icons = require("lazyvim.config").icons.diagnostics
--       for d, icon in pairs(icons) do
--         if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
--           return icon
--         end
--       end
--     end
-- end

vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

local servers = opts.servers
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  has_cmp and cmp_nvim_lsp.default_capabilities() or {},
  opts.capabilities or {}
)

local function setup(server)
  local server_opts = vim.tbl_deep_extend("force", opts, {
    capabilities = vim.deepcopy(capabilities),
    servers = nil,
    setup = nil,
  }, servers[server] or {})

  if opts.setup[server] then
    if opts.setup[server](server, server_opts) then
      return
    end
  elseif opts.setup["*"] then
    if opts.setup["*"](server, server_opts) then
      return
    end
  end
  lspconfig[server].setup(server_opts)
end

-- get all the servers that are available through mason-lspconfig
local have_mason, mlsp = pcall(require, "mason-lspconfig")
local all_mslp_servers = {}
if have_mason then
  all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
end

local ensure_installed = {} ---@type string[]
for server, server_opts in pairs(servers) do
  if server_opts then
    server_opts = server_opts == true and {} or server_opts
    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
      setup(server)
    else
      ensure_installed[#ensure_installed + 1] = server
    end
  end
end

if have_mason then
  mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
end
