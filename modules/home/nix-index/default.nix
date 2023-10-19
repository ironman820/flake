{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;
  cfg = config.ironman.home.nix-index;
in
{
  options.ironman.home.nix-index = {
    enable = mkBoolOpt true "Enable nix-index installation";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-index
    ];
  };
}
