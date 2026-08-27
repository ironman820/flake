{ config, pkgs, ... }: {
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    extraGui = true;
    niri.outputs = {
      "eDP-1" = {
        mode = {
          height = 1200;
          refresh = 60.;
          width = 1920;
        };
        scale = 1;
      };
    };
  };
  networking.hostName = "friday";
  topology.self = {
    deviceType = "nixos";
    hardware.info = "Lenovo Thinkpad E14";
    icon = "devices.laptop";
    interfaces.wlp3s0 = {
      network = "home";
      renderer.hidePhysicalConnections = true;
    };
    name = "Friday";
  };
  users.groups.ironman.gid = pkgs.lib.mkForce 986;
}
