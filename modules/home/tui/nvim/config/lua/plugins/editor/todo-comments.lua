local todo_ok, todo = pcall(require, "todo-comments")
if not todo_ok then
  return
end
todo.setup()
local map = require("user-util").map
map("]t", function()
  todo.jump_next()
end, { desc = "Next todo comment" })
map("[t", function()
  todo.jump_prev()
end, { desc = "Previous todo comment" })
map("<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo (Trouble)" })
map("<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme (Trouble)" })
map("<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
map("<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme" })
