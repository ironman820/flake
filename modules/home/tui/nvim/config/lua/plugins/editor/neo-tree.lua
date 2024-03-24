local neo_tree_ok, neo_tree = pcall(require, "neo-tree")
if not neo_tree_ok then
  return
end
local opts = {
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },
  window = {
    mappings = {
      ["<space>"] = "none",
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
  },
}
-- local events = require("neo-tree.events")
opts.event_handlers = opts.event_handlers or {}
-- vim.list_extend(opts.event_handlers, {
--   { event = events.FILE_MOVED, handler = on_move },
--   { event = events.FILE_RENAMED, handler = on_move },
-- })
neo_tree.setup(opts)
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*lazygit",
  callback = function()
    if package.loaded["neo-tree.sources.git_status"] then
      require("neo-tree.sources.git_status").refresh()
    end
  end,
})
-- local deactivate = function()
--   vim.cmd([[Neotree close]])
-- end
local map = require("user-util").map
local root = require("user-util").find_root()
local command = require("neo-tree.command")
map("<leader>fe", function()
  command.execute({ toggle = true, dir = root })
end, { desc = "Explorer NeoTree (root dir)" })
map("<leader>fE", function()
  command.execute({ toggle = true, dir = vim.loop.cwd() })
end, { desc = "Explorer NeoTree (cwd)" })
map("<leader>e", "<leader>fe", { desc = "Explorer NeoTree (root dir)", remap = true })
map("<leader>E", "<leader>fE", { desc = "Explorer NeoTree (cwd)", remap = true })
map("<leader>ge", function()
  command.execute({ source = "git_status", toggle = true })
end, { desc = "Git explorer" })
map("<leader>be", function()
  command.execute({ source = "buffers", toggle = true })
end, { desc = "Buffer explorer" })
