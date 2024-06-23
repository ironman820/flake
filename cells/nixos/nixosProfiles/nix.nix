{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  b = "/etc/nixpkgs/channels";
  c = config.vars.nix;
  l = nixpkgs.lib // mine.lib // builtins;
  nixpkgsPath = "${b}/nixpkgs";
  nixpkgs2311Path = "${b}/nixpkgs-2311";
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
      nixPath = [
        "nixpkgs=${nixpkgsPath}"
        "nixpkgs2311=${nixpkgs2311Path}"
      ];
      optimise.automatic = true;
      registry = with inputs; {
        nixpkgs.flake = nixpkgs;
        nixpkgs2311.flake = nixpkgs-2311;
      };
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
