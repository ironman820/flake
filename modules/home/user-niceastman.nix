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
          kitty
          llama-work-sops
          plasma
          qt
          syncthing
        ])
        ++ (with inputs; [
          nix-flatpak.homeManagerModules.nix-flatpak
          plasma-manager.homeModules.plasma-manager
        ]);
      home.packages = with pkgs; [
        qgis
        wireshark
        zoom-us
      ];
      services.flatpak.packages = [
        "com.anydesk.Anydesk"
      ];
    };
}
