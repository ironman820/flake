{ inputs, ... }:
final: prev: {
  nvim = inputs.neovim.packages.${prev.system}.nixCats;
}
