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
    base
    git
    proxmox
    tmux
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    lidarr = {
      enable = true;
      group = config.ironman.user.name;
      openFirewall = true;
      user = config.ironman.user.name;
    };
    qemuGuest.enable = true;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
