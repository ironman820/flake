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
          python
          qt
          syncthing
        ])
        ++ (with inputs; [
          nix-flatpak.homeManagerModules.nix-flatpak
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
