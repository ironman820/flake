{
  hardware = {
    amdgpu.initrd.enable = true;
    facter.reportPath = ./facter.json;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  nix.settings.cores = 8;
}
