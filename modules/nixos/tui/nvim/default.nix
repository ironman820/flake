{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.tui.nvim;
in {
  options.mine.tui.nvim = {
    enable = mkBoolOpt true "Install NeoVim";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs; [
        alejandra
    #     fd
    #     ripgrep
    #     tree-sitter
    #     xclip
    #     efm-langserver
    #     lua-language-server
    #     mercurial
        nil
    #     nixfmt-classic
        statix
        stylua
    #     taplo-lsp
    #   ])
    #   ++ (with pkgs.luaPackages; [luacheck])
    #   ++ (with pkgs.vimPlugins; [
    #     aerial-nvim
    #     alpha-nvim
    #     barbecue-nvim
    #     bufferline-nvim
    #     catppuccin-nvim
    #     cloak-nvim
    #     conceal-nvim
    #     conform-nvim
    #     vim-dadbod
    #     vim-dadbod-completion
    #     vim-dadbod-ui
    #     nvim-dap
    #     nvim-dap-python
    #     nvim-dap-ui
    #     nvim-dap-virtual-text
    #     diffview-nvim
    #     dressing-nvim
    #     gitsigns-nvim
    #     hop-nvim
    #     vim-illuminate
    #     indent-blankline-nvim
    #     nvim-lint
    #     nvim-lspconfig
    #     lualine-nvim
    #     luasnip
    #     mini-nvim
    #     nvim-navic
    #     neoconf-nvim
    #     neodev-nvim
    #     neo-tree-nvim
    #     nvim-notify
    #     nui-nvim
    #     obsidian-nvim
    #     oil-nvim
    #     one-small-step-for-vimkind
    #     persistence-nvim
    #     plenary-nvim
    #     promise-async
    #     rainbow-delimiters-nvim
    #     nvim-spectre
    #     telescope-nvim
    #     telescope-fzf-native-nvim
    #     todo-comments-nvim
    #     nvim-treesitter.withAllGrammars
    #     nvim-treesitter-context
    #     nvim-treesitter-textobjects
    #     transparent-nvim
    #     trouble-nvim
    #     nvim-ts-autotag
    #     nvim-ts-context-commentstring
    #     nvim-ufo
    #     undotree
    #     nvim-web-devicons
    #     which-key-nvim
      ];
    programs.nvf = {
      inherit (cfg) enable;
      settings.vim = {
        autocomplete.blink-cmp = {
          enable = true;
          friendly-snippets = enabled;
          mappings = {
            next = "<C-j>";
            previous = "<C-k>";
            scrollDocsDown = "<C-d>";
            scrollDocsUp = "<C-u>";
          };
          sourcePlugins = {
            emoji = enabled;
            ripgrep = enabled;
            spell = enabled;
          };
        };
        autopairs.nvim-autopairs = enabled;
        binds = {
          cheatsheet = enabled;
          hardtime-nvim = enabled;
          whichKey = {
            enable = true;
            register = {
              c = "Git Conflict";
              d = "Debug";
            };
          };
        };
        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers.wl-copy = enabled;
        };
        comments.comment-nvim = enabled;
        dashboard.startify = {
          enable = true;
          changeToDir = false;
          changeToVCRoot = true;
        };
        debugger.nvim-dap = {
          enable = true;
          mappings = {
            goDown = "<leader>dj";
            goUp = "<leader>dk";
            hover = "<leader>dw";
            stepInto = "<leader>di";
            stepOut = "<leader>do";
            stepOver = "<leader>dO";
          };
          ui = enabled;
        };
        diagnostics = {
          enable = true;
          config = {
            update_in_insert = true;
            virtual_lines = true;
          };
          nvim-lint = {
            enable = true;
            linters_by_ft = {
              nix = ["statix"];
              python = ["pylint"];
            };
          };
        };
        formatter.conform-nvim = {
          enable = true;
          setupOpts = {
            formatters_by_ft = {
              lua = ["stylua"];
              nix = ["alejandra"];
              php = ["phpcbf" "phpcsfixer"];
              python = ["isort" "black"];
            };
          };
        };
        # globals.root_spec = ["lsp" [".git" "lua"] "cwd"];
        keymaps = [
          {
            key = "jk";
            mode = "i";
            action = "<esc>";
          }
          {
            key = "kj";
            mode = "i";
            action = "<esc>";
          }
        ];
        lineNumberMode = "relNumber";
        options = {
          # autowrite = true;
          # conceallevel = 2;
          confirm = true;
          expandtab = true;
          # foldlevel = 99;
          # formatoptions = "jcroqlnt";
          # grepformat = "%f:%l:%c:%m";
          # grepprg = "rg --vimgrep";
          # ignorecase = true;
          # inccommand = "nosplit";
          # laststatus = 3;
          # list = true;
          mouse = "a";
          # pumblend = 10;
          # pumheight = 10;
          scrolloff = 4;
          shiftround = true;
          shiftwidth = 2;
          # sidescrolloff = 8;
          # smartindent = true;
          # splitkeep = "screen";
          tabstop = 2;
          tm = 300;
          # undofile = true;
          # undolevels = 10000;
          updatetime = 200;
          # virtualedit = "block";
          # wildmode = "longest:full,full";
          # winminwidth = 5;
        };
        searchCase = "smart";
        spellcheck = {
          enable = true;
          languages = ["en"];
        };
        # ui.modes-nvim = {
        #   enable = true;
        #   setupOpts.setCursorline = true;
        # };
      };
    };
  };
}
