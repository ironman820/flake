{ config, host, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.user;
in
{
  options.ironman.home.user = with types; {
    email = mkOpt str "29488820+ironman820@users.noreply.github.com" "User email";
    fullName = mkOpt str "Nicholas Eastman" "Full Name";
    name = mkOpt str "ironman" "User Name";
  };
}
