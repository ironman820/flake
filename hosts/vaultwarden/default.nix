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
    git
    proxmox
    tmux
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking.firewall.allowedTCPPorts = [
    8000
  ];
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.settings.PermitRootLogin = "no";
    qemuGuest.enable = true;
    vaultwarden = {
      enable = true;
      config = {
        INVITATIONS_ALLOWED = false;
        LOG_LEVEL = "warn";
        ROCKET_ADDRESS = "0.0.0.0";
        SHOW_PASSWORD_HINT = false;
        SIGNUPS_ALLOWED = false;
        SMTP_HOST = "mail.royell.org";
        SMTP_SECURITY = "starttls";
        SMTP_PORT = 366;
        SMTP_FROM_NAME = "Vaultwarden";
      };
      domain = "pass.niceastman.com";
      environmentFile = config.sops.secrets.vaultwarden_env.path;
    };
  };
  sops.secrets.vaultwarden_env = {
    owner = "vaultwarden";
    group = "vaultwarden";
    sopsFile = "${flakeRoot}/.secrets/vaultwarden.yaml";
    restartUnits = [
      "vaultwarden.service"
    ];
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
