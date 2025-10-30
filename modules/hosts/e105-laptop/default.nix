{
  config,
  ...
}:
{
  flake.nixosModules."hosts/e105-laptop" =
    { modulesPath, ... }:
    {
      imports = with config.flake.nixosModules; [
        base
        boot-grub
        de-hyprland
        config.flake.diskoConfigurations.e105-laptop
        drive-shares-personal
        e105-laptop-hardware
        intel-video
        laptop
        x64-linux
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
      home-manager.users.niceastman = config.flake.homeConfigurations.niceastman;
      ironman = {
        user = {
          name = "niceastman";
          email = {
            bob = "nic.eastman";
            site = "royell.org";
          };
        };
        network-profiles.work = true;
      };
      networking.hostName = "e105-laptop";
      nix.settings.cores = 4;
      services.system76-scheduler.settings.cfsProfiles.enable = true;
    };
}
