local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end
telescope.load_extension("fzf")
local has_aerial, _ = pcall(require, "aerial")
if has_aerial then
  telescope.load_extension("aerial")
end
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
local map = require("user-util").map
map("<leader>,", function()
  builtin.buffers({ sort_mru = true, sort_lastused = true })
end, { desc = "Switch Buffer" })
map("<leader>/", builtin.live_grep, { desc = "Grep (root dir)" })
map("<leader>:", builtin.command_history, { desc = "Command History" })
map("<leader><space>", builtin.find_files, { desc = "Find Files (root dir)" })
-- find
map("<leader>fb", function()
  builtin.buffers({ sort_mru = true, sort_lastused = true })
end, { desc = "Buffers" })
map("<leader>ff", builtin.find_files, { desc = "Find Files (root dir)" })
map("<leader>fF", function()
  builtin.find_files({ cwd = false })
end, { desc = "Find Files (cwd)" })
map("<leader>fr", builtin.oldfiles, { desc = "Recent" })
map("<leader>fR", function()
  builtin.oldfiles({ cwd = vim.loop.cwd() })
end, { desc = "Recent (cwd)" })
-- git
map("<leader>gb", builtin.git_branches, { desc = "branches" })
map("<leader>gc", builtin.git_commits, { desc = "commits" })
map("<leader>gs", builtin.git_status, { desc = "status" })
-- search
map('<leader>s"', builtin.registers, { desc = "Registers" })
map("<leader>sa", builtin.autocommands, { desc = "Auto Commands" })
map("<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer" })
map("<leader>sc", builtin.command_history, { desc = "Command History" })
map("<leader>sC", builtin.commands, { desc = "Commands" })
map("<leader>sd", function()
  builtin.diagnostics({ bufnr = 0 })
end, { desc = "Document diagnostics" })
map("<leader>sD", builtin.diagnostics, { desc = "Workspace diagnostics" })
map("<leader>sg", builtin.live_grep, { desc = "Grep (root dir)" })
map("<leader>sG", function()
  builtin.live_grep({ cwd = utils.buffer_dir() })
end, { desc = "Grep (cwd)" })
map("<leader>sh", builtin.help_tags, { desc = "Help Pages" })
map("<leader>sH", builtin.highlights, { desc = "Search Highlight Groups" })
map("<leader>sk", builtin.keymaps, { desc = "Key Maps" })
map("<leader>sM", builtin.man_pages, { desc = "Man Pages" })
map("<leader>sm", builtin.marks, { desc = "Jump to Mark" })
map("<leader>so", builtin.vim_options, { desc = "Options" })
map("<leader>sR", builtin.resume, { desc = "Resume" })
map("<leader>sw", function()
  builtin.grep_string({ word_match = "-w" })
end, { desc = "Word (root dir)" })
map("<leader>sW", function()
  builtin.grep_string({ cwd = false, word_match = "-w" })
end, { desc = "Word (cwd)" })
map("<leader>sW", function()
  builtin.grep_string({ cwd = false })
end, { desc = "Selection (cwd)", mode = "v" })
map("<leader>ss", "<cmd>Telescope aerial<cr>", { desc = "Goto Symbol" })
-- map("<leader>ss", function()
--   builtin.lsp_document_symbols({ symbols = require("user-util").get_kind_filter() })
-- end, { desc = "Goto Symbol" })
map("<leader>sS", function()
  builtin.lsp_dynamic_workspace_symbols({ symbols = require("user-util").get_kind_filter() })
end, { desc = "Goto Symbol (Workspace)" })

local actions = require("telescope.actions")

local open_with_trouble = function(...)
  return require("trouble.providers.telescope").open_with_trouble(...)
end
local open_selected_with_trouble = function(...)
  return require("trouble.providers.telescope").open_selected_with_trouble(...)
end
local find_files_no_ignore = function()
  local action_state = require("telescope.actions.state")
  local line = action_state.get_current_line()
  telescope.find_files({ no_ignore = true, default_text = line })
end
local find_files_with_hidden = function()
  local action_state = require("telescope.actions.state")
  local line = action_state.get_current_line()
  telescope.find_files({ hidden = true, default_text = line })
end

-- local has_worktree, _ = pcall(require, "git-worktree")
-- if has_worktree then
--   telescope.load_extension("git_worktree")
--   local worktree = require("telescope").extensions.git_worktree
--   map("<leader>gwl", worktree.git_worktrees, { desc = "List Worktrees" })
--   map("<leader>gwc", worktree.create_git_worktree, { desc = "Create Worktrees" })
-- end

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    -- open files in the first window that is an actual file.
    -- use the current window if no other window is available.
    get_selection_window = function()
      local wins = vim.api.nvim_list_wins()
      table.insert(wins, 1, vim.api.nvim_get_current_win())
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "" then
          return win
        end
      end
      return 0
    end,
    mappings = {
      i = {
        ["<c-t>"] = open_with_trouble,
        ["<a-t>"] = open_selected_with_trouble,
        ["<a-i>"] = find_files_no_ignore,
        ["<a-h>"] = find_files_with_hidden,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up,
        ["<esc>"] = actions.close,
      },
      n = {
        ["q"] = actions.close,
        ["<esc>"] = actions.close,
      },
    },
  },
})
