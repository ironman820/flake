{inputs, ...}: {
  imports = with inputs; [
    disko.flakeModules.default
    home-manager.flakeModules.home-manager
    pkgs-by-name.flakeModule
  ];
  systems = [
    "x86_64-linux"
  ];
}
