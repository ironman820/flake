{ pkgs, ... }:
{
  flake.modules.nixos.apps.gui = {
    environment.systemPackages = with pkgs; [
      mmex
    ];
  };
}
