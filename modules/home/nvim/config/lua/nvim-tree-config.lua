vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup({
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "H",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = true,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
 -- These icons are visible when you install web-devicons
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    root_folder_modifier = ":t",
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  view = {
    width = 30,
    side = "left",
    -- mappings = {
    --   list = {
    --     { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
    --     { key = "h", cb = tree_cb "close_node" },
    --     { key = "v", cb = tree_cb "vsplit" },
    --   },
    -- },
  },
})
