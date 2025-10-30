{
  config,
  ...
}:
{
  flake.nixosModules."hosts/friday" =
    { modulesPath, pkgs, ... }:
    {
      imports = with config.flake.nixosModules; [
        base
        boot-grub
        de-hyprland
        config.flake.diskoConfigurations.friday
        drive-shares-personal
        friday-hardware
        laptop
        x64-linux
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
      environment.systemPackages = with pkgs; [
        calibre
        mmex
      ];
      home-manager.users.ironman = config.flake.homeConfigurations.ironman;
      ironman.network-profiles.work = true;
      networking.hostName = "friday";
      nix.settings.cores = 4;
      services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0";
    };
}
