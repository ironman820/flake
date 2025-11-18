{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ripgrep
  ];
  programs.nixvim = {
    autoCmd = [
      {
        event = "FileType";
        desc = "Disable autocomment on enter";
        callback = {
          __raw = ''
            function()
              vim.opt.formatoptions:remove({ "c", "r", "o" })
            end
          '';
        };
      }
      {
        desc = "Highlight on yank";
        event = "TextYankPost";
        callback = {
          __raw = ''
            function()
              vim.hl.on_yank()
            end
          '';
        };
        group = "YankHighlight";
        pattern = "*";
      }
    ];
    autoGroups = {
      YankHighlight.clear = true;
    };
    colorscheme = "tokyonight";
    enableMan = true;
    extraConfigLua = ''
      vim.opt.cpoptions:append('I')
      vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
      vim.opt.timeoutlen = vim.g.vscode and 1000 or 300
      vim.cmd([[command! W w]])
      vim.cmd([[command! Wq wq]])
      vim.cmd([[command! WQ wq]])
      vim.cmd([[command! Q q]])
    '';
    extraPlugins = with pkgs.vimPlugins; [
      tokyonight-nvim
    ];
    globals = {
      depreciation_warnings = false;
      mapleader = " ";
      maplocalleader = " ";
      markdown_recommended_style = 0;
      netrw_liststyle = 0;
      netrw_banner = 0;
      root_spec = [
        "lsp"
        [
          ".git"
          "lua"
        ]
        "cwd"
      ];
      snacks_animate = true;
      trouble_lualine = true;
    };
    keymaps = [
      {
        action = "<cmd>nohlsearch<CR>";
        key = "<Esc>";
        mode = "n";
      }
      {
        action = "<Nop>";
        key = "q";
        mode = "n";
      }
      {
        action = "<cmd>noh<cr><esc>";
        key = "<esc>";
        mode = "n";
        options = {
          desc = "Escape and clear hlsearch";
        };
      }
      {
        action = ":m '>+1<CR>gv=gv";
        key = "J";
        mode = "v";
        options = {
          desc = "Moves Line Down";
        };
      }
      {
        action = ":m '<-2<CR>gv=gv";
        key = "K";
        mode = "v";
        options = {
          desc = "Moves Line Up";
        };
      }
      {
        action = "<C-d>zz";
        key = "<C-d>";
        mode = "n";
        options = {
          desc = "Scroll Down";
        };
      }
      {
        action = "<C-u>zz";
        key = "<C-u>";
        mode = "n";
        options = {
          desc = "Scroll Up";
        };
      }
      {
        action = "nzzzv";
        key = "n";
        mode = "n";
        options = {
          desc = "Next Search Result";
        };
      }
      {
        action = "Nzzzv";
        key = "N";
        mode = "n";
        options = {
          desc = "Previous Search Result";
        };
      }
      {
        mode = "n";
        key = "k";
        action = "v:count == 0 ? \"gk\" : \"k\"";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "j";
        action = "v:count == 0 ? \"gj\" : \"j\"";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        action = {
          __raw = "vim.diagnostic.goto_prev";
        };
        key = "[d";
        mode = "n";
        options = {
          desc = "Go to previous diagnostic message";
        };
      }
      {
        action = {
          __raw = "vim.diagnostic.goto_next";
        };
        key = "]d";
        mode = "n";
        options = {
          desc = "Go to next diagnostic message";
        };
      }
      {
        action = {
          __raw = "vim.diagnostic.open_float";
        };
        key = "<leader>e";
        mode = "n";
        options = {
          desc = "Open floating diagnostic message";
        };
      }
      {
        action = {
          __raw = "vim.diagnostic.setloclist";
        };
        key = "<leader>q";
        mode = "n";
        options = {
          desc = "Open diagnostics list";
        };
      }
      {
        action = "<esc>";
        key = "jk";
        mode = "i";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        action = "<esc>";
        key = "kj";
        mode = "i";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = [
          "v"
          "x"
          "n"
        ];
        key = "<leader>y";
        action = "\"+y";
        options = {
          noremap = true;
          silent = true;
          desc = "Yank to clipboard";
        };
      }
      {
        mode = [
          "n"
          "v"
          "x"
        ];
        key = "<leader>Y";
        action = "\"+yy";
        options = {
          noremap = true;
          silent = true;
          desc = "Yank line to clipboard";
        };
      }
      {
        mode = [
          "n"
          "v"
          "x"
        ];
        key = "<C-a>";
        action = "gg0vG$";
        options = {
          noremap = true;
          silent = true;
          desc = "Select all";
        };
      }
      {
        mode = [
          "n"
          "v"
          "x"
        ];
        key = "<leader>p";
        action = "\"+p";
        options = {
          noremap = true;
          silent = true;
          desc = "Paste from clipboard";
        };
      }
      {
        mode = "i";
        key = "<C-p>";
        action = "<C-r><C-p>+";
        options = {
          noremap = true;
          silent = true;
          desc = "Paste from clipboard from within insert mode";
        };
      }
      {
        mode = "x";
        key = "<leader>P";
        action = "\"_dP";
        options = {
          noremap = true;
          silent = true;
          desc = "Paste over selection without erasing unnamed register";
        };
      }
      {
        action = "<C-w>h";
        key = "<C-h>";
        mode = "n";
        options = {
          desc = "Go to left window";
          remap = true;
        };
      }
      {
        action = "<C-w>j";
        key = "<C-j>";
        mode = "n";
        options = {
          desc = "Go to lower window";
          remap = true;
        };
      }
      {
        action = "<C-w>k";
        key = "<C-k>";
        mode = "n";
        options = {
          desc = "Go to upper window";
          remap = true;
        };
      }
      {
        action = "<C-w>l";
        key = "<C-l>";
        mode = "n";
        options = {
          desc = "Go to right window";
          remap = true;
        };
      }
      {
        action = "<cmd>resize +2<cr>";
        key = "<C-Up>";
        mode = "n";
        options = {
          desc = "Increase window height";
        };
      }
      {
        action = "<cmd>resize -2<cr>";
        key = "<C-Down>";
        mode = "n";
        options = {
          desc = "Decrease window height";
        };
      }
      {
        action = "<cmd>vertical resize -2<cr>";
        key = "<C-Left>";
        mode = "n";
        options = {
          desc = "Decrease window width";
        };
      }
      {
        action = "<cmd>vertical resize +2<cr>";
        key = "<C-Right>";
        mode = "n";
        options = {
          desc = "Increase window width";
        };
      }
      {
        action = "<cmd>m .+1<cr>==";
        key = "<A-j>";
        mode = "n";
        options = {
          desc = "Move down";
        };
      }
      {
        action = "<cmd>m .-2<cr>==";
        key = "<A-k>";
        mode = "n";
        options = {
          desc = "Move up";
        };
      }
      {
        action = "<esc><cmd>m .+1<cr>==gi";
        key = "<A-j>";
        mode = "i";
        options = {
          desc = "Move down";
        };
      }
      {
        action = "<esc><cmd>m .-2<cr>==gi";
        key = "<A-k>";
        mode = "i";
        options = {
          desc = "Move up";
        };
      }
      {
        action = ":m '>+1<cr>gv=gv";
        key = "<A-j>";
        mode = "v";
        options = {
          desc = "Move down";
        };
      }
      {
        action = ":m '<-2<cr>gv=gv";
        key = "<A-k>";
        mode = "v";
        options = {
          desc = "Move up";
        };
      }
      {
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = {
          desc = "Save file";
        };
      }
      {
        action = "<gv";
        key = "<";
        mode = "v";
      }
      {
        action = ">gv";
        key = ">";
        mode = "v";
      }
      {
        action = "<cmd>Oil<CR>";
        key = "-";
        mode = "n";
        options = {
          noremap = true;
          desc = "Open parent directory";
        };
      }
      {
        action = "<cmd>Oil .<CR>";
        key = "<leader>-";
        mode = "n";
        options = {
          noremap = true;
          desc = "Open root directory";
        };
      }
      # Bufferline
      {
        action = "<Cmd>BufferLineTogglePin<CR>";
        key = "<leader>bp";
        mode = "n";
        options.desc = "Toggle pin";
      }
      {
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        key = "<leader>bP";
        mode = "n";
        options.desc = "Delete non-pinned buffers";
      }
      {
        action = "<Cmd>BufferLineCloseOthers<CR>";
        key = "<leader>bo";
        mode = "n";
        options.desc = "Delete other buffers";
      }
      {
        action = "<Cmd>BufferLineCloseRight<CR>";
        key = "<leader>br";
        mode = "n";
        options.desc = "Delete buffers to the right";
      }
      {
        action = "<Cmd>BufferLineCloseLeft<CR>";
        key = "<leader>bl";
        mode = "n";
        options.desc = "Delete buffers to the left";
      }
      {
        action = "<cmd>BufferLineCyclePrev<cr>";
        key = "<S-h>";
        mode = "n";
        options.desc = "Prev buffer";
      }
      {
        action = "<cmd>BufferLineCycleNext<cr>";
        key = "<S-l>";
        mode = "n";
        options.desc = "Next buffer";
      }
      {
        action = "<cmd>BufferLineCyclePrev<cr>";
        key = "[b";
        mode = "n";
        options.desc = "Prev buffer";
      }
      {
        action = "<cmd>BufferLineCycleNext<cr>";
        key = "]b";
        mode = "n";
        options.desc = "Next buffer";
      }
      # Mini-Bufremove
      {
        key = "<leader>bd";
        action.__raw = ''
          function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then   -- Yes
                vim.cmd.write()
                bd(0)
              elseif choice == 2 then   -- No
                bd(0, true)
              end
            else
              bd(0)
            end
          end
        '';
        mode = "n";
        options.desc = "Delete Buffer";
      }
      {
        key = "<leader>bD";
        action.__raw = ''
          function()
            require("mini.bufremove").delete(0, true)
          end
        '';
        mode = "n";
        options.desc = "Delete Buffer (Force)";
      }
    ];
    opts = {
      autowrite = true;
      breakindent = true;
      completeopt = "menu,menuone,noselect";
      confirm = true;
      cursorline = true;
      expandtab = true;
      fillchars = {
        foldopen = "";
        foldclose = "";
        fold = " ";
        foldsep = " ";
        diff = "╱";
        eob = " ";
      };
      foldlevel = 99;
      foldmethod = "indent";
      foldtext = "";
      formatoptions = "jcroqlnt";
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      hlsearch = true;
      ignorecase = true;
      inccommand = "nosplit";
      jumpoptions = "view";
      laststatus = 3;
      linebreak = true;
      list = true;
      listchars = {
        nbsp = "␣";
        tab = "» ";
        trail = "·";
      };
      mouse = "a";
      number = true;
      pumblend = 10;
      pumheight = 10;
      relativenumber = true;
      ruler = false;
      scrolloff = 10;
      sessionoptions = [
        "buffers"
        "curdir"
        "tabpages"
        "winsize"
        "help"
        "globals"
        "skiprtp"
        "folds"
      ];
      shiftround = true;
      shiftwidth = 2;
      smartcase = true;
      smartindent = true;
      showmode = false;
      sidescrolloff = 8;
      signcolumn = "yes";
      smoothscroll = true;
      spelllang = [ "en" ];
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      tabstop = 2;
      termguicolors = true;
      timeoutlen = 300;
      undofile = true;
      undolevels = 10000;
      updatetime = 250;
      virtualedit = "block";
      wildmode = "longest:full,full";
      winminwidth = 5;
    };
    plugins = {
      bufferline = {
        enable = true;
        settings.options = {
          close_command.__raw = ''
            function(n)
              require("mini.bufremove").delete(n, false)
            end
          '';
          right_mouse_command.__raw = ''
            function(n)
              require("mini.bufremove").delete(n, false)
            end
          '';
          diagnostics = "nvim_lsp";
          always_show_bufferline = true;
          diagnostics_indicator = ''
            function(_, _, diag)
              local icons = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " ",
              }
              local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                  .. (diag.warning and icons.Warn .. diag.warning or "")
              return vim.trim(ret)
            end
          '';
          offsets = [
            {
              filetype = "neo-tree";
              text = "Neo-tree";
              highlight = "Directory";
              text_align = "left";
            }
          ];
        };
      };
      mini-bufremove.enable = true;
      notify = {
        enable = true;
        settings = {
          max_height = {
            __raw = ''
              function()
                return math.floor(vim.o.lines * 0.75)
              end
            '';
          };
          max_width = {
            __raw = ''
              function()
                return math.floor(vim.o.columns * 0.75)
              end
            '';
          };
          on_open = {
            __raw = ''
              function(win)
                vim.api.nvim_win_set_config(win, { focusable = false })
              end
            '';
          };
          timeout = 3000;
        };
      };
      oil = {
        enable = true;
        settings = {
          columns = [
            "icon"
            "permissions"
            "size"
          ];
          default_file_explorer = true;
          view_options.show_hidden = true;
          win_options.signcolumn = "yes:2";
        };
      };
      oil-git-status.enable = true;
      snacks.enable = true;
      web-devicons.enable = true;
    };
    viAlias = true;
    vimAlias = true;
  };
}
