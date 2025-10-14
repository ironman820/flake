{inputs, ...}: {
  imports = with inputs; [
    disko.flakeModules.default
    home-manager.flakeModules.home-manager
  ];
  systems = [
    "x86_64-linux"
  ];
}
