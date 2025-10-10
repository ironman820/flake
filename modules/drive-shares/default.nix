{
  flake.nixosModules.drive-shares = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      curlftpfs
      fuse
    ];
    services = {
      autofs.enable = true;
      gvfs.enable = true;
    };
  };
}
