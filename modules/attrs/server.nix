{
  lib,
  self,
  ...
}:
{
  flake.nixosModules.server = {
    imports = [
      self.nixosModules.core
    ];
    boot.enableContainers = false;
    documentation = {
      enable = false;
      doc.enable = false;
      info.enable = false;
      man.enable = false;
      nixos.enable = false;
    };
    environment = {
      defaultPackages = [ ];
      stub-ld.enable = false;
    };
    fonts.fontconfig.enable = false;
    ironman.grub = false;
    networking.firewall.enable = false;
    programs = {
      less.lessopen = null;
      command-not-found.enable = false;
    };
    security = {
      sudo.wheelNeedsPassword = false;
      pam.services.su.forwardXAuth = lib.mkForce false;
    };
    services = {
      lvm.enable = false;
      udisks2.enable = false;
    };
    xdg = {
      autostart.enable = false;
      icons.enable = false;
      mime.enable = false;
      sounds.enable = false;
    };
  };
}
