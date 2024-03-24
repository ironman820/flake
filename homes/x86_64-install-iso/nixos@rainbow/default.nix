{lib, ...}: let
  inherit (lib.mine) disabled;
in {
  imports = [
    ../../x86_64-linux/modules.nix
  ];
  config.mine.home = {
    just = disabled;
    python = disabled;
    scripts = disabled;
    sops = disabled;
  };
}
