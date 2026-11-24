{
  lib,
  self,
  ...
}:
{
  flake.nixosModules.server =
    { config, ... }:
    let
      inherit (lib)
        mkDefault
        mkForce
        mkIf
        ;
      srv = config.ironman.server;
    in
    {
      imports = with self.nixosModules; [
        core
        postgres
      ];
      boot.enableContainers = mkDefault false;
      documentation = mkIf srv.unattended {
        enable = false;
        doc.enable = false;
        info.enable = false;
        man.enable = false;
        nixos.enable = false;
      };
      environment = mkIf srv.unattended {
        defaultPackages = [ ];
        stub-ld.enable = false;
      };
      fonts.fontconfig.enable = mkIf srv.unattended false;
      ironman = {
        grub = mkIf srv.lxc false;
        server.unattended = mkDefault true;
      };
      networking.firewall.enable = false;
      programs = mkIf srv.unattended {
        less.lessopen = null;
        command-not-found.enable = false;
      };
      security = {
        sudo.wheelNeedsPassword = false;
        pam.services.su.forwardXAuth = mkIf srv.unattended (mkForce false);
      };
      services = mkIf srv.lxc {
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
