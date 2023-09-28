{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.suites.server;
in
{
  options.ironman.suites.server = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.sops.secrets = {
      github = {
        group = config.users.groups.users.name;
        mode = "0400";
        path = "/home/${config.ironman.user.name}/.ssh/github";
        sopsFile = ./secrets/github_servers.age;
        user = config.ironman.user.name;
      };
    };
    environment = {
      shellInit = ''
        export NIX_LD=$(cat "${pkgs.stdenv.cc}/nix-support/dynamic-linker")
      '';
      variables = mkForce {
        NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
        ];
      };
    };
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
    security.sudo.wheelNeedsPassword = false;
  };
}
