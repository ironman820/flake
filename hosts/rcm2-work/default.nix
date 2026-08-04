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
    git
    proxmox
    rcm2
    tmux
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.settings.PermitRootLogin = "no";
    postgresql = {
      enable = true;
      ensureDatabases = [
        "rcm"
      ];
      ensureUsers = [
        {
          ensureDBOwnership = true;
          name = "rcm";
        }
      ];
    };
    qemuGuest.enable = true;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
