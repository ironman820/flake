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
      ]
    );
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}
