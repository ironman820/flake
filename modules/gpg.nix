{
  flake.nixosModules.gpg = {lib, ...}: {
    programs.gnupg.agent = {
      enableSSHSupport = lib.mkDefault false;
      enable = true;
    };
  };
}
