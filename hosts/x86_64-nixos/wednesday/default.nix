{ config, inputs, pkgs, self, ... }: {
    imports = with self.nixosModules; [
      extraGuiApps
      python
      arduino
      grub
      fonts
      drive-shares
      laptop
      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      niri
      syncthing
      virtualHost
      docker
      ./hardware.nix
      winbox
      x64-linux
      yubikey
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
      plasma = true;
      shares = {
        work = true;
        personal = true;
      };
      syncthing = {
        devices = {
          friday = {
            id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
            name = "Friday";
          };
        };
        folders = {
          "/home/${config.ironman.user.name}/.var/app/com.orcaslicer.OrcaSlicer/config/OrcaSlicer" = {
            id = "eubqq-hp2qx";
            devices = [
              "nas"
              "friday"
            ];
            label = "OrcaSlicer";
          };
          "/home/${config.ironman.user.name}/.thunderbird" = {
            id = "upryn-vzhy9";
            devices = [
              "nas"
            ];
            label = "Thunderbird";
            type = "sendonly";
          };
          "/home/${config.ironman.user.name}/Downloads" = {
            id = "zuqju-kwzbp";
            devices = [
              "friday"
              "nas"
              "work-desktop"
            ];
            label = "Downloads";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
          "/home/${config.ironman.user.name}/Documents" = {
            id = "kuriw-survq";
            devices = [
              "friday"
              "nas"
              "work-desktop"
            ];
            label = "Work Documents";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
          "/home/${config.ironman.user.name}/Notes" = {
            id = "q6twd-r4s4f";
            devices = [
              "friday"
              "nas"
              "phone"
            ];
            label = "Notes";
          };
          "/home/${config.ironman.user.name}/Pictures" = {
            id = "okbn5-ywkrq";
            devices = [
              "friday"
              "nas"
              "work-desktop"
            ];
            label = "Work Pictures";
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
          "/home/${config.ironman.user.name}/Wallpapers" = {
            id = "gtwyq-tfzfb";
            devices = [
              "friday"
              "nas"
              "work-desktop"
            ];
            label = "Wallpapers";
          };
        };
      };
      user = {
        name = "niceastman";
        email = {
          bob = "nic.eastman";
          site = "royell.org";
        };
      };
      network-profiles.work = true;
      work_laptop = true;
      zed_device = "0x1114";
    };
    networking = {
      firewall.allowedTCPPorts = [
        24800
      ];
      hostName = "wednesday";
    };
    nix.settings.cores = 4;
    services = {
      openssh.settings.PermitRootLogin = "no";
      # system76-scheduler.settings.cfsProfiles.enable = true;
    };
}
