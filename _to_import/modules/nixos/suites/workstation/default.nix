{
  config,
  lib,
  ...
}:
let
  inherit (config.mine.user.settings.applications) browser terminal;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.suites.workstation;
in
{
  options.mine.suites.workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    virtual = {
      host = enabled;
      podman = enabled;
    };
  };
}
