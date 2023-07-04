{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.sops;
in {
  options.ironman.sops = with types; {
    enable = mkBoolOpt true "Enable or disable sops support";
    age = mkOpt attrs {} "Age file attributes.";
    defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default sops file location";
    secrets = mkOpt attrs {} "Secrets for Sops to use.";
  };

  config = mkIf cfg.enable {
    ironman = {
      # home.extraOptions.services.sops-nix = enabled;
      sops = {
        age.keyFile = "/home/${config.ironman.user.name}/.config/sops/age/keys.txt";
        secrets = mkMerge [
          ({
            github_home = {
              mode = "0400";
              path = "/home/${config.ironman.user.name}/.ssh/github_home";
              sopsFile = ./secrets/ssh.yaml;
            };
            ed25519_sk = {
              mode = "0400";
              path = "/home/${config.ironman.user.name}/.ssh/id_ed25519_sk";
              sopsFile = ./secrets/ssh.yaml;
            };
            my_config = {
              format = "binary";
              path = "/home/${config.ironman.user.name}/.ssh/my-config";
              sopsFile = ./secrets/my-config;
            };
          })
          (mkIf config.ironman.work-laptop.enable {
            github_work = {
              mode = "0400";
              path = "/home/${config.ironman.user.name}/.ssh/github_work";
              sopsFile = ./secrets/ssh.yaml;
            };
            ed25519_sk_work = {
              mode = "0400";
              path = "/home/${config.ironman.user.name}/.ssh/id_ed25519_sk_work";
              sopsFile = ./secrets/ssh.yaml;
            };
          })
        ];
      };
    };

    home-manager = {
      sharedModules = with inputs; [
        sops-nix.homeManagerModules.sops
      ];
      users.${config.ironman.user.name}.sops = {
        age = mkAliasDefinitions options.ironman.sops.age;
        defaultSopsFile = mkAliasDefinitions options.ironman.sops.defaultSopsFile;
        secrets = mkAliasDefinitions options.ironman.sops.secrets;
      };
    };
  };
}
