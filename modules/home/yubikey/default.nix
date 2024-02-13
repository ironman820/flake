{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.yubikey;
in
{
  options.ironman.home.yubikey = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yubioath-flutter
    ];
    programs.gpg = {
      scdaemonSettings = {
        reader-port = "Yubico";
        disable-ccid = true;
        pcsc-shared = true;
      };
    };
  };
}
