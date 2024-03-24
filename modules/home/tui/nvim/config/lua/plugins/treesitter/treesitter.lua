local treesitter_ok, _ = pcall(require, "nvim-treesitter")
if not treesitter_ok then
  return
end
-- When in diff mode, we want to use the default
-- vim text objects c & C instead of the treesitter ones.
local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
local configs = require("nvim-treesitter.configs")
for name, fn in pairs(move) do
  if name:find("goto") == 1 then
    move[name] = function(q, ...)
      if vim.wo.diff then
        local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
        for key, query in pairs(config or {}) do
          if q == query and key:find("[%]%[][cC]") then
            vim.cmd("normal! " .. key)
            return
          end
        end
      end
      return fn(q, ...)
    end
  end
end
---@type TSConfig
---@diagnostic disable-next-line: missing-fields
local opts = {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
  -- rainbow = {
  --   enable = true,
  --   -- list of languages you want to disable the plugin for
  --   -- disable = { "jsx", "cpp" },
  --   -- Which query to use for finding delimiters
  --   query = "rainbow-parens",
  --   -- Highlight the entire buffer all at once
  --   strategy = require("ts-rainbow.strategy.global"),
  --   -- Do not enable for files with more than n lines
  --   max_file_lines = 3000,
  -- },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
  },
}
-- if type(opts.ensure_installed) == "table" then
--   ---@type table<string, boolean>
--   local added = {}
--   opts.ensure_installed = vim.tbl_filter(function(lang)
--     if added[lang] then
--       return false
--     end
--     added[lang] = true
--     return true
--   end, opts.ensure_installed)
-- end
configs.setup(opts)
