{
  cell,
  config,
  inputs,
  pkgs,
}: let
  p = inputs.cells.mine.packages;
in {
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
      p.nvim-cmp-nerdfont
      cmp-path
      cloak-nvim
      p.conceal-nvim
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
      p.one-small-step-for-vimkind
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
      p.nvim-undotree
      nvim-web-devicons
      which-key-nvim
    ]);
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withRuby = false;
  };
}
