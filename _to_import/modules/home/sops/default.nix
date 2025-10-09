{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkDefault mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) attrs path;
  cfg = config.mine.home.sops;
  mode = "0400";
in {
  options.mine.home.sops = {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs {
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      sshKeyPaths = [];
    } "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/keys.yaml "Default SOPS file path.";
    install = mkBoolOpt false "Install sops in home manager";
    secrets = mkOpt attrs {} "SOPS secrets.";
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
    home = {
      packages = mkIf cfg.install (with pkgs; [sops]);
    };
    sops = {
      age = mkAliasDefinitions options.mine.home.sops.age;
      defaultSopsFile =
        mkAliasDefinitions options.mine.home.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [];
      secrets = mkAliasDefinitions options.mine.home.sops.secrets;
    };
  };
}
