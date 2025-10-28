{
  flake.nixosModules.virtual-host =
    { config, ... }:
    {
      users.users.${config.ironman.user.name}.extraGroups = [
        "libvirtd"
      ];
      programs.virt-manager.enable = true;
      virtualisation.libvirtd.enable = true;
    };
}
