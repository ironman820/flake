{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.home.nix-index;
in
{
  options.mine.home.nix-index = {
    enable = mkBoolOpt true "Enable nix-index installation";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-index
    ];
  };
}
