local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

    -- Normal --
-- Copy to global clipboard
opts.desc = "[Y]ank to Clipboard"
keymap("n", "<leader>y", "\"+y", opts)
keymap("v", "<leader>y", "\"+y", opts)

-- Overwrite no copy
opts.desc = "[P]aste without copying."
keymap("x", "<leader>p", "\"_dP", opts)

-- Delete no copy
opts.desc = "[D]elete without copying"
keymap("n", "<leader>d", "\"_d", opts)
keymap("v", "<leader>d", "\"_d", opts)
opts.desc = nil

-- Resize with arrows when using multiple windows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<c-down>", ":resize +2<cr>", opts)
keymap("n", "<c-right>", ":vertical resize -2<cr>", opts)
keymap("n", "<c-left>", ":vertical resize +2<cr>", opts)

-- navigate buffers
keymap("n", "<tab>", "<cmd>bnext<cr>", opts) -- Next Tab
keymap("n", "<s-tab>", "<cmd>bprevious<cr>", opts) -- Previous tab

-- move text up and down
keymap("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts) -- Alt-j
keymap("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts) -- Alt-k

-- insert --
-- press jk fast to exit insert mode
keymap("i", "jk", "<esc>", opts) -- Insert mode -> jk -> Normal mode
keymap("i", "kj", "<esc>", opts) -- Insert mode -> kj -> Normal mode

-- visual --
-- stay in indent mode
keymap("v", "<", "<gv", opts) -- Right Indentation
keymap("v", ">", ">gv", opts) -- Left Indentation

-- move text up and down
keymap("v", "<a-j>", ":m .+1<cr>==", opts)
keymap("v", "<a-k>", ":m .-2<cr>==", opts)

-- Visual Block --
-- Move text up and down
    --Terminal --
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

