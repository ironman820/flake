{ config, self, ... }: {
  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "pass";
  };
  services.vaultwarden = {
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
  sops.secrets.vaultwarden_env = {
    owner = "vaultwarden";
    group = "vaultwarden";
    sopsFile = "${self.outPath}/.secrets/vaultwarden.yaml";
    restartUnits = [
      "vaultwarden.service"
    ];
  };
}
