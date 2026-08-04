{
  flake.nixosModules.gns3 =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        qemu
        gns3-server
        ubridge
        inetutils
      ];
      networking.firewall.enable = false;
      services.gns3-server = {
        enable = true;
        log.debug = true;
        ubridge.enable = true;
        vpcs.enable = true;
      };
      systemd.services.gns3-server.serviceConfig = {
        DeviceAllow = [ "/dev/kvm" ];
        SupplementaryGroups = [ "kvm" ];
        PrivateDevices = false;
        Environment = [ "PATH=/run/current-system/sw/bin:/usr/bin:/bin" ];
      };
    };
}
