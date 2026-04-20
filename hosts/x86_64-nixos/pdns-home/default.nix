{
  inputs,
  pkgs,
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
  networking = {
    firewall.enable = false;
    hostName = "pdns.home";
  };
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    qemuGuest.enable = true;
    technitium-dns-server = {
      enable = true;
      openFirewall = true;
    };
    xserver.enable = false;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
