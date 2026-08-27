{ self, ... }:
{
  flake.homeConfigurations.ironman = {
    imports = (
      with self.homeModules;
      [
        extra
        python
        qt
        syncthing
      ]
    );
  };
}
