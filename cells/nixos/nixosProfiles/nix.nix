{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled disabled mkBoolOpt mkOpt;
  inherit (lib.types) int str;

  cfg = config.mine.nix;
  imp = config.mine.impermanence.enable;
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
    environment = {
      persistence."/persist/root".directories = mkIf imp [
        "/root/.cache/nix"
        "/root/.cache/nix-index"
        "/root/.local/share/nix"
      ];
      sessionVariables.FLAKE = "/home/${config.mine.user.name}/.config/flake";
      systemPackages = with pkgs; [
        nh
        nix-output-monitor
        nvd
      ];
    };
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
    programs = {
      command-not-found = disabled;
      nix-index = enabled;
      nix-ld = enabled;
    };
  };
}
