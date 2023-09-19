{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.nix-ld;
in {
  options.ironman.nix-ld = {
    enable = mkBoolOpt true "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = enabled;
    # environment.variables = {
    #   NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    #     pkgs.stdenv.cc.cc
    #   ];
    #   # NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    # };
  };
}
