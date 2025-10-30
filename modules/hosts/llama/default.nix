{
  config,
  ...
}:
{
  flake.nixosModules."hosts/llama" = _: {
    imports = with config.flake.nixosModules; [
      base
      boot-systemd
      llama-hardware
      virtual-docker
      x64-linux
    ];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        powerManagement.enable = true;
      };
      nvidia-container-toolkit.enable = true;
    };
    home-manager.users.ironman = config.flake.homeConfigurations.ironman-server;
    networking = {
      hostName = "llama";
      useDHCP = false;
      interfaces."eth0@if39" = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.248.120";
            prefixLength = 24;
          }
        ];
      };
      defaultGateway = "192.168.248.1";
      nameservers = [
        "208.80.144.50"
        "208.80.144.51"
      ];
    };
    nix.settings.cores = 4;
    services = {
      qemuGuest.enable = true;
      xserver = {
        enable = false;
        videoDrivers = [ "nvidia" ];
      };
    };
    users.users.ironman.extraGroups = [
      "networkmanager"
      "docker"
    ];
  };
}
