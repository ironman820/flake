{
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
    rcm
    tmux
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    qemuGuest.enable = true;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
