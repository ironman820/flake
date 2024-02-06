{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkIf mkAliasDefinitions;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) attrs path;
  cfg = config.mine.sops;
in {
  options.mine.sops = {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs {} "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default SOPS file path.";
    secrets = mkOpt attrs {} "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    mine.sops = {
      age = {
        keyFile = "/etc/nixos/keys.txt";
        sshKeyPaths = [];
      };
      secrets = {
        authorized_keys = {
          sopsFile = ./secrets/keys.yaml;
          mode = "0400";
          path = "/home/${config.mine.user.name}/.ssh/authorized_keys";
          owner = config.mine.user.name;
          group = config.users.groups.users.name;
        };
      };
    };
    sops = {
      age = mkAliasDefinitions options.mine.sops.age;
      defaultSopsFile = mkAliasDefinitions options.mine.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [];
      secrets = mkAliasDefinitions options.mine.sops.secrets;
    };
  };
}
