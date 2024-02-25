{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) float nullOr str;
  cfg = config.mine.home.user;
  home-directory =
    if cfg.name == null
    then null
    else "/home/${cfg.name}";
  osSettings = osConfig.mine.user.settings;
in {
  options.mine.home.user = {
    enable = mkBoolOpt true "Enable user's home manager";
    email = mkOpt str "29488820+ironman820@users.noreply.github.com" "User email";
    fullName = mkOpt str "Nicholas Eastman" "Full Name";
    homeDirectory = mkOpt (nullOr str) home-directory "The user's home directory";
    name = mkOpt (nullOr str) config.snowfallorg.user.name "User Name";
    settings = {
      browser = mkOpt str "floorp" "Default browser";
      fileManager = mkOpt str "yazi" "Default file manager";
      terminal = mkOpt str "alacritty" "Default terminal application";
      applicationOpacity = mkOpt float osSettings.applicationOpacity "Default application opacity";
      desktopOpacity = mkOpt float osSettings.desktopOpacity "Default desktop opacity";
      inactiveOpacity = mkOpt float osSettings.inactiveOpacity "Default inactive opacity";
    };
  };

  config = mkIf cfg.enable {
    home = {
      inherit (cfg) homeDirectory;
      username = cfg.name;
    };
  };
}
