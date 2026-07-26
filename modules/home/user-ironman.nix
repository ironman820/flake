{ config, inputs, ... }:
{
  flake.homeConfigurations.ironman = {
    imports =
      (with config.flake.homeModules; [
        base
        extra
        flatpak
        # kitty
        # llama-work-sops
        # plasma
        qt
        syncthing
        xfce
      ])
      ++ (with inputs; [
        nix-flatpak.homeManagerModules.nix-flatpak
        plasma-manager.homeModules.plasma-manager
      ]);
  };
}
