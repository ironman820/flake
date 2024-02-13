{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.programs.nvim;
  initLua = ''
    require("startup")
  '';
  my_python = pkgs.python3.withPackages my_python_packages;
  my_python_packages = py: (with py; [autopep8 black debugpy isort mypy pylint pynvim]);
in {
  options.ironman.home.programs.nvim = {
    enable = mkBoolOpt true "Install NeoVim";
    extraLuaConfig = mkOpt lines initLua "Extra Config";
  };

  config = mkIf cfg.enable {
    home = {
      shellAliases = {
        "nano" = "nvim";
        "nv" = "nvim";
      };
    };
    programs = {
      neovim = mkIf cfg.enable {
        inherit (cfg) enable extraLuaConfig;
        defaultEditor = true;
        extraPackages =
          (with pkgs; [
            alejandra
            fd
            ripgrep
            tree-sitter
            xclip
            efm-langserver
            lua-language-server
            mercurial
            my_python
            pyright
            nil
            nixfmt
            statix
            stylua
            taplo-lsp
          ])
          ++ (with pkgs.luaPackages; [luacheck]);
        plugins = with pkgs.vimPlugins; [
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
          cmp-nerdfont
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
          trouble-nvim
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-ufo
          nvim-undotree
          nvim-web-devicons
          which-key-nvim
        ];
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        withRuby = false;
      };
    };
    xdg.configFile = {
      "nvim/lua".source = ./config/lua;
      "nvim/after/plugin".source = ./config/after/plugin;
    };
  };
}
