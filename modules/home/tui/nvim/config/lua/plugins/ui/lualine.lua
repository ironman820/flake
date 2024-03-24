local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then
  return
end
local icons = require("user-icons")
vim.g.lualine_laststatus = vim.o.laststatus
if vim.fn.argc(-1) > 0 then
  -- set an empty statusline till lualine loads
  vim.o.statusline = " "
else
  -- hide the statusline on the starter page
  vim.o.laststatus = 0
end

vim.o.laststatus = vim.g.lualine_laststatus

lualine.setup({
  options = {
    theme = "catppuccin-mocha",
    globalstatus = true,
    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },

    lualine_c = {
      require("user-util").find_root(),
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      -- { Util.lualine.pretty_path() },
    },
    lualine_x = {
      -- stylua: ignore
      -- {
      --   function() return require("noice").api.status.command.get() end,
      --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
      --   -- color = Util.ui.fg("Statement"),
      -- },
      -- -- stylua: ignore
      -- {
      --   function() return require("noice").api.status.mode.get() end,
      --   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
      --   -- color = Util.ui.fg("Constant"),
      -- },
      -- -- stylua: ignore
      -- {
      --   function() return "  " .. require("dap").status() end,
      --   cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
      --   -- color = Util.ui.fg("Debug"),
      -- },
      {
        "diff",
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        },
        source = function()
          ---@diagnostic disable-next-line
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
    },
    lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      function()
        return " " .. os.date("%R")
      end,
    },
  },
  extensions = { "neo-tree" },
})
