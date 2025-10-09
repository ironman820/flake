{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  inherit (pkgs) writeShellScript;
  cfg = config.mine.home.scripts;
in {
  options.mine.home.scripts = {
    enable = mkBoolOpt true "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.file = {
      "scripts/just/persistence.sh".source = writeShellScript "persistence.sh" ''
        echo "What should I do?"
      '';
    };
  };
}
