{
  config,
  flakeRoot,
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
  networking.firewall.allowedTCPPorts = [
    3000
  ];
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.settings.PermitRootLogin = "no";
    qemuGuest.enable = true;
    zipline = {
      enable = true;
      database.createLocally = true;
      environmentFiles = [
        config.sops.secrets.zipline_env.path
      ];
      settings.CORE_HOSTNAME = "0.0.0.0";
    };
  };
  sops.secrets.zipline_env = {
    sopsFile = "${flakeRoot}/.secrets/zipline.yaml";
    restartUnits = [
      "zipline.service"
    ];
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
