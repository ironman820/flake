{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.hardware.yubikey;
  os = osConfig.mine.hardware.yubikey;
in {
  options.mine.home.hardware.yubikey = {
    enable = mkBoolOpt os.enable "Enable the default settings?";
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
