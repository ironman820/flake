{
  flake.nixosModules.boot-grub =
    {
      pkgs,
      ...
    }:
    {
      boot = {
        loader.grub = {
          efiSupport = true;
          device = "nodev";
          theme = "${pkgs.local.grub-cyberexs}/share/grub/themes/CyberEXS";
        };
        plymouth.enable = true;
      };
      # stylix.targets = {
      #   grub = disabled;
      #   plymouth = disabled;
      # };
    };
}
