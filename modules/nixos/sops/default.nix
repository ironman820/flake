{ config, lib, options, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.sops;
in
{
  options.ironman.sops = with types; {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs { } "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default SOPS file path.";
    secrets = mkOpt attrs { } "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    ironman.sops = {
      age = {
        keyFile = "/etc/nixos/keys.txt";
        sshKeyPaths = [];
      };
      secrets = {
        authorized_keys = {
          sopsFile = ./secrets/keys.yaml;
          mode = "0400";
          path = "/home/${config.ironman.user.name}/.ssh/authorized_keys";
          owner = config.ironman.user.name;
          group = config.users.groups.users.name;
        };
      };
    };
    sops = {
      age = mkAliasDefinitions options.ironman.sops.age;
      defaultSopsFile = mkAliasDefinitions options.ironman.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [];
      secrets = mkAliasDefinitions options.ironman.sops.secrets;
    };
  };
}
