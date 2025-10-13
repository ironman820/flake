{
  flake.nixosModules.gpg = _: {
    programs.gnupg.agent = {
      enableSSHSupport = false;
      enable = true;
    };
  };
}
