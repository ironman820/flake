{ inputs, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.qgis
        # qgis
        wireshark
        zoom-us
      ];
    };
}
