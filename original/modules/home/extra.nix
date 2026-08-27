{ self, ... }:
{
  flake.homeModules.extra = {
    imports = with self.homeModules; [
      yubikey
    ];
    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
