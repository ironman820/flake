{
  config,
  flakeRoot,
  pkgs,
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
    python
    rcm
    tmux
    x64-linux
  ]);
  environment.systemPackages = with pkgs; [
    sonar-scanner-cli
  ];
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking.nameservers = [
    "192.168.248.2"
  ];
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.settings.PermitRootLogin = "no";
    qemuGuest.enable = true;
  };
  sops.secrets."sonar-project.properties" = {
    sopsFile = "${flakeRoot}/.secrets/rcm.yaml";
    owner = config.ironman.user.name;
    group = config.ironman.user.name;
    path = "/data/rcm/sonar-project.properties";
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
