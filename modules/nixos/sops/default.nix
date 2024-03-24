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
  imp = config.mine.impermanence.enable;
in {
  options.mine.sops = {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs {
      keyFile = "/etc/nixos/keys.txt";
      sshKeyPaths = [];
    } "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default SOPS file path.";
    secrets = mkOpt attrs {} "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    mine.sops.secrets.user_pass.neededForUsers = true;
    environment.persistence."/persist/root".files = mkIf imp [
      {
        file = "/etc/nixos/keys.txt";
        parentDirectory.mode = "u=r,g=,o=";
      }
    ];
    sops = {
      age = mkAliasDefinitions options.mine.sops.age;
      defaultSopsFile = mkAliasDefinitions options.mine.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [];
      secrets = mkAliasDefinitions options.mine.sops.secrets;
    };
  };
}
