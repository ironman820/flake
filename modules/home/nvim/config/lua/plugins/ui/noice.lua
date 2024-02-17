local noice_ok, noice = pcall(require, "noice")
if not noice_ok then
  return
end
noice.setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
  },
})

local map = require("user-util").map
map("<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline", mode = "c" })
map("<leader>snl", function()
  require("noice").cmd("last")
end, { desc = "Noice Last Message" })
map("<leader>snh", function()
  require("noice").cmd("history")
end, { desc = "Noice History" })
map("<leader>sna", function()
  require("noice").cmd("all")
end, { desc = "Noice All" })
map("<leader>snd", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })
map("<c-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" } })
map("<c-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-b>"
  end
end, { silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" } })
