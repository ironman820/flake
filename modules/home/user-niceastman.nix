{ config, inputs, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports =
        (with config.flake.homeModules; [
          base
          extra
          flatpak
          plasma
          python
          qt
          syncthing
        ])
        ++ (with inputs; [
          kineticwe.homeModules.default
          nix-flatpak.homeManagerModules.nix-flatpak
          plasma-manager.homeModules.plasma-manager
        ]);
      home.packages = with pkgs; [
        inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.qgis
        # qgis
        wireshark
        zoom-us
      ];
      services.flatpak.packages = [
        "com.anydesk.Anydesk"
      ];
    };
}
