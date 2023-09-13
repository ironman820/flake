{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.pixiecore;
in {
  options.ironman.servers.pixiecore = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    services.pixiecore = {
      dhcpNoBind = true;
      enable = true;
      mode = "quick";
      openFirewall = true;
    };
  };
}
