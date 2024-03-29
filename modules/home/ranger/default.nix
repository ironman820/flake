{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.ranger;
in {
  options.mine.home.ranger = {
    enable = mkEnableOption "Enable the ranger file manager";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [bashmount file ranger trashy];
    xdg.configFile = {
      "ranger/commands.py".source = ./config/commands.py;
      "ranger/rc.conf".source = ./config/rc.conf;
      "ranger/rifle.conf".source = ./config/rifle.conf;
      "ranger/scope.sh".source = ./config/scope.sh;
      "ranger/plugins/ranger_devicons".source = pkgs.ranger-devicons;
    };
  };
}
