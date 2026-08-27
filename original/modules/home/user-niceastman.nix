{ inputs, self, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports = (
        with self.homeModules;
        [
          base
          extra
          qt
          syncthing
        ]
      );
      home.packages = with pkgs; [
        inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.qgis
        # qgis
        wireshark
        zoom-us
      ];
      programs.tmux.shortcut = "Space";
    };
}
