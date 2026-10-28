{
  flake.nixosModules.proxmox =
    { lib, modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/virtualisation/proxmox-lxc.nix")
      ];
      # Default options listed below imported from the above proxmox module
      # manageHostName = false Tells nix to listen to proxmox's host name
      # manageNetwork = false Tells nix to use proxmox's network configuration
      # proxmoxLXC = {
      #   enable = true;
      #   manageHostName = false;
      #   manageNetwork = false;
      #   privileged = false;
      # };
      boot.loader.systemd-boot.enable = false;
      nix.settings = {
        cores = 1;
        sandbox = false;
      };
      programs.nh = {
        clean = {
          dates = "daily";
          enable = true;
          extraArgs = "--keep 2";
        };
        enable = true;
      };
      services = {
        fstrim.enable = false;
        qemuGuest.enable = true;
      };
    };
}
