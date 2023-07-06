{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.sops;
  rcfg = config.ironman.root-sops;
in {
  options.ironman = with types; {
    sops = {
      enable = mkBoolOpt false "Enable or disable sops support";
      age = mkOpt attrs {} "Age file attributes.";
      defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default sops file location";
      secrets = mkOpt attrs {} "Secrets for Sops to use.";
    };
    root-sops = {
      enable = mkBoolOpt false "Enable root secrets";
      age = mkOpt attrs {} "Age Attributes";
      defaultSopsFile = mkOpt path ./secrets/sops.yaml "Default SOPS file path.";
      secrets = mkOpt attrs {} "SOPS secrets.";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      ironman = {
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
        root-sops.enable = config.ironman.wireless-profiles.enable;
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
    })
    (mkIf rcfg.enable {
      ironman.root-sops = {
        age.keyFile = "/home/${config.ironman.user.name}/.config/sops/age/keys.txt";
        secrets = mkMerge [
            (mkIf config.ironman.wireless-profiles.home {
              da_psk = {
                format = "binary";
                mode = "0400";
                path = "/etc/NetworkManager/system-connections/DumbledoresArmy.nmconnection";
                sopsFile = ./secrets/da.wifi;
              };
            })
          ];
      };
      sops = {
        age = mkAliasDefinitions options.ironman.root-sops.age;
        defaultSopsFile = mkAliasDefinitions options.ironman.root-sops.defaultSopsFile;
        secrets = mkAliasDefinitions options.ironman.root-sops.secrets;
      };
    })
  ];
}
