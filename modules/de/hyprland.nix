{ self, ... }:
{
  flake.nixosModules.de-hyprland =
    { config, pkgs, ... }:
    {
      imports = with self.nixosModules; [
        sddm
      ];
      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        systemPackages = with pkgs; [
          alacritty
          impala
          mako
          nautilus
          networkmanagerapplet
          terminaltexteffects
        ];
      };
      nix.settings = {
        extra-substituters = [
          "https://walker.cachix.org"
          "https://walker-git.cachix.org"
        ];
        extra-trusted-public-keys = [
          "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
          "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
        ];
      };
      programs = {
        hyprland = {
          enable = true;
          withUWSM = true;
        };
        hyprlock.enable = true;
      };
      services.hypridle.enable = true;
    };
}
