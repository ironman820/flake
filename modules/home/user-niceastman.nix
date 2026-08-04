{ self, ... }:
{
  flake.homeConfigurations.niceastman =
    { inputs', pkgs, ... }:
    {
      imports =
        (with self.homeModules; [
          base
          extra
          flatpak
          kitty
          plasma
          python
          qt
          syncthing
        ]);
      home.packages = with pkgs; [
        inputs'.nixpkgs-stable.legacyPackages.qgis
        # qgis
        wireshark
        zoom-us
      ];
      services.flatpak.packages = [
        "com.anydesk.Anydesk"
      ];
    };
}
