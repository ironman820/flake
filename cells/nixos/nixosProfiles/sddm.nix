{
  cell,
  config,
  inputs,
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
    environment.systemPackages = [
      p.sddm-catppuccin
    ];
    services.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
      theme = "catppuccin-mocha";
      wayland.enable = c.wayland;
    };
  };
}
