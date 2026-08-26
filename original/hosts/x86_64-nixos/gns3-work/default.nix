{
  inputs,
  self,
  ...
}:
{
  imports = with self.nixosModules; [
    ./hardware.nix
    grub
    docker
    gns3
    x64-linux
  ];
  hardware = {
    amdgpu.initrd.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 8;
  security.sudo.wheelNeedsPassword = false;
  services.openssh.settings.PermitRootLogin = "no";
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
