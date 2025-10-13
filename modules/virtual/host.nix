{
  flake.nixosModules.virtual-host =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        virt-manager
      ];
      users.users.${config.ironman.user}.extraGroups = [
        "libvirtd"
      ];
      programs.virt-manager.enable = true;
      virtualisation.libvirtd.enable = true;
    };
}
