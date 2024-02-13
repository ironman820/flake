local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end
local opts = {
  plugins = { spelling = true },
  defaults = {
    mode = { "n", "v" },
    ["g"] = { name = "+goto" },
    ["gs"] = { name = "+surround" },
    ["]"] = { name = "+next" },
    ["["] = { name = "+prev" },
    ["<leader><tab>"] = { name = "+tabs" },
    ["<leader>b"] = { name = "+buffer" },
    ["<leader>c"] = { name = "+code" },
    ["<leader>f"] = { name = "+file/find" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>gh"] = { name = "+hunks" },
    ["<leader>q"] = { name = "+quit/session" },
    ["<leader>s"] = { name = "+search" },
    ["<leader>u"] = { name = "+ui" },
    ["<leader>w"] = { name = "+windows" },
    ["<leader>x"] = { name = "+diagnostics/quickfix" },
  },
}

local has_minisurr, _ = pcall(require, "mini.surround")
if has_minisurr then
  opts.defaults["gsa"] = { name = "Add surrounding" }
  opts.defaults["gsd"] = { name = "Delete surrounding" }
  opts.defaults["gsf"] = { name = "Find right surrounding" }
  opts.defaults["gsF"] = { name = "Find left surrounding" }
  opts.defaults["gsh"] = { name = "Highlight surrounding" }
  opts.defaults["gsr"] = { name = "Replace surrounding" }
  opts.defaults["gsn"] = { name = "Update `MiniSurround.config.n_lines`" }
end

local has_noice, _ = pcall(require, "noice")
if has_noice then
  opts.defaults["<leader>sn"] = { name = "+noice" }
end

local has_treesitter, _ = pcall(require, "nvim-treesitter")
if has_treesitter then
  opts.defaults["<c-space>"] = { name = "Increment selection" }
  opts.defaults["<bs>"] = { name = "Decrement selection" }
end
local has_dap, _ = pcall(require, "dap")
if has_dap then
  opts.defaults["<leader>d"] = { name = "+debug" }
end

wk.setup(opts)
wk.register(opts.defaults)
