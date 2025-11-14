{
  inputs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with inputs; [
    darkmatter-grub-theme.nixosModule
    disko.nixosModules.disko
  ])
  ++ (with self.nixosModules; [
    base
    boot-grub
    de-xfce
    git
    self.diskoConfigurations.monday
    laptop
    tmux
    winbox
  ]);
  # boot = {
  #   loader.grub.darkmatter-theme.enable = false;
  #   plymouth.enable = false;
  # };
  home-manager.users.ironman = self.homeConfigurations.ironman-minimal;
  ironman = {
    network-profiles.work = true;
  };
  networking.hostName = "monday";
  zramSwap.enable = false;
}
