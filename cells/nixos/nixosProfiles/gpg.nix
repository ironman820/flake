{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) str;
  cfg = config.mine.gpg;
in {
  options.mine.gpg = {
    enable = mkEnableOption "Enable gpg";
    enableSSHSupport = mkBoolOpt false "Enable SSH support for GPG";
    pinentryFlavor = mkOpt str "curses" "GPG Agent pin-entry flavor";
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      inherit (cfg) enableSSHSupport pinentryFlavor;
      enable = true;
    };
  };
}
