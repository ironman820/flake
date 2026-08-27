{ self, ... }:
{
  flake.homeConfigurations.ironman = {
    imports = (
      with self.homeModules;
      [
        extra
        qt
        syncthing
      ]
    );
  };
}
