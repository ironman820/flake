{
  flake.nixosModules.drive-shares = {
    programs.fuse.enable = true;
    services = {
      autofs = {
        enable = true;
        timeout = 60;
      };
      gvfs.enable = true;
    };
  };
}
