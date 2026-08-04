{
  flake.nixosModules.grub =
    { lib, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      boot = {
        loader.grub = {
          efiSupport = true;
          device = "nodev";
          timeoutStyle = "hidden";
        };
        plymouth.enable = mkDefault true;
      };
    };
}
