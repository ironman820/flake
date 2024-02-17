local mini_buf_ok, mini_buf = pcall(require, "mini.bufremove")
if not mini_buf_ok then
  return
end
mini_buf.setup()
local map = require("user-util").map
map("<leader>bd", function()
  local bd = mini_buf.delete
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      bd(0)
    elseif choice == 2 then -- No
      bd(0, true)
    end
  else
    bd(0)
  end
end, { desc = "Delete Buffer" })
    -- stylua: ignore
  map("<leader>bD", function() mini_buf.delete(0, true) end, { desc = "Delete Buffer (Force)" })

local mini_file_ok, mini_file = pcall(require, "mini.files")
if mini_file_ok then
  mini_file.setup()
  map("<leader>ff", mini_file.open, { desc = "Open Mini file explorer" })
end
