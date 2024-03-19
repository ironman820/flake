{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.home.pass;
in {
  options.mine.home.pass = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home.sops.secrets.gpg-id = {
      mode = "0400";
      path = "${config.home.homeDirectory}/.local/share/password-store/.gpg-id";
      sopsFile = ./secrets/pass.yml;
    };
    programs.password-store = enabled;
  };
}
