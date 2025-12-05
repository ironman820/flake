{
  flake.nixosModules.drive-shares = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      curlftpfs
    ];
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
