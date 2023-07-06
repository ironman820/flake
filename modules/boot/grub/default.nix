{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.boot.grub;
in {
  options.ironman.boot.grub = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      loader.grub = {
        efiSupport = true;
        device = "nodev";
        theme = pkgs.nixos-grub2-theme;
      };
      plymouth = {
        enable = true;
        theme = "nixos-bgrt";
        themePackages = [
          pkgs.nixos-bgrt-plymouth
        ];
      };
    };
  };
}
