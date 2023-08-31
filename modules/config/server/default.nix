{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.suites.server;
in
{
  options.ironman.suites.server = with types; {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
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
    ironman = {
      home.extraOptions = {
        home.file = {
          ".config/is_server".text = ''true'';
        };
        programs = {
          git.signing = {
            key = "~/.ssh/github_servers";
            signByDefault = builtins.stringLength "~/.ssh/github_servers" > 0;
          };
        };
      };
    };
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
    security.sudo.wheelNeedsPassword = false;
  };
}
