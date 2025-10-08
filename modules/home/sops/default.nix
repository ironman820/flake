{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkAliasDefinitions
    mkDefault
    mkIf
    mkMerge
    ;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) attrs path;
  cfg = config.mine.home.sops;
  mode = "0400";
in
{
  options.mine.home.sops = {
    enable = mkBoolOpt true "Enable root secrets";
    secrets = mkOpt attrs { } "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    mine.home = {
      sops = {
        secrets = mkMerge [
          {
            yb_keys = {
              inherit mode;
              format = "binary";
              sopsFile = mkDefault ./secrets/yb_keys.sops;
              path = "${config.xdg.configHome}/Yubico/u2f_keys";
            };
          }
        ];
      };
    };
    sops = {
      age = {
        keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
        sshKeyPaths = [ ];
      };
      defaultSopsFile = ./secrets/keys.yaml;
      gnupg.sshKeyPaths = [ ];
      secrets = mkAliasDefinitions options.mine.home.sops.secrets;
    };
  };
}
