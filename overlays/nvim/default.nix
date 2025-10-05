{ inputs, ... }:
final: prev: {
  # inherit (inputs.neovim.packages.${prev.system}) nvim;
  nvim = inputs.neovim.packages.${prev.system}.nixCats;
}
