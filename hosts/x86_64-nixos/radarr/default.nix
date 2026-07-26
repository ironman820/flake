{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    proxmox
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    radarr = {
      enable = true;
      dataDir = "/var/lib/radarr/";
      group = config.ironman.user.name;
      openFirewall = true;
      user = config.ironman.user.name;
    };
    openssh.settings.PermitRootLogin = "no";
    qemuGuest.enable = true;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
