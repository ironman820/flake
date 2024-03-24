{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled disabled mkBoolOpt;
  cfg = config.mine.nix-index;
in {
  options.mine.nix-index = {
    enable = mkBoolOpt true "Enable nix-index installation";
  };

  config = mkIf cfg.enable {
    programs = {
      command-not-found = disabled;
      nix-index = enabled;
    };
  };
}
