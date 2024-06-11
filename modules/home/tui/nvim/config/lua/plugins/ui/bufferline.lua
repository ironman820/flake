local bufferline_ok, bufferline = pcall(require, "bufferline")
if not bufferline_ok then
  return
end
---@diagnostic disable-next-line: missing-fields
bufferline.setup({
  ---@diagnostic disable-next-line: missing-fields
  options = {
    -- stylua: ignore
    close_command = function(n) require("mini.bufremove").delete(n, false) end,
    -- stylua: ignore
    right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    diagnostics_indicator = function(_, _, diag)
      local icons = require("user-icons").diagnostics
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
})
-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd("BufAdd", {
  callback = function()
    vim.schedule(function()
      pcall(nvim_bufferline)
    end)
  end,
})
local map = require("user-util").map
map("<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin" })
map("<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
map("<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Delete other buffers" })
map("<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete buffers to the right" })
map("<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete buffers to the left" })
map("<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
