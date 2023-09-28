{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.home.sops;
in
{
  options.ironman.home.sops = with types; {
    enable = mkBoolOpt true "Enable root secrets";
    age = mkOpt attrs { } "Age Attributes";
    defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default SOPS file path.";
    secrets = mkOpt attrs { } "SOPS secrets.";
  };

  config = mkIf cfg.enable {
    imports = [
      <sops-nix/modules/home-manager/sops.nix>
    ];
    ironman.home.sops = {
      age.keyFile = "/etc/nixos/keys.txt";
      secrets = mkMerge [
        {
          user_pass = {
            mode = "0400";
            neededForUsers = true;
            sopsFile = ./secrets/sops.yaml;
          };
        }
      ];
    };
    sops = {
      enable = true;
      age = mkAliasDefinitions options.ironman.home.sops.age;
      defaultSopsFile = mkAliasDefinitions options.ironman.home.sops.defaultSopsFile;
      secrets = mkAliasDefinitions options.ironman.home.sops.secrets;
    };
  };
}
