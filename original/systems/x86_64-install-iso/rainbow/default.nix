{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.mine) disabled;
in {
  config = {
    environment.systemPackages = [
      pkgs.age
      inputs.disko.packages.${pkgs.system}.disko
    ];
    mine = {
      networking.drives = disabled;
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
