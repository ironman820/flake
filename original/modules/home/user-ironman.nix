{ self, ... }:
{
  flake.homeConfigurations.ironman = {
    imports = (
      with self.homeModules;
      [
        extra
        flatpak
        python
        qt
        syncthing
      ]
    );
  };
}
