{ config, inputs, lib, options, pkgs, ... }:
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
    ironman.sops.age = {
      keyFile = "/etc/nixos/keys.txt";
      sshKeyPaths = [];
    };
    sops = {
      age = mkAliasDefinitions options.ironman.sops.age;
      defaultSopsFile = mkAliasDefinitions options.ironman.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [];
      secrets = mkAliasDefinitions options.ironman.sops.secrets;
    };
  };
}
