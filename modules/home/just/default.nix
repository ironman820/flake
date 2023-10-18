{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.just;
in {
  options.ironman.home.just = {
    enable = mkBoolOpt true "Install Just";
    # configFile = mkOpt lines "" "The text of the config file";
  };

  config = mkIf cfg.enable {
    home = {
      file.".justfile".source = mkOutOfStoreSymlink "/home/${config.ironman.home.user.name}/.config/flake/modules/home/just/justfile";
      packages = with pkgs; [
        just
      ];
      shellAliases = {
        "js" = "just switch";
        "ju" = "just update";
      };
    };
  };
}

