{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.tui.imapfilter;
in {
  options.mine.tui.imapfilter = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      imapfilter
    ];
  };
}
