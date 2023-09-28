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
    ironman.sops = {
      age = {
        keyFile = "/etc/nixos/keys.txt";
        sshKeyPaths = [];
      };
      secrets = mkMerge [
        {
          github = {
            group = config.users.groups.users.name;
            mode = "0400";
            owner = config.ironman.user.name;
            path = "/home/${config.ironman.user.name}/.ssh/github";
            sopsFile = mkDefault ./secrets/github_home.age;
            format = "binary";
          };
          github_home_pub = {
            group = config.users.groups.users.name;
            mode = "0400";
            owner = config.ironman.user.name;
            path = "/home/${config.ironman.user.name}/.ssh/github_home.pub";
            sopsFile = ./secrets/github_home.pub.age;
            format = "binary";
          };
          github_servers_pub = {
            group = config.users.groups.users.name;
            mode = "0400";
            owner = config.ironman.user.name;
            path = "/home/${config.ironman.user.name}/.ssh/github_servers.pub";
            sopsFile = ./secrets/github_servers.pub.age;
            format = "binary";
          };
          github_work_pub = {
            group = config.users.groups.users.name;
            mode = "0400";
            owner = config.ironman.user.name;
            path = "/home/${config.ironman.user.name}/.ssh/github_work.pub";
            sopsFile = ./secrets/github_work.pub.age;
            format = "binary";
          };
        }
      ];
    };
    sops = {
      age = mkAliasDefinitions options.ironman.sops.age;
      defaultSopsFile = mkAliasDefinitions options.ironman.sops.defaultSopsFile;
      gnupg.sshKeyPaths = [];
      secrets = mkAliasDefinitions options.ironman.sops.secrets;
    };
  };
}
