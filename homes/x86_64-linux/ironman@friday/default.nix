{config, ...}: {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    user.name = config.snowfallorg.user.name;
  };
}
