{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.gcc;
in
{
  options.mine.gcc = {
    enable = mkEnableOption "Enable gcc utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      glibc
    ];
  };
}
