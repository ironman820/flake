{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.nix;
in {
  options.ironman.nix = with types; {
    enable = mkBoolOpt true "Whether to setup the nix options or not.";
  };

  config = mkIf cfg.enable {
    nix = {
      gc.automatic = true;
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
      optimise.automatic = true;
      settings = {
        cores = 3;
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
    };
    nixpkgs.config = {
      allowUnfree = true;
    };
  };
}