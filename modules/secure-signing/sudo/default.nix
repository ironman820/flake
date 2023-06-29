{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.secure-signing.sudo;
in {
  options.ironman.secure-signing.sudo = with types; {
    enable = mkBoolOpt true "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    security.sudo = {
      execWheelOnly = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
              options = [ "SETENV" "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };
  };
}