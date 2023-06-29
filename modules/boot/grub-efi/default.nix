{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.boot.grub-efi;
in {
  options.ironman.boot.grub-efi = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
          theme = pkgs.nixos-grub2-theme;
        };
        timeout = 2;
      };
    };
  };
}