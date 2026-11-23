{
  flake = {
    nixosModules.VM = { modulesPath, ... }: {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
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
      ironman.server.lxc = false;
    };
  };
}
