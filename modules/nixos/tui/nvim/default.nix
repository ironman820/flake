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
      (with pkgs; [
        alejandra
        fd
        ripgrep
        tree-sitter
        xclip
        efm-langserver
        lua-language-server
        mercurial
        pyright
        nil
        nixfmt-classic
        statix
        stylua
        taplo-lsp
      ])
      ++ (with pkgs.luaPackages; [luacheck])
      ++ (with pkgs.vimPlugins; [
        aerial-nvim
        alpha-nvim
        barbecue-nvim
        bufferline-nvim
        catppuccin-nvim
        nvim-cmp
        cmp-buffer
        cmp-cmdline
        cmp-git
        cmp-nvim-lsp
        cmp_luasnip
        nvim-cmp-nerdfont
        cmp-path
        cloak-nvim
        conceal-nvim
        conform-nvim
        vim-dadbod
        vim-dadbod-completion
        vim-dadbod-ui
        nvim-dap
        nvim-dap-python
        nvim-dap-ui
        nvim-dap-virtual-text
        diffview-nvim
        dressing-nvim
        friendly-snippets
        # git-worktree-nvim
        gitsigns-nvim
        hop-nvim
        vim-illuminate
        indent-blankline-nvim
        # lazygit-nvim
        nvim-lint
        nvim-lspconfig
        lualine-nvim
        luasnip
        mini-nvim
        nvim-navic
        neoconf-nvim
        neodev-nvim
        # neogit
        neo-tree-nvim
        # noice-nvim
        nvim-notify
        nui-nvim
        obsidian-nvim
        oil-nvim
        one-small-step-for-vimkind
        persistence-nvim
        plenary-nvim
        promise-async
        rainbow-delimiters-nvim
        nvim-spectre
        telescope-nvim
        telescope-fzf-native-nvim
        todo-comments-nvim
        nvim-treesitter.withAllGrammars
        nvim-treesitter-context
        nvim-treesitter-textobjects
        transparent-nvim
        trouble-nvim
        nvim-ts-autotag
        nvim-ts-context-commentstring
        nvim-ufo
        undotree
        nvim-web-devicons
        which-key-nvim
      ]);
    programs.nvf = {
      inherit (cfg) enable;
      settings.vim = {
        autocomplete.nvim-cmp = enabled;
        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers.wl-copy = enabled;
        };
        globals.root_spec = ["lsp" [".git" "lua"] "cwd"];
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
          autowrite = true;
          conceallevel = 2;
          confirm = true;
          expandtab = true;
          foldlevel = 99;
          formatoptions = "jcroqlnt";
          grepformat = "%f:%l:%c:%m";
          grepprg = "rg --vimgrep";
          ignorecase = true;
          inccommand = "nosplit";
          laststatus = 3;
          list = true;
          mouse = "a";
          pumblend = 10;
          pumheight = 10;
          scrolloff = 4;
          sessionoptions = ["buffers" "curdir" "tabpages" "winsize" "help" "globals" "skiprtp" "folds"];
          shiftround = true;
          shiftwidth = 2;
          sidescrolloff = 8;
          smartindent = true;
          splitkeep = "screen";
          tabstop = 2;
          tm = 300;
          undofile = true;
          undolevels = 10000;
          updatetime = 200;
          virtualedit = "block";
          wildmode = "longest:full,full";
          winminwidth = 5;
          fillchars = {
            foldopen = "";
            foldclose = "";
            fold = " ";
            foldsep = " ";
            diff = "╱";
            eob = " ";
          };
        };
        searchCase = "smart";
        spellcheck = {
          enable = true;
          languages = ["en"];
        };
        ui.modes-nvim = {
          enable = true;
          setupOpts.setCursorline = true;
        };
      };
    };
  };
}
