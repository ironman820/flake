{
  config,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    grub
    xfce
    laptop
    winbox
  ]);
  boot.plymouth.enable = false;
  home-manager.users.ironman = self.homeConfigurations.ironman-minimal;
  ironman = {
    network-profiles.work = true;
  };
  networking.hostName = "monday";
  services.openssh.settings.PermitRootLogin = "no";
  topology.self = {
    hardware.info = "Dell Netbook";
    icon = "devices.laptop";
    interfaces.wlp1s0 = {
      network = "home";
      physicalConnections = [
        (config.lib.topology.mkConnection "ap" "wifi2")
      ];
      renderer.hidePhysicalConnections = true;
    };
    name = "Monday";
  };
  zramSwap.enable = false;
}
