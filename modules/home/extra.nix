{ config, ... }:
{
  flake.homeModules.extra = _: {
    imports = with config.flake.homeModules; [
      podman
      yubikey
    ];
    programs.zed-editor.enable = true;
    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
