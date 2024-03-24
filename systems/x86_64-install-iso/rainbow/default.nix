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
      networking.drives = disabled;
      nix-ld = disabled;
      libraries.python = disabled;
      sops = disabled;
      tui.just = disabled;
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
