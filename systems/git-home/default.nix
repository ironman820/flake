{
  config,
  lib,
  ...
}:
with lib;
with lib.mine; {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    mine = {
      sops.secrets = {
        "gitlab/initialRootPassword" = {
          group = config.users.groups.keys.name;
          mode = "0440";
          sopsFile = ./secrets/gitlab.yaml;
        };
        "gitlab/smtp/password" = {
          group = config.users.groups.keys.name;
          mode = "0440";
          sopsFile = ./secrets/gitlab.yaml;
        };
      };
      suites.server = {
        enable = true;
        git = {
          enable = true;
          host = "gitlab.niceastman.com";
          initialRootPasswordFile = config.sops.secrets."gitlab/initialRootPassword".path;
          ipAddress = config.mine.networking.address;
          smtp = {
            address = "mail.niceastman.com";
            authentication = "login";
            domain = "niceastman.com";
            enable = true;
            passwordFile = config.sops.secrets."gitlab/smtp/password".path;
            username = "notifications";
          };
        };
      };
      virtual.guest = enabled;
    };

    system.stateVersion = "23.05";
  };
}
