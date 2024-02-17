local notify_ok, notify = pcall(require, "notify")
if not notify_ok then
  return
end
local has_noice, _ = pcall(require, "noice")
---@diagnostic disable-next-line: missing-fields
notify.setup({
  timeout = 3000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { zindex = 100 })
  end,
})
-- when noice is not enabled, install notify on VeryLazy
if not has_noice then
  vim.notify = notify
end
local map = require("user-util").map
map("<leader>un", function()
  notify.dismiss({ silent = true, pending = true })
end, { desc = "Dismiss all Notifications" })
