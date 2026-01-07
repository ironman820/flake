{ pkgs, ... }:
{
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
      {
        event = "User";
        group = "CodeCompanionFidget";
        pattern = "CodeCompanionRequestStarted";
        desc = "Inform user code companion is thinking";
        callback.__raw = ''
          function(e)
            handles[e.data.id] = progress.handle.create({
              title = "CodeCompanion",
              message = "Thinking...",
              lsp_client = { name = e.data.adapter.formatted_name },
            })
          end
        '';
      }
      {
        event = "User";
        group = "CodeCompanionFidget";
        pattern = "CodeCompanionRequestFinished";
        desc = "Inform user code companion is finished";
        callback.__raw = ''
          function(e)
            local h = handles[e.data.id]
            if h then
              h.message = e.data.status == "success" and "Done" or "Failed"
              h:finish()
              handles[e.data.id] = nil
            end
          end
        '';
      }
    ];
    autoGroups = {
      CodeCompanionFidget = { };
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
      local progress = require("fidget.progress")
      local handles = {}
    '';
    extraPackagesAfter = with pkgs; [
      fd
      file
      ghostscript
      imagemagick
      mermaid-cli
      nixfmt
      ripgrep
      tectonic
    ];
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
      {
        action = "<cmd>bprevious<cr>";
        key = "<S-h>";
        mode = "n";
        options.desc = "Prev buffer";
      }
      {
        action = "<cmd>bnext<cr>";
        key = "<S-l>";
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
      # noice
      {
        key = "<S-Enter>";
        action.__raw = ''
          function()
            require("noice").redirect(vim.fn.getcmdline())
          end
        '';
        options.desc = "Redirect Cmdline";
        mode = "c";
      }
      {
        key = "<leader>snl";
        action.__raw = ''
            function()
            require("noice").cmd("last")
          end
        '';
        options.desc = "Noice Last Message";
        mode = "n";
      }
      {
        key = "<leader>snh";
        action.__raw = ''
          function()
                require("noice").cmd("history")
              end
        '';
        mode = "n";
        options.desc = "Noice History";
      }
      {
        key = "<leader>sna";
        action.__raw = ''
          function()
                require("noice").cmd("all")
              end
        '';
        mode = "n";
        options.desc = "Noice All";
      }
      {
        key = "<leader>snd";
        action.__raw = ''
          function()
                require("noice").cmd("dismiss")
              end
        '';
        mode = "n";
        options.desc = "Dismiss All";
      }
      {
        key = "<c-f>";
        action.__raw = ''
          function()
                if not require("noice.lsp").scroll(4) then
                  return "<c-f>"
                end
              end
        '';
        mode = [
          "i"
          "n"
          "s"
        ];
        options = {
          silent = true;
          expr = true;
          desc = "Scroll forward";
        };
      }
      {
        key = "<c-b>";
        action.__raw = ''
          function()
                if not require("noice.lsp").scroll(-4) then
                  return "<c-b>"
                end
              end
        '';
        mode = [
          "i"
          "n"
          "s"
        ];
        options = {
          silent = true;
          expr = true;
          desc = "Scroll backward";
        };
      }
      # Snacks
      {
        key = "<leader>gg";
        action.__raw = ''
          function()
            Snacks.lazygit()
          end
        '';
        options.desc = "Lazygit";
      }
      {
        key = "<leader>n";
        action.__raw = ''
          function()
            if Snacks.config.picker and Snacks.config.picker.enabled then
              Snacks.picker.notifications()
            else
              Snacks.notifier.show_history()
            end
          end
        '';
        options.desc = "Notification History";
      }
      {
        key = "<leader>ud";
        action.__raw = ''
          function() Snacks.dim() end
        '';
        options.desc = "[D]im";
      }
      {
        key = "<leader>uD";
        action.__raw = ''
          function() Snacks.dim.disable() end
        '';
        options.desc = "[D]isable dim";
      }
      {
        key = "<leader>un";
        action.__raw = ''
          function() Snacks.notifier.hide() end
        '';
        options.desc = "Dismiss All Notifications";
      }
      {
        key = "<leader>z";
        action.__raw = ''
          function() Snacks.zen() end
        '';
        options.desc = "Toggle Zen Mode";
      }
      {
        key = "<leader>Z";
        action.__raw = ''
          function() Snacks.zen.zoom() end
        '';
        options.desc = "Toggle Zoom";
      }
      {
        mode = "n";
        key = "<Leader>;";
        action.__raw = "require('dropbar.api').pick";
        options.desc = "Pick symbols in winbar";
      }
      {
        mode = "n";
        key = "[;";
        action.__raw = "require('dropbar.api').goto_context_start";
        options.desc = "Go to start of current context";
      }
      {
        mode = "n";
        key = "];";
        action.__raw = "require('dropbar.api').select_next_context";
        options.desc = "Select next context";
      }
      {
        key = "<leader>cc";
        action = "<cmd>CloakToggle<cr>";
        mode = "n";
        options.desc = "Toggle cloak";
      }
      # Code Companion
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>CodeCompanionChat Toggle<cr>";
        options.desc = "[A]I Chat";
      }
      # Telescope
      {
        key = "<leader>sM";
        action = "<cmd>Telescope notify<CR>";
        mode = "n";
        options.desc = "[S]earch [M]essage";
      }
      {
        key = "<leader>sp";
        action.__raw = "live_grep_git_root";
        mode = "n";
        options.desc = "[S]earch git [P]roject root";
      }
      {
        key = "<leader>/";
        action.__raw = ''
          function()
            -- Slightly advanced example of overriding default behavior and theme
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
          end
        '';
        mode = "n";
        options.desc = "[/] Fuzzily search in current buffer";
      }
      {
        key = "<leader>s/";
        action.__raw = ''
          function()
            require('telescope.builtin').live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
            }
          end
        '';
        mode = "n";
        options.desc = "[S]earch [/] in Open Files";
      }
      {
        key = "<leader>bs";
        action.__raw = "function() return require('telescope.builtin').buffers() end";
        mode = "n";
        options.desc = "[ ] Find existing buffers";
      }
      {
        key = "<leader>s.";
        action.__raw = "function() return require('telescope.builtin').oldfiles() end";
        mode = "n";
        options.desc = "[S]earch Recent Files (\".\" for repeat)";
      }
      {
        key = "<leader>sr";
        action.__raw = "function() return require('telescope.builtin').resume() end";
        mode = "n";
        options.desc = "[S]earch [R]esume";
      }
      {
        key = "<leader>sd";
        action.__raw = "function() return require('telescope.builtin').diagnostics() end";
        mode = "n";
        options.desc = "[S]earch [D]iagnostics";
      }
      {
        key = "<leader>sg";
        action.__raw = "function() return require('telescope.builtin').live_grep() end";
        mode = "n";
        options.desc = "[S]earch by [G]rep";
      }
      {
        key = "<leader>sw";
        action.__raw = "function() return require('telescope.builtin').grep_string() end";
        mode = "n";
        options.desc = "[S]earch current [W]ord";
      }
      {
        key = "<leader>ss";
        action.__raw = "function() return require('telescope.builtin').builtin() end";
        mode = "n";
        options.desc = "[S]earch [S]elect Telescope";
      }
      {
        key = "<leader>sf";
        action.__raw = "function() return require('telescope.builtin').find_files() end";
        mode = "n";
        options.desc = "[S]earch [F]iles";
      }
      {
        key = "<leader>sk";
        action.__raw = "function() return require('telescope.builtin').keymaps() end";
        mode = "n";
        options.desc = "[S]earch [K]eymaps";
      }
      {
        key = "<leader>sh";
        action.__raw = "function() return require('telescope.builtin').help_tags() end";
        mode = "n";
        options.desc = "[S]earch [H]elp";
      }
      # Conform Formatter
      {
        key = "<leader>FF";
        action.__raw = "function() return require('conform').format() end";
        mode = "n";
        options.desc = "[F]ormat Buffer";
      }
      {
        key = "<leader>cs";
        action = "<cmd>AerialToggle<CR>";
        mode = "n";
        options.desc = "Toggle [S]ymbols Panel";
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
      aerial.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          cmdline = {
            enabled = true;
            completion.menu.auto_show = true;
            sources.__raw = ''
              function()
                local type = vim.fn.getcmdtype()
                -- Search forward and backward
                if type == '/' or type == '?' then return { 'buffer' } end
                -- Commands
                if type == ':' or type == '@' then return { 'cmdline', 'cmp_cmdline' } end
                return {}
              end
            '';
          };
          completion = {
            menu.draw = {
              treesitter = [ "lsp" ];
              components = {
                label = {
                  text.__raw = ''
                    function(ctx)
                      return require("colorful-menu").blink_components_text(ctx)
                    end
                  '';
                  highlight.__raw = ''
                    function(ctx)
                      return require("colorful-menu").blink_components_highlight(ctx)
                    end
                  '';
                };
              };
            };
            documentation.auto_show = true;
          };
          fuzzy.sorts = [
            "exact"
            "score"
            "sort_text"
          ];
          keymap = {
            preset = "default";
            "<CR>" = [
              "select_and_accept"
              "fallback"
            ];
            "<C-k>" = [
              "select_prev"
              "fallback_to_mappings"
            ];
            "<C-j>" = [
              "select_next"
              "fallback_to_mappings"
            ];
          };
          signature.enabled = true;
          snippets.active.__raw = ''
            function(filter)
              local snippet = require "luasnip"
              local blink = require "blink.cmp"
              if snippet.in_snippet() and not blink.is_visible() then
                return true
              else
                if not snippet.in_snippet() and vim.fn.mode() == "n" then snippet.unlink_current() end
                return false
              end
            end
          '';
          sources = {
            default = [
              "lsp"
              "lazydev"
              "path"
              "snippets"
              "buffer"
              "omni"
            ];
            providers = {
              path = {
                score_offset = 50;
              };
              lazydev = {
                name = "LazyDev";
                module = "lazydev.integrations.blink";
                score_offset = 100;
              };
              lsp = {
                score_offset = 40;
              };
              snippets = {
                score_offset = 40;
              };
              cmp_cmdline = {
                name = "cmp_cmdline";
                module = "blink.compat.source";
                score_offset = -100;
                opts = {
                  cmp_name = "cmdline";
                };
              };
            };
          };
        };
      };
      blink-compat.enable = true;
      cloak.enable = true;
      cmp-cmdline.enable = true;
      codecompanion = {
        enable = true;
        settings = {
          adapters.http.qwen3.__raw = ''
            function ()
              return require("codecompanion.adapters").extend("ollama", {
                name = "qwen3",
                env = {
                  url = "http://192.168.21.98:11434",
                  api_key = "OLLAMA_API_KEY",
                },
                headers = {
                  ["Content-Type"] = "application/json",
                  ["Authorization"] = "Bearer ''${api_key}",
                },
                parameters = {
                  sync = true,
                },
              })
            end
          '';
          opts = {
            # log_level = "TRACE";
            send_code = true;
            use_default_actions = true;
            use_default_prompts = true;
          };
          strategies = {
            agent.adapter = "qwen3";
            chat.adapter = "qwen3";
            inline.adapter = "qwen3";
          };
        };
      };
      colorful-menu.enable = true;
      conform-nvim = {
        enable = true;
        settings.formatters_by_ft.nix = [ "nixfmt" ];
      };
      dropbar.enable = true;
      fidget.enable = true;
      gitsigns = {
        enable = true;
        luaConfig.post = ''
          vim.cmd([[hi GitSignsAdd guifg=#04de21]])
          vim.cmd([[hi GitSignsChange guifg=#83fce6]])
          vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
        '';
        settings = {
          signs = {
            add.text = "+";
            change.text = "~";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
          };
          on_attach = ''
            function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map({ 'n', 'v' }, ']c', function()
                if vim.wo.diff then
                  return ']c'
                end
                vim.schedule(function()
                  gs.next_hunk()
                end)
                return '<Ignore>'
              end, { expr = true, desc = 'Jump to next hunk' })

              map({ 'n', 'v' }, '[c', function()
                if vim.wo.diff then
                  return '[c'
                end
                vim.schedule(function()
                  gs.prev_hunk()
                end)
                return '<Ignore>'
              end, { expr = true, desc = 'Jump to previous hunk' })

              -- Actions
              -- visual mode
              map('v', '<leader>hs', function()
                gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
              end, { desc = 'stage git hunk' })
              map('v', '<leader>hr', function()
                gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
              end, { desc = 'reset git hunk' })
              -- normal mode
              map('n', '<leader>gs', gs.stage_hunk, { desc = 'git stage hunk' })
              map('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
              map('n', '<leader>gS', gs.stage_buffer, { desc = 'git Stage buffer' })
              map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
              map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset buffer' })
              map('n', '<leader>gp', gs.preview_hunk, { desc = 'preview git hunk' })
              map('n', '<leader>gb', function()
                gs.blame_line { full = false }
              end, { desc = 'git blame line' })
              map('n', '<leader>gd', gs.diffthis, { desc = 'git diff against index' })
              map('n', '<leader>gD', function()
                gs.diffthis '~'
              end, { desc = 'git diff against last commit' })

              -- Toggles
              map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
              map('n', '<leader>gtd', gs.toggle_deleted, { desc = 'toggle git show deleted' })

              -- Text object
              map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
            end
          '';
        };
      };
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
            tab_char = "│";
          };
          scope = {
            enabled = true;
          };
          exclude.filetypes = [
            "help"
            "alpha"
            "dashboard"
            "neo-tree"
            "Trouble"
            "trouble"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "lazyterm"
          ];
        };
      };
      lazydev.enable = true;
      lint.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          psalm.enable = true;
          pyright.enable = true;
        };
      };
      luasnip = {
        enable = true;
        fromVscode = [
          { }
        ];
      };
      mini = {
        enable = true;
        modules = {
          ai = {};
          align = {};
          bufremove = {};
          comment = {};
          cursorword = {};
          diff = {};
          git = {};
          icons = {};
          pairs = {};
          statusline = {};
          surround = {};
          tabline = {};
        };
      };
      noice = {
        enable = true;
        settings = {
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
          };
          routes = [
            {
              filter = {
                event = "msg_show";
                any = [
                  { find = "%d+L, %d+B"; }
                  { find = "; after #%d+"; }
                  { find = "; before #%d+"; }
                ];
              };
              view = "mini";
            }
          ];
        };
      };
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
      nvim-surround.enable = true;
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
      snacks = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          dim.enabled = true;
          image.enabled = true;
          indent.enabled = true;
          input.enabled = true;
          lazygit.enabled = true;
          notifier.enabled = true;
          scope.enabled = true;
          scroll.enabled = true;
          statuscolumn.enabled = false;
          words.enabled = true;
          zen.enabled = true;
        };
      };
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        luaConfig = {
          pre = ''
            local function find_git_root()
              -- Use the current buffer's path as the starting point for the git search
              local current_file = vim.api.nvim_buf_get_name(0)
              local current_dir
              local cwd = vim.fn.getcwd()
              -- If the buffer is not associated with a file, return nil
              if current_file == "" then
                current_dir = cwd
              else
                -- Extract the directory from the current file's path
                current_dir = vim.fn.fnamemodify(current_file, ":h")
              end

              -- Find the Git root directory from the current file's path
              local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
              if vim.v.shell_error ~= 0 then
                print("Not a git repository. Searching on current working directory")
                return cwd
              end
              return git_root
            end

            -- Custom live_grep function to search in git root
            local function live_grep_git_root()
              local git_root = find_git_root()
              if git_root then
                require('telescope.builtin').live_grep({
                  search_dirs = { git_root },
                })
              end
            end
          '';
          post = ''
            vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
          '';
        };
        settings = {
          defaults.mappings.i."<c-enter>" = "to_fuzzy_refine";
        };
      };
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = false;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<c-space>";
              node_incremental = "<c-space>";
              scope_incremental = "<c-s>";
              node_decremental = "<M-space>";
            };
          };
        };
      };
      web-devicons.enable = true;
      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed = "<leader>b";
            group = "[b]uffer";
          }
          {
            __unkeyed = "<leader><leader>_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>c";
            group = "[c]ode";
          }
          {
            __unkeyed = "<leader>c_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>d";
            group = "[d]ocument";
          }
          {
            __unkeyed = "<leader>d_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>F";
            group = "[F]ormat";
          }
          {
            __unkeyed = "<leader>g";
            group = "[g]it";
          }
          {
            __unkeyed = "<leader>g_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>m";
            group = "[m]arkdown";
          }
          {
            __unkeyed = "<leader>m_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>r";
            group = "[r]ename";
          }
          {
            __unkeyed = "<leader>r_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>s";
            group = "[s]earch";
          }
          {
            __unkeyed = "<leader>s_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>t";
            group = "[t]oggles";
          }
          {
            __unkeyed = "<leader>t_";
            hidden = true;
          }
          {
            __unkeyed = "<leader>w";
            group = "[w]orkspace";
          }
          {
            __unkeyed = "<leader>w_";
            hidden = true;
          }
        ];
      };
    };
    viAlias = true;
    vimAlias = true;
  };
}
