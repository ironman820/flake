_: final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      inherit
        (prev.ironman)
        nvim-cmp-nerdfont
        conceal-nvim
        nvim-undotree
        one-small-step-for-vimkind
        ;
      nvim-treesitter =
        prev.vimPlugins.nvim-treesitter
        // {
          inherit (prev.vimPlugins.nvim-treesitter) withAllGrammars;
        };
    };
}
