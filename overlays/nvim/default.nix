{channels, ...}: final: prev: {
  inherit (channels.unstable) neovim;
  vimPlugins =
    channels.unstable.vimPlugins
    // {
      inherit
        (prev.mine)
        nvim-cmp-nerdfont
        conceal-nvim
        ;
      nvim-treesitter =
        channels.unstable.vimPlugins.nvim-treesitter
        // {
          inherit (channels.unstable.vimPlugins.nvim-treesitter) withAllGrammars;
        };
    };
}
