{ self, ... }:
{
  flake.homeConfigurations.ironman-minimal = {
    imports = with self.homeModules; [
      base
      flatpak
      kitty
    ];
  };
}
