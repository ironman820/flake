{ inputs, pkgs, self, ... }: {
    imports = with self.nixosModules; [
      extraGuiApps
      arduino
      grub
      fonts
      drive-shares
      laptop
      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      virtualHost
      docker
      ./hardware.nix
      winbox
      x64-linux
    ];
    environment.systemPackages = with pkgs; [
      boxbuddy
      deskflow
      distrobox
      docker-compose
      googleearth-pro
      freerdp
    ];
    hardware.graphics.extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    home-manager.users.niceastman = self.homeConfigurations.niceastman;
    ironman = {
      shares = {
        work = true;
        personal = true;
      };
      network-profiles.work = true;
      work_laptop = true;
    };
    networking = {
      firewall.allowedTCPPorts = [
        24800
      ];
    };
    nix.settings.cores = 4;
    services = {
      openssh.settings.PermitRootLogin = "no";
      # system76-scheduler.settings.cfsProfiles.enable = true;
    };
}
