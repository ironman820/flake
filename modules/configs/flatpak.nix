{
  inputs,
  ...
}:
{
  flake = {
    nixosModules.flatpak = { lib, ... }: {
      options.ironman.flatpaks =
        let
          inherit (lib) mkOption;
          inherit (lib.types) listOf str;
        in
        mkOption {
          default = [ ];
          description = "Extra Flatpaks to install";
          type = listOf str;
        };
      config.services.flatpak.enable = true;
    };
    homeModules.flatpak = { osConfig, ... }: {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];
      services.flatpak = {
        enable = true;
        packages = [
          "com.usebottles.bottles"
          "com.github.tchx84.Flatseal"
          "com.orcaslicer.OrcaSlicer"
        ]
        ++ osConfig.ironman.flatpaks;
        uninstallUnmanaged = true;
        update.onActivation = true;
      };
    };
  };
}
