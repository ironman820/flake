{
  config,
  inputs,
  pkgs,
  ...
}:
{
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
    nvidia-container-toolkit = {
      enable = true;
    };
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
}
