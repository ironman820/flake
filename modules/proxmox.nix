{
  flake.nixosModules.proxmox =
    { modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/virtualisation/proxmox-lxc.nix")
      ];
      nix.settings.sandbox = false;
      # Default options listed below imported from the above proxmox module
      # manageHostName = false Tells nix to listen to proxmox's host name
      # manageNetwork = false Tells nix to use proxmox's network configuration
      # proxmoxLXC = {
      #   enable = true;
      #   manageHostName = false;
      #   manageNetwork = false;
      #   privileged = false;
      # };
      services.fstrim.enable = false;
    };
}
