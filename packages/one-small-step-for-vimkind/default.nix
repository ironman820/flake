{ inputs, pkgs, ... }:
let inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin {
  name = "one-small-step-for-vimkind";
  src = inputs.one-small-step-for-vimkind;
}
