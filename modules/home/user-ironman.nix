{ self, ... }:
{
  flake.homeConfigurations.ironman = {
    imports =
      (with self.homeModules; [
        base
        extra
        flatpak
        python
        qt
        syncthing
      ]);
  };
}
