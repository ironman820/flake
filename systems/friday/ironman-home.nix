{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.mine) enabled;
in
{
  home = {
    packages = with pkgs; [
      ffmpeg
      virt-manager
      yubioath-flutter
    ];
    sessionVariables = {
      BROWSER = config.mine.home.user.settings.applications.browser;
    };
    stateVersion = "25.05";
  };
  mine.home.kitty = enabled;
  programs.gpg = {
    scdaemonSettings = {
      reader-port = "Yubico";
      disable-ccid = true;
      pcsc-shared = true;
    };
  };
  services.udiskie = enabled // {
    tray = "never";
  };
}
