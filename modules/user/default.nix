{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.user;
in {
  options.ironman.user = {
    name = mkOption {
      default = "ironman";
      description = "User name";
      type = types.str;
    };
  };
}
