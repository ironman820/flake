{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.sddm;
  l = nixpkgs.lib // mine.lib // builtins;
  p = mine.packages;
in {
  options.vars.sddm = {
    wayland = l.mkEnableOption "Enable Wayland support";
  };

  config = {
    # environment.systemPackages = [
    #   p.where-is-my-sddm-theme
    # ];
    services.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
      package = p.sddm;
      settings = {
        Users = {
          RememberLastUser = true;
          RememberLastSession = true;
        };
      };
      theme = "where_is_my_sddm_theme";
      wayland.enable = c.wayland;
    };
  };
}
