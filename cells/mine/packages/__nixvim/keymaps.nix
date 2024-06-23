{
  keymaps = [
    {
      key = "q";
      action = "<Nop>";
    }
    {
      key = "jk";
      action = "<esc>";
      options = {
        noremap = true;
        silent = true;
      };
      mode = "i";
    }
    {
      key = "kj";
      action = "<esc>";
      options = {
        noremap = true;
        silent = true;
      };
      mode = "i";
    }
    # better up/down
    {
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
      mode = [
        "n"
        "x"
      ];
    }
    {
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
      mode = [
        "n"
        "x"
      ];
    }
    {
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
      mode = [
        "n"
        "x"
      ];
    }
    {
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
      mode = [
        "n"
        "x"
      ];
    }
    # Move to window using the <ctrl> hjkl keys
    {
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "Go to left window";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "Go to lower window";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "Go to upper window";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "Go to right window";
        remap = true;
      };
      mode = "n";
    }
    # Resize window using <ctrl> arrow keys
    {
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options = {
        desc = "Increase window height";
      };
      mode = "n";
    }
    {
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options = {
        desc = "Decrease window height";
      };
      mode = "n";
    }
    {
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options = {
        desc = "Decrease window width";
      };
      mode = "n";
    }
    {
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options = {
        desc = "Increase window width";
      };
      mode = "n";
    }
    # Move Lines
    {
      key = "<A-j>";
      action = "<cmd>m .+1<cr>==";
      options = {
        desc = "Move down";
      };
      mode = "n";
    }
    {
      key = "<A-k>";
      action = "<cmd>m .-2<cr>==";
      options = {
        desc = "Move up";
      };
      mode = "n";
    }
    {
      key = "<A-j>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options = {
        desc = "Move down";
      };
      mode = "i";
    }
    {
      key = "<A-k>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options = {
        desc = "Move up";
      };
      mode = "i";
    }
    {
      key = "<A-j>";
      action = ":m '>+1<cr>gv=gv";
      options = {
        desc = "Move down";
      };
      mode = "v";
    }
    {
      key = "<A-k>";
      action = ":m '<-2<cr>gv=gv";
      options = {
        desc = "Move up";
      };
      mode = "v";
    }
    # buffers
    {
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options = {
        desc = "Prev buffer";
      };
      mode = "n";
    }
    {
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options = {
        desc = "Next buffer";
      };
      mode = "n";
    }
    {
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options = {
        desc = "Prev buffer";
      };
      mode = "n";
    }
    {
      key = "]b";
      action = "<cmd>bnext<cr>";
      options = {
        desc = "Next buffer";
      };
      mode = "n";
    }
    {
      key = "<leader>bb";
      action = "<cmd>e #<cr>";
      options = {
        desc = "Switch to Other Buffer";
      };
      mode = "n";
    }
    {
      key = "<leader>`";
      action = "<cmd>e #<cr>";
      options = {
        desc = "Switch to Other Buffer";
      };
      mode = "n";
    }
    # Clear search with <esc>
    {
      key = "<esc>";
      action = "<cmd>noh<cr><esc>";
      options = {
        desc = "Escape and clear hlsearch";
      };
      mode = [
        "i"
        "n"
      ];
    }
    # Clear search, diff update and redraw
    # taken from runtime/lua/_editor.lua
    {
      key = "<leader>ur";
      action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
      options.desc = "Redraw / clear hlsearch / diff update";
      mode = ["n"];
    }
    # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
    {
      key = "n";
      action = "'Nn'[v:searchforward].'zv'";
      options = {
        expr = true;
        desc = "Next search result";
      };
      mode = "n";
    }
    {
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next search result";
      };
      mode = "x";
    }
    {
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next search result";
      };
      mode = "o";
    }
    {
      key = "N";
      action = "'nN'[v:searchforward].'zv'";
      options = {
        expr = true;
        desc = "Prev search result";
      };
      mode = "n";
    }
    {
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev search result";
      };
      mode = "x";
    }
    {
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev search result";
      };
      mode = "o";
    }
    # Add undo break-points
    {
      key = ",";
      action = ",<c-g>u";
      mode = [
        "i"
      ];
    }
    {
      key = ".";
      action = ".<c-g>u";
      mode = [
        "i"
      ];
    }
    {
      key = ";";
      action = ";<c-g>u";
      mode = [
        "i"
      ];
    }
    # save file
    {
      key = "<C-s>";
      action = "<cmd>w<cr><esc>";
      options = {
        desc = "Save file";
      };
      mode = [
        "i"
        "x"
        "n"
        "s"
      ];
    }
    #keywordprg
    {
      key = "<leader>K";
      action = "<cmd>norm! K<cr>";
      options = {
        desc = "Keywordprg";
      };
      mode = "n";
    }
    # better indenting
    {
      key = "<";
      action = "<gv";
      mode = [
        "v"
      ];
    }
    {
      key = ">";
      action = ">gv";
      mode = [
        "v"
      ];
    }
    # new file
    {
      key = "<leader>fn";
      action = "<cmd>enew<cr>";
      options = {
        desc = "New File";
      };
      mode = "n";
    }
    {
      key = "<leader>xl";
      action = "<cmd>lopen<cr>";
      options = {
        desc = "Location List";
      };
      mode = "n";
    }
    {
      key = "<leader>xq";
      action = "<cmd>copen<cr>";
      options = {
        desc = "Quickfix List";
      };
      mode = "n";
    }
    {
      key = "[q";
      action = {
        __raw = "vim.cmd.cprev";
      };
      options.desc = "Previous quickfix";
      mode = [
        "n"
      ];
    }
    {
      key = "]q";
      action = {
        __raw = "vim.cmd.cnext";
      };
      options.desc = "Next quickfix";
      mode = [
        "n"
      ];
    }
    # formatting
    # map({ "n", "v" }, "<leader>cf", function()
    #   Util.format({ force = true })
    # end, { desc = "Format" })
    # diagnostic
    {
      key = "<leader>cd";
      action = {
        __raw = "vim.diagnostic.open_float";
      };
      options.desc = "Line Diagnostics";
      mode = [
        "n"
      ];
    }
    # stylua: ignore start
    # toggle options
    # map("n", "<leader>uf", function() Util.format.toggle() end, { desc = "Toggle auto format (global)" })
    # map("n", "<leader>uF", function() Util.format.toggle(true) end, { desc = "Toggle auto format (buffer)" })
    # map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
    # map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
    # map("n", "<leader>uL", function() Util.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
    # map("n", "<leader>ul", function() Util.toggle.number() end, { desc = "Toggle Line Numbers" })
    # map("n", "<leader>ud", function() Util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
    # local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
    # map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
    # if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
    #   map( "n", "<leader>uh", function() Util.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
    # end
    # map("n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })
    # lazygit
    # map("n", "<leader>gg", function() Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (root dir)" })
    # map("n", "<leader>gG", function() Util.terminal({ "lazygit" }, {esc_esc = false, ctrl_hjkl = false}) end, { desc = "Lazygit (cwd)" })
    # quit
    {
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options = {
        desc = "Quit all";
      };
      mode = "n";
    }
    # highlights under cursor
    {
      key = "<leader>ui";
      action = {
        __raw = "vim.show_pos";
      };
      options.desc = "Inspect Pos";
      mode = [
        "n"
      ];
    }
    # LazyVim Changelog
    # map("n", "<leader>L", function() Util.news.changelog() end, { desc = "LazyVim Changelog" })
    # floating terminal
    # local lazyterm = function() Util.terminal(nil, { cwd = Util.root() }) end
    # map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
    # map("n", "<leader>fT", function() Util.terminal() end, { desc = "Terminal (cwd)" })
    # map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
    # map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })
    # Terminal Mappings
    {
      key = "<esc><esc>";
      action = "<c-\\><c-n>";
      options = {
        desc = "Enter Normal Mode";
      };
      mode = "t";
    }
    {
      key = "<C-h>";
      action = "<cmd>wincmd h<cr>";
      options = {
        desc = "Go to left window";
      };
      mode = "t";
    }
    {
      key = "<C-j>";
      action = "<cmd>wincmd j<cr>";
      options = {
        desc = "Go to lower window";
      };
      mode = "t";
    }
    {
      key = "<C-k>";
      action = "<cmd>wincmd k<cr>";
      options = {
        desc = "Go to upper window";
      };
      mode = "t";
    }
    {
      key = "<C-l>";
      action = "<cmd>wincmd l<cr>";
      options = {
        desc = "Go to right window";
      };
      mode = "t";
    }
    {
      key = "<C-/>";
      action = "<cmd>close<cr>";
      options = {
        desc = "Hide Terminal";
      };
      mode = "t";
    }
    {
      key = "<c-_>";
      action = "<cmd>close<cr>";
      options = {
        desc = "which_key_ignore";
      };
      mode = "t";
    }
    # windows
    {
      key = "<leader>ww";
      action = "<C-W>p";
      options = {
        desc = "Other window";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<leader>wd";
      action = "<C-W>c";
      options = {
        desc = "Delete window";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<leader>w-";
      action = "<C-W>s";
      options = {
        desc = "Split window below";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<leader>w|";
      action = "<C-W>v";
      options = {
        desc = "Split window right";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<leader>-";
      action = "<C-W>s";
      options = {
        desc = "Split window below";
        remap = true;
      };
      mode = "n";
    }
    {
      key = "<leader>|";
      action = "<C-W>v";
      options = {
        desc = "Split window right";
        remap = true;
      };
      mode = "n";
    }
    # tabs
    {
      key = "<leader><tab>l";
      action = "<cmd>tablast<cr>";
      options = {
        desc = "Last Tab";
      };
      mode = "n";
    }
    {
      key = "<leader><tab>f";
      action = "<cmd>tabfirst<cr>";
      options = {
        desc = "First Tab";
      };
      mode = "n";
    }
    {
      key = "<leader><tab><tab>";
      action = "<cmd>tabnew<cr>";
      options = {
        desc = "New Tab";
      };
      mode = "n";
    }
    {
      key = "<leader><tab>]";
      action = "<cmd>tabnext<cr>";
      options = {
        desc = "Next Tab";
      };
      mode = "n";
    }
    {
      key = "<leader><tab>d";
      action = "<cmd>tabclose<cr>";
      options = {
        desc = "Close Tab";
      };
      mode = "n";
    }
    {
      key = "<leader><tab>[";
      action = "<cmd>tabprevious<cr>";
      options = {
        desc = "Previous Tab";
      };
      mode = "n";
    }
  ];
}
