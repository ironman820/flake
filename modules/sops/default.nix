{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.sops;
in
{
  options.ironman.sops = with types; {
    enable = mkEnableOption "Setup default options";
    keyFile = mkOption {
      default = "/etc/nixos/keys.txt";
      description = "Age key file";
      type = either str path;
    };
    secrets = mkOption {
      default = { };
      description = "SOPS secrets";
      type = attrs;
    };
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = cfg.keyFile;
      secrets = cfg.secrets;
    };
  };
}
