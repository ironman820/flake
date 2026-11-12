{
  lib,
  self,
  ...
}:
{
  flake.nixosModules.server =
    { config, ... }:
    let
      inherit (lib) mkDefault mkForce mkIf mkOption types;
      srv = config.ironman.server;
    in
    {
      imports = [
        self.nixosModules.core
      ];
      options.ironman.server = {
        lxc = mkOption {
          default = true;
          description = "This server is an LXC container";
          type = types.bool;
        };
        unattended = mkOption {
          default = true;
          description = "This server is an unattended server";
          type = types.bool;
        };
      };
      config = {
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
        ironman.grub = mkIf srv.lxc false;
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
    };
}
