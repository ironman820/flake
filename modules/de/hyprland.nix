{
  flake.nixosModules.de-hyprland =
    { pkgs, ... }:
    {
      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        systemPackages = with pkgs; [
          alacritty
          mako
          terminaltexteffects
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
