{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.boot.plymouth;
in {
  options.ironman.boot.plymouth = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [
        pkgs.nixos-bgrt-plymouth
      ];
    };
  };
}