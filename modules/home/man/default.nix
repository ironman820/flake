{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;
  cfg = config.ironman.home.man;
in {
  options.ironman.home.man = {
    enable = mkBoolOpt true "Install new man pager.";
  };

  config = mkIf cfg.enable {
    home = {
      file.".config/tealdeer".source = mkOutOfStoreSymlink "/home/${config.ironman.home.user.name}/.config/flake/modules/home/man/config";
      packages = with pkgs; [
        tealdeer
      ];
      shellAliases = {
        "man" = "tldr";
      };
    };
  };
}

