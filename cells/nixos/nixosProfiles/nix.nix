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
      localRegistry = {
        enable = true;
        cacheGlobalRegistry = true;
      };
      optimise.automatic = true;
      settings = {
        inherit (c.settings) cores;
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
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
