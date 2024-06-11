local context_ok, context = pcall(require, "treesitter-context")
if not context_ok then
  return
end
context.setup({ mode = "cursor", max_lines = 3 })
local map = require("user-util").map
map("<leader>ut", function()
  local tsc = require("treesitter-context")
  tsc.toggle()
end, { desc = "Toggle Treesitter Context" })
