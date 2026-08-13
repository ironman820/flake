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
          niri
          python
          qt
          syncthing
        ]);
      ironman.just = let
        niri_cmd = "niri msg output";
        niri_screen = "DP-4";
      in {
        screen = [
          "${niri_cmd} ${niri_screen} on"
          ''${niri_cmd} ${niri_screen} mode "3840x2160@60.000000"''
          "${niri_cmd} ${niri_screen} scale 1"
          "${niri_cmd} eDP-1 off"
        ];
        screen_reset.extraConfig = [
          "${niri_cmd} ${niri_screen} off"
        ];
      };
      home.packages = with pkgs; [
        inputs'.nixpkgs-stable.legacyPackages.qgis
        # qgis
        wireshark
        zoom-us
      ];
      programs.tmux.shortcut = "Space";
      services.flatpak.packages = [
        "com.anydesk.Anydesk"
      ];
    };
}
