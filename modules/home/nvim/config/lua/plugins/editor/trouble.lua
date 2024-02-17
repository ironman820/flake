local trouble_ok, trouble = pcall(require, "trouble")
if not trouble_ok then
  return
end
trouble.setup({ use_diagnostic_signs = true })
local map = require("user-util").map
map("<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics (Trouble)" })
map("<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics (Trouble)" })
map("<leader>xL", "<cmd>TroubleToggle loclist<cr>", { desc = "Location List (Trouble)" })
map("<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix List (Trouble)" })
map("[q", function()
  if trouble.is_open() then
    trouble.previous({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Previous trouble/quickfix item" })
map("]q", function()
  if trouble.is_open() then
    trouble.next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next trouble/quickfix item" })
