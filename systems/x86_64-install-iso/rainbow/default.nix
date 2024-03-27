{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.mine) disabled;
in {
  config = {
    environment.systemPackages =
      (with inputs.disko.packages.${pkgs.system}; [
        disko
      ])
      ++ (with pkgs; [
        age
      ]);
    mine = {
      drives = disabled;
      just = disabled;
      nix-ld = disabled;
      python = disabled;
      sops = disabled;
      user = {
        name = "nixos";
        email = "";
        fullName = "System User";
        password = "";
        hashedPasswordFile = null;
      };
    };
  };
}
