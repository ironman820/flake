{
  config,
  ...
}:
{
  flake.nixosModules."hosts/llama" = _: {
    imports = with config.flake.nixosModules; [
      base
      llama-hardware
      proxmox
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
