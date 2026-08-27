{
  flake.nixosModules.android =
    {
      config,
      pkgs,
      ...
    }:
    {
      users.users.${config.ironman.user.name}.extraGroups = [ "adbusers" ];
      environment.systemPackages = [
        pkgs.android-studio
      ];
      programs.adb.enable = true;
      services.udev.packages = [
        pkgs.android-udev-rules
      ];
    };
}
