
{
  flake.nixosModules.sddm = {pkgs, ...}: {
    config = {
      environment = {
        systemPackages = [
          (pkgs.catppuccin-sddm.override {
            flavor = "mocha";
          })
        ];
      };
      services = {
        displayManager.sddm = {
          enable = true;
          enableHidpi = true;
          theme = "catppuccin-mocha";
          wayland.enable = true;
        };
      };
    };
  };
}
