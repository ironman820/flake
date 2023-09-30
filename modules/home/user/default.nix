{ config, host, lib, pkgs, system, ... }:
let
  inherit (lib) mkIf types;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) nullOr str;
  cfg = config.ironman.home.user;
  home-directory =
    if cfg.name == null then
      null
    else
      "/home/${cfg.name}";
in
{
  options.ironman.home.user = {
    enable = mkBoolOpt false "Enable user's home manager";
    email = mkOpt str "29488820+ironman820@users.noreply.github.com" "User email";
    fullName = mkOpt str "Nicholas Eastman" "Full Name";
    homeDirectory = mkOpt (nullOr str) home-directory "The user's home directory";
    name = mkOpt (nullOr str) config.snowfallorg.user.name "User Name";
  };

  config = mkIf cfg.enable {
    home = {
      inherit (cfg) homeDirectory;
      username = cfg.name;
    };
  };
}
