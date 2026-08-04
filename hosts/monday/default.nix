{
  inputs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    grub
    xfce
    git
    laptop
    tmux
    winbox
  ]);
  boot.plymouth.enable = false;
  home-manager.users.ironman = self.homeConfigurations.ironman-minimal;
  ironman = {
    network-profiles.work = true;
  };
  networking.hostName = "monday";
  services.openssh.settings.PermitRootLogin = "no";
  zramSwap.enable = false;
}
