{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) disabled enabled mkBoolOpt mkOpt;
  inherit (lib.types) str;
  cfg = config.ironman.gpg;
in
{
  options.ironman.gpg = {
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
