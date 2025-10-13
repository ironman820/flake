{
  flake.nixosModules.android =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        users.users.${config.ironman.user}.extraGroups = [ "adbusers" ];
        environment.systemPackages = with pkgs; [
          android-studio
          # TODO: Re-enable after importing custom package
          # open-android-backup
        ];
        programs.adb.enable = true;
        services.udev.packages = [
          pkgs.android-udev-rules
        ];
      };
    };
}
