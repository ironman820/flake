{
  flake.nixosModules.boot-grub =
    { lib, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      boot = {
        loader.grub = {
          efiSupport = true;
          device = "nodev";
          darkmatter-theme = {
            enable = mkDefault true;
            style = "nixos";
            icon = "color";
            resolution = "1080p";
          };
        };
        plymouth.enable = mkDefault true;
      };
    };
}
