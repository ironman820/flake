{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.yubikey;
in
{
  options.mine.home.yubikey = {
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
