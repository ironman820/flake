local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
  return
end
local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
  return
end
local map = require("user-util").map
map("<leader>du", function()
  dapui.toggle({})
end, { desc = "Dap UI" })
map("<leader>de", function()
  dapui.eval()
end, { desc = "Eval", mode = { "n", "v" } })
local opts = {}
dapui.setup(opts)
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

-- virtual text for the debugger
require("nvim-dap-virtual-text").setup({})

map("<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Breakpoint Condition" })
map("<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("<leader>dc", function()
  require("dap").continue()
end, { desc = "Continue" })
map("<leader>da", function()
  ---@diagnostic disable-next-line: undefined-global
  require("dap").continue({ before = get_args })
end, { desc = "Run with Args" })
map("<leader>dC", function()
  require("dap").run_to_cursor()
end, { desc = "Run to Cursor" })
map("<leader>dg", function()
  require("dap").goto_()
end, { desc = "Go to line (no execute)" })
map("<leader>di", function()
  require("dap").step_into()
end, { desc = "Step Into" })
map("<leader>dj", function()
  require("dap").down()
end, { desc = "Down" })
map("<leader>dk", function()
  require("dap").up()
end, { desc = "Up" })
map("<leader>dl", function()
  require("dap").run_last()
end, { desc = "Run Last" })
map("<leader>do", function()
  require("dap").step_out()
end, { desc = "Step Out" })
map("<leader>dO", function()
  require("dap").step_over()
end, { desc = "Step Over" })
map("<leader>dp", function()
  require("dap").pause()
end, { desc = "Pause" })
map("<leader>dr", function()
  require("dap").repl.toggle()
end, { desc = "Toggle REPL" })
map("<leader>ds", function()
  require("dap").session()
end, { desc = "Session" })
map("<leader>dt", function()
  require("dap").terminate()
end, { desc = "Terminate" })
map("<leader>dw", function()
  require("dap.ui.widgets").hover()
end, { desc = "Widgets" })

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

local icons = require("user-icons")
for name, sign in pairs(icons.dap) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

dap.adapters.nlua = function(callback, conf)
  local adapter = {
    type = "server",
    ---@diagnostic disable-next-line: undefined-field
    host = conf.host or "127.0.0.1",
    ---@diagnostic disable-next-line: undefined-field
    port = conf.port or 8086,
  }
  ---@diagnostic disable-next-line: undefined-field
  if conf.start_neovim then
    local dap_run = dap.run
    ---@diagnostic disable-next-line: duplicate-set-field
    dap.run = function(c)
      adapter.port = c.port
      adapter.host = c.host
    end
    require("osv").run_this()
    dap.run = dap_run
  end
  callback(adapter)
end
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Run this file",
    start_neovim = {},
  },
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance (port = 8086)",
    port = 8086,
  },
}
