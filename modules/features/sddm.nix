{
  flake.nixosModules.sddm =
    { pkgs, ... }:
    let
      sddm-theme = (pkgs.sddm-astronaut.override {
          embeddedTheme = "hyprland_kath";
        });
    in
    {
      environment = {
        systemPackages = with pkgs.kdePackages; [
          qtmultimedia
          sddm-theme
        ];
      };
      services = {
        displayManager.sddm = {
          enable = true;
          enableHidpi = true;
          extraPackages = [
            sddm-theme
          ];
          theme = "sddm-astronaut-theme";
          wayland.enable = true;
        };
      };
    };
}
