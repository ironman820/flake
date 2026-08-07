{ self, ... }:
{
  flake.homeConfigurations.ironman = {
    imports =
      (with self.homeModules; [
        base
        extra
        flatpak
        niri
        python
        qt
        syncthing
      ]);
  };
}
