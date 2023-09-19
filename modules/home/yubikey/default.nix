{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.yubikey;
in
{
  options.ironman.home.yubikey = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
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
