{
  flake.nixosModules.sddm =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = [
          pkgs.kdePackages.qtmultimedia
          (pkgs.sddm-astronaut.override {
            embeddedTheme = "cyberpunk";
          })
        ];
      };
      services = {
        displayManager.sddm = {
          enable = true;
          enableHidpi = true;
          theme = "sddm-astronaut-theme";
          wayland.enable = true;
        };
      };
    };
}
