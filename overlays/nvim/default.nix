{channels, ...}: final: prev: {
  inherit (channels.unstable) neovim;
  vimPlugins =
    channels.unstable.vimPlugins
    // {
      inherit
        (prev.mine)
        nvim-cmp-nerdfont
        conceal-nvim
        nvim-undotree
        one-small-step-for-vimkind
        transparent-nvim
        ;
      nvim-treesitter =
        channels.unstable.vimPlugins.nvim-treesitter
        // {
          inherit (channels.unstable.vimPlugins.nvim-treesitter) withAllGrammars;
        };
    };
}
