{
  flake.nixosModules.proxmox = {
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
