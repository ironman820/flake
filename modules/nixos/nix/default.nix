{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) int str;
  cfg = config.mine.nix;
in {
  options.mine.nix = {
    enable = mkBoolOpt true "Enable NIX settings.";
    gc = {
      dates = mkOpt str "weekly" "Dates to run GC";
      options = mkOpt str "--delete-older-than 7d" "Extra Garbage Collect Options.";
    };
    settings.cores = mkOpt int 2 "Number of cores to run Nix operations";
  };

  config = mkIf cfg.enable {
    nix = {
      gc = {
        inherit (cfg.gc) dates options;
        automatic = true;
      };
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
      optimise.automatic = true;
      settings = {
        inherit (cfg.settings) cores;
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        trusted-users = [
          "root"
          "${config.mine.user.name}"
        ];
      };
    };
  };
}
