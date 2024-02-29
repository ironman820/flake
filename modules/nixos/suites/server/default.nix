{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.mine.suites.server;
in {
  options.mine.suites.server = {
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
    mine.ssh.PasswordAuthentication = true;
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
    security.sudo.wheelNeedsPassword = false;
  };
}
