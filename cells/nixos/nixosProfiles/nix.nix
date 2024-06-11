{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.nix;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
  v = config.vars;
in {
  options.vars.nix = {
    gc = {
      dates = l.mkOpt t.str "weekly" "Dates to run GC";
      options = l.mkOpt t.str "--delete-older-than 7d" "Extra Garbage Collect Options.";
    };
    settings.cores = l.mkOpt t.int 2 "Number of cores to run Nix operations";
  };

  config = {
    environment = {
      sessionVariables.FLAKE = "/home/${v.username}/.config/flake";
      systemPackages = with pkgs; [
        nh
        nix-output-monitor
        nvd
      ];
    };
    nix = {
      gc = {
        inherit (c.gc) dates options;
        automatic = true;
      };
      optimise.automatic = true;
      settings = {
        inherit (c.settings) cores;
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        substituters = [
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
        trusted-users = [
          "root"
          "${config.vars.username}"
        ];
      };
    };
    programs = {
      command-not-found = l.disabled;
      nix-index = l.enabled;
      nix-ld = l.enabled;
    };
  };
}
