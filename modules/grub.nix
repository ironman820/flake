{
  flake.nixosModules.grub =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.mine) enabled disabled;
    in
    {
      boot = {
        loader.grub = {
          efiSupport = true;
          device = "nodev";
          theme = "${pkgs.grub-cyberexs}/share/grub/themes/CyberEXS";
        };
        plymouth = enabled;
      };
      # stylix.targets = {
      #   grub = disabled;
      #   plymouth = disabled;
      # };
    };
}
