
{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.nix;
in
{
  options.ironman.nix = with types; {
    enable = mkBoolOpt false "Enable NIX settings.";
    gc = {
      dates = mkOpt str "weekly" "Dates to run GC";
      options = mkOpt str "--delete-older-than 7d" "Extra Garbage Collect Options.";
    };
    settings.cores = mkOpt int 2 "Number of cores to run Nix operations";
  };

  config = mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        dates = cfg.gc.dates;
        options = cfg.gc.options;
      };
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
      optimise.automatic = true;
      settings = {
        auto-optimise-store = true;
        cores = cfg.settings.cores;
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [
          "root"
          "${config.ironman.user.name}"
        ];
      };
    };
  };
}
