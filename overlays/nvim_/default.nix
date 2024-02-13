{ channels, ... }:
final: prev: {
  vimPlugins = prev.vimPlugins // {
    inherit (prev.ironman)
      cloak-nvim cmp-nerdfont conceal-nvim nvim-undotree obsidian-nvim
      one-small-step-for-vimkind yanky-nvim;
    inherit (channels.unstable.vimPlugins) efmls-configs-nvim;
    nvim-treesitter = channels.unstable.vimPlugins.nvim-treesitter // {
      inherit (channels.unstable.vimPlugins.nvim-treesitter) withAllGrammars;
    };
  };
}
