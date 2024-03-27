{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.btop;
in {
  options.mine.btop = {
    enable = mkBoolOpt true "Enable Btop package.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop
      catppuccin-btop
    ];
  };
}
