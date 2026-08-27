{
  self,
  ...
}:
{
  flake.nixosModules.laptop = {
    imports = (
      with self.nixosModules;
      [
        core
        flatpak
        niri
        yubikey
      ]
    );
    ironman.laptop = true;
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise.automatic = true;
      settings.auto-optimise-store = true;
    };
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}
