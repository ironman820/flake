local map = require("user-util").map

map("q", "<Nop>")

map("jk", "<esc>", { noremap = true, silent = true, mode = "i" })
map("kj", "<esc>", { noremap = true, silent = true, mode = "i" })

-- better up/down
map("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, mode = { "n", "x" } })
map("<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, mode = { "n", "x" } })
map("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, mode = { "n", "x" } })
map("<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, mode = { "n", "x" } })

-- Move to window using the <ctrl> hjkl keys
map("<C-h>", "<C-w>h", { desc = "Go to left window", remap = true, mode = "n" })
map("<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true, mode = "n" })
map("<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true, mode = "n" })
map("<C-l>", "<C-w>l", { desc = "Go to right window", remap = true, mode = "n" })

-- Resize window using <ctrl> arrow keys
map("<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height", mode = "n" })
map("<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height", mode = "n" })
map("<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width", mode = "n" })
map("<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width", mode = "n" })

-- Move Lines
map("<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down", mode = "n" })
map("<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up", mode = "n" })
map("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down", mode = "i" })
map("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up", mode = "i" })
map("<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down", mode = "v" })
map("<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up", mode = "v" })

-- buffers
map("<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer", mode = "n" })
map("<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer", mode = "n" })
map("[b", "<cmd>bprevious<cr>", { desc = "Prev buffer", mode = "n" })
map("]b", "<cmd>bnext<cr>", { desc = "Next buffer", mode = "n" })
map("<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer", mode = "n" })
map("<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer", mode = "n" })

-- Clear search with <esc>
map("<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch", mode = { "i", "n" } })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update", mode = "n" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result", mode = "n" })
map("n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result", mode = "x" })
map("n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result", mode = "o" })
map("N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result", mode = "n" })
map("N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result", mode = "x" })
map("N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result", mode = "o" })

-- Add undo break-points
map(",", ",<c-g>u", { mode = "i" })
map(".", ".<c-g>u", { mode = "i" })
map(";", ";<c-g>u", { mode = "i" })

-- save file
map("<C-s>", "<cmd>w<cr><esc>", { desc = "Save file", mode = { "i", "x", "n", "s" } })

--keywordprg
map("<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg", mode = "n" })

-- better indenting
map("<", "<gv", { mode = "v" })
map(">", ">gv", { mode = "v" })

-- new file
map("<leader>fn", "<cmd>enew<cr>", { desc = "New File", mode = "n" })

map("<leader>xl", "<cmd>lopen<cr>", { desc = "Location List", mode = "n" })
map("<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List", mode = "n" })

map("[q", vim.cmd.cprev, { desc = "Previous quickfix", mode = "n" })
map("]q", vim.cmd.cnext, { desc = "Next quickfix", mode = "n" })

-- formatting
-- map({ "n", "v" }, "<leader>cf", function()
--   Util.format({ force = true })
-- end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics", mode = "n" })
map("]d", diagnostic_goto(true), { desc = "Next Diagnostic", mode = "n" })
map("[d", diagnostic_goto(false), { desc = "Prev Diagnostic", mode = "n" })
map("]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error", mode = "n" })
map("[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error", mode = "n" })
map("]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning", mode = "n" })
map("[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning", mode = "n" })

-- stylua: ignore start

-- toggle options
-- map("n", "<leader>uf", function() Util.format.toggle() end, { desc = "Toggle auto format (global)" })
-- map("n", "<leader>uF", function() Util.format.toggle(true) end, { desc = "Toggle auto format (buffer)" })
-- map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
-- map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
-- map("n", "<leader>uL", function() Util.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
-- map("n", "<leader>ul", function() Util.toggle.number() end, { desc = "Toggle Line Numbers" })
-- map("n", "<leader>ud", function() Util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
-- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
-- map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
-- if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
--   map( "n", "<leader>uh", function() Util.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
-- end
-- map("n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })

-- lazygit
-- map("n", "<leader>gg", function() Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (root dir)" })
-- map("n", "<leader>gG", function() Util.terminal({ "lazygit" }, {esc_esc = false, ctrl_hjkl = false}) end, { desc = "Lazygit (cwd)" })

-- quit
map("<leader>qq", "<cmd>qa<cr>", { desc = "Quit all", mode = "n" })

-- highlights under cursor
map("<leader>ui", vim.show_pos, { desc = "Inspect Pos", mode = "n" })

-- LazyVim Changelog
-- map("n", "<leader>L", function() Util.news.changelog() end, { desc = "LazyVim Changelog" })

-- floating terminal
-- local lazyterm = function() Util.terminal(nil, { cwd = Util.root() }) end
-- map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
-- map("n", "<leader>fT", function() Util.terminal() end, { desc = "Terminal (cwd)" })
-- map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
-- map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
map("<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode", mode = "t" })
map("<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window", mode = "t" })
map("<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window", mode = "t" })
map("<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window", mode = "t" })
map("<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window", mode = "t" })
map("<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal", mode = "t" })
map("<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore", mode = "t" })

-- windows
map("<leader>ww", "<C-W>p", { desc = "Other window", remap = true, mode = "n" })
map("<leader>wd", "<C-W>c", { desc = "Delete window", remap = true, mode = "n" })
map("<leader>w-", "<C-W>s", { desc = "Split window below", remap = true, mode = "n" })
map("<leader>w|", "<C-W>v", { desc = "Split window right", remap = true, mode = "n" })
map("<leader>-", "<C-W>s", { desc = "Split window below", remap = true, mode = "n" })
map("<leader>|", "<C-W>v", { desc = "Split window right", remap = true, mode = "n" })

-- tabs
map("<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab", mode = "n" })
map("<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab", mode = "n" })
map("<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab", mode = "n" })
map("<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab", mode = "n" })
map("<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab", mode = "n" })
map("<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab", mode = "n" })
