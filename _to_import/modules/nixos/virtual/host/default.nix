{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.virtual.host;
in {
  options.mine.virtual.host = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.user.extraGroups = [
      "libvirtd"
    ];
    programs.virt-manager = enabled;
    virtualisation.libvirtd = enabled;
  };
}
