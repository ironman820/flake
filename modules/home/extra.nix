{ self, ... }:
{
  flake.homeModules.extra = {
    imports = with self.homeModules; [
      podman
      yubikey
    ];
    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
